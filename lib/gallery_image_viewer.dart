/// A library to easily display images in a full-screen dialog.
/// It supports pinch & zoom, and paging through multiple images.
library gallery_image_viewer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/easy_image_provider.dart';
import 'src/easy_image_viewer_dismissible_dialog.dart';
import 'src/single_image_provider.dart';

export 'src/easy_image_provider.dart' show EasyImageProvider;
export 'src/single_image_provider.dart' show SingleImageProvider;
export 'src/multi_image_provider.dart' show MultiImageProvider;

export 'src/easy_image_view.dart' show EasyImageView;
export 'src/easy_image_view_pager.dart' show EasyImageViewPager;
export 'src/gallery_image_view.dart' show GalleryImageView;

// Defined here so we don't repeat ourselves
const _defaultBackgroundColor = Colors.black;
const _defaultCloseButtonColor = Colors.white;
const _defaultCloseButtonTooltip = 'Close';

/// Shows the given [imageProvider] in a full-screen [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onViewerDismissed] callback function is called when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The optional [swipeDismissible] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewer(
    BuildContext context, ImageProvider imageProvider,
    {bool immersive = true,
    void Function()? onViewerDismissed,
    String? titleImage,
    String? timeImage,
    String? descriptionImage,
    double? iconCloseSize,
    double? titleTextSize,
    double? descriptionTextSize,
    double? timeTextSize,
    double? topPositionCloseButton,
    double? rightPositionCloseButton,
    bool useSafeArea = false,
    bool swipeDismissible = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor,
    }) {
  return showImageViewerPager(context, SingleImageProvider(imageProvider),
      titleImage: titleImage,
      timeImage: timeImage,
      descriptionImage: descriptionImage,
      iconCloseSize: iconCloseSize,
      titleTextSize: titleTextSize,
      descriptionTextSize: descriptionTextSize,
      timeTextSize: timeTextSize,
      topPositionCloseButton: topPositionCloseButton,
      rightPositionCloseButton: rightPositionCloseButton,
      immersive: immersive,
      onViewerDismissed: onViewerDismissed != null ? (_) => onViewerDismissed() : null,
      useSafeArea: useSafeArea,
      swipeDismissible: swipeDismissible,
      backgroundColor: backgroundColor,
      closeButtonTooltip: closeButtonTooltip,
      closeButtonColor: closeButtonColor,);
}

/// Shows the images provided by the [imageProvider] in a full-screen PageView [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onPageChanged] callback function is called with the index of
/// the image when the user has swiped to another image.
/// The optional [onViewerDismissed] callback function is called with the index of
/// the image that is displayed when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The optional [swipeDismissible] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
Future<Dialog?> showImageViewerPager(
    BuildContext context, EasyImageProvider imageProvider,
    {bool immersive = true,
    void Function(int)? onPageChanged,
    void Function(int)? onViewerDismissed,
    String? titleImage,
    String? timeImage,
    String? descriptionImage,
    double? iconCloseSize,
    double? titleTextSize,
    double? descriptionTextSize,
    double? timeTextSize,
    double? topPositionCloseButton,
    double? rightPositionCloseButton,
    bool useSafeArea = false,
    bool swipeDismissible = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor,
    }) {
  if (immersive) {
    // Hide top and bottom bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  return showDialog<Dialog>(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) {
        return Stack(
          children: [
            EasyImageViewerDismissibleDialog(imageProvider,
                immersive: immersive,
                onPageChanged: onPageChanged,
                onViewerDismissed: onViewerDismissed,
                useSafeArea: useSafeArea,
                swipeDismissible: swipeDismissible,
                backgroundColor: backgroundColor,
                closeButtonColor: closeButtonColor,
                closeButtonSize: iconCloseSize,
                topPositionCloseButton: topPositionCloseButton,
                rightPositionCloseButton: rightPositionCloseButton,
                closeButtonTooltip: closeButtonTooltip),
                descriptionImage != null ? Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.fromLTRB(15, 12, 15, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                          child: Text(titleImage.toString(),  textAlign: TextAlign.left, maxLines: 3, overflow: TextOverflow.ellipsis,),),
                        
                        timeImage != null ? Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_sharp, color: Colors.white, size: 11,),
                              const SizedBox(width: 5),
                              DefaultTextStyle(
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontStyle: FontStyle.normal),
                              child: Text(timeImage,  textAlign: TextAlign.left,),),
                            ],
                          ),
                        ) : Container(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.normal,),
                                child: Text(descriptionImage,  textAlign: TextAlign.left,),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ) : Container()
          ],
        );
      });
}
