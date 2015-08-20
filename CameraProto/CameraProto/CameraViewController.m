//
//  CameraViewControllerr.m
//  CameraProto
//
//  Created by Tracy Lakin on 8/19/15.
//  Copyright (c) 2015 Prosper Marketplace, Inc. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController ()

@property (strong, nonatomic) IBOutlet UIImageView * cameraImageView;
@property (strong, nonatomic) IBOutlet UIButton    * selectPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton    * takePhotoButton;

@property (strong, nonatomic) IBOutlet UIView      * overlayView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle: @"Error"
                                                              message: @"No camera on device."
                                                             delegate: nil
                                                    cancelButtonTitle: @"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        self.takePhotoButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)takePhoto:(UIButton *)sender {

    UIImagePickerController * cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate      = self;
    cameraUI.allowsEditing = YES;
    cameraUI.sourceType    = UIImagePickerControllerSourceTypeCamera;

    [[NSBundle mainBundle] loadNibNamed:@"CameraOverlayView" owner:self options:nil];
    self.overlayView.frame = cameraUI.cameraOverlayView.frame;
    cameraUI.cameraOverlayView = self.overlayView;
    self.overlayView = nil;


    // Allow photos only, no movies.
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    // The following will allow both photos and movies. I.e. all the camera's media types:
//    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];

    [self presentViewController:cameraUI animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {

    UIImagePickerController * cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    cameraUI.allowsEditing = YES;
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:cameraUI animated:YES completion:NULL];
}

#pragma mark - delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage * originalImage, * editedImage, * imageToSave;

    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        editedImage   = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];

        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll.
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);

        // Save image for app to work with.
        self.cameraImageView.image = imageToSave;       // HERE IS THE IMAGE TO USE.
    }
 
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
