Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1A3TF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:05:26 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:53644
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753767Ab1A3TFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:05:25 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, tvh@informatik.uni-kiel.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20Staging=3A=20usbvideo=3A=20vicam=3A=20fixed=20some=20coding=20style=20issues?=
Date: Sun, 30 Jan 2011 20:04:55 +0100
Message-Id: <1296414295-5602-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Null-Tag: 64d77cf3d6bf8698b169ee3dd7b05a8c
X-Authenticated-Sender: user tvh from 86.103.153.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed coding style issues.

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/usbvideo/vicam.c |  164 ++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/usbvideo/vicam.c b/drivers/staging/usbvideo/vicam.c
index ecdb121..a6816a4 100644
--- a/drivers/staging/usbvideo/vicam.c
+++ b/drivers/staging/usbvideo/vicam.c
@@ -48,13 +48,13 @@
 #include <linux/ihex.h>
 #include "usbvideo.h"
 
-// #define VICAM_DEBUG
+/* #define VICAM_DEBUG */
 
 #ifdef VICAM_DEBUG
-#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __func__, lineno, ##args)
-#define DBG(fmt,args...) ADBG((__LINE__),KERN_DEBUG __FILE__"(%ld):%s (%d):"fmt,##args)
+#define ADBG(lineno, fmt, args...) printk(fmt, jiffies, __func__, lineno, ##args)
+#define DBG(fmt, args...) ADBG((__LINE__), KERN_DEBUG __FILE__"(%ld):%s (%d):"fmt, ##args)
 #else
-#define DBG(fmn,args...) do {} while(0)
+#define DBG(fmn, args...) do {} while (0)
 #endif
 
 #define DRIVER_AUTHOR           "Joe Burks, jburks@wavicle.org"
@@ -118,15 +118,15 @@ static void rvfree(void *mem, unsigned long size)
 }
 
 struct vicam_camera {
-	u16 shutter_speed;	// capture shutter speed
-	u16 gain;		// capture gain
+	u16 shutter_speed;	/* capture shutter speed */
+	u16 gain;		/* capture gain */
 
-	u8 *raw_image;		// raw data captured from the camera
-	u8 *framebuf;		// processed data in RGB24 format
-	u8 *cntrlbuf;		// area used to send control msgs
+	u8 *raw_image;		/* raw data captured from the camera */
+	u8 *framebuf;		/* processed data in RGB24 format */
+	u8 *cntrlbuf;		/* area used to send control msgs */
 
-	struct video_device vdev;	// v4l video device
-	struct usb_device *udev;	// usb device
+	struct video_device vdev;	/* v4l video device */
+	struct usb_device *udev;	/* usb device */
 
 	/* guard against simultaneous accesses to the camera */
 	struct mutex cam_lock;
@@ -137,7 +137,7 @@ struct vicam_camera {
 	int needsDummyRead;
 };
 
-static int vicam_probe( struct usb_interface *intf, const struct usb_device_id *id);
+static int vicam_probe(struct usb_interface *intf, const struct usb_device_id *id);
 static void vicam_disconnect(struct usb_interface *intf);
 static void read_frame(struct vicam_camera *cam, int framenum);
 static void vicam_decode_color(const u8 *, u8 *);
@@ -219,12 +219,12 @@ set_camera_power(struct vicam_camera *cam, int state)
 {
 	int status;
 
-	if ((status = send_control_msg(cam, 0x50, state, 0, NULL, 0)) < 0)
+	status = send_control_msg(cam, 0x50, state, 0, NULL, 0));
+	if (status < 0)
 		return status;
 
-	if (state) {
+	if (state)
 		send_control_msg(cam, 0x55, 1, 0, NULL, 0);
-	}
 
 	return 0;
 }
@@ -307,11 +307,11 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 		{
 			struct video_picture vp;
 			DBG("VIDIOCGPICT\n");
-			memset(&vp, 0, sizeof (struct video_picture));
+			memset(&vp, 0, sizeof(struct video_picture));
 			vp.brightness = cam->gain << 8;
 			vp.depth = 24;
 			vp.palette = VIDEO_PALETTE_RGB24;
-			if (copy_to_user(user_arg, &vp, sizeof (struct video_picture)))
+			if (copy_to_user(user_arg, &vp, sizeof(struct video_picture)))
 				retval = -EFAULT;
 			break;
 		}
@@ -355,8 +355,8 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 			if (copy_to_user(user_arg, (void *)&vw, sizeof(vw)))
 				retval = -EFAULT;
 
-			// I'm not sure what the deal with a capture window is, it is very poorly described
-			// in the doc.  So I won't support it now.
+			/* I'm not sure what the deal with a capture window is, it is very poorly described
+			 * in the doc.  So I won't support it now. */
 			break;
 		}
 
@@ -372,7 +372,7 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 
 			DBG("VIDIOCSWIN %d x %d\n", vw.width, vw.height);
 
-			if ( vw.width != 320 || vw.height != 240 )
+			if (vw.width != 320 || vw.height != 240)
 				retval = -EFAULT;
 
 			break;
@@ -385,7 +385,7 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 			int i;
 
 			DBG("VIDIOCGMBUF\n");
-			memset(&vm, 0, sizeof (vm));
+			memset(&vm, 0, sizeof(vm));
 			vm.size =
 			    VICAM_MAX_FRAME_SIZE * VICAM_FRAMES;
 			vm.frames = VICAM_FRAMES;
@@ -401,23 +401,24 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 	case VIDIOCMCAPTURE:
 		{
 			struct video_mmap vm;
-			// int video_size;
+			/* int video_size; */
 
 			if (copy_from_user((void *)&vm, user_arg, sizeof(vm))) {
 				retval = -EFAULT;
 				break;
 			}
 
-			DBG("VIDIOCMCAPTURE frame=%d, height=%d, width=%d, format=%d.\n",vm.frame,vm.width,vm.height,vm.format);
+			DBG("VIDIOCMCAPTURE frame=%d, height=%d, width=%d, format=%d.\n",
+			    vm.frame, vm.width, vm.height, vm.format);
 
-			if ( vm.frame >= VICAM_FRAMES || vm.format != VIDEO_PALETTE_RGB24 )
+			if (vm.frame >= VICAM_FRAMES || vm.format != VIDEO_PALETTE_RGB24)
 				retval = -EINVAL;
 
-			// in theory right here we'd start the image capturing
-			// (fill in a bulk urb and submit it asynchronously)
-			//
-			// Instead we're going to do a total hack job for now and
-			// retrieve the frame in VIDIOCSYNC
+			/* in theory right here we'd start the image capturing
+			 * (fill in a bulk urb and submit it asynchronously)
+			 *
+			 * Instead we're going to do a total hack job for now and
+			 * retrieve the frame in VIDIOCSYNC */
 
 			break;
 		}
@@ -435,7 +436,7 @@ vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 			read_frame(cam, frame);
 			vicam_decode_color(cam->raw_image,
 					   cam->framebuf +
-					   frame * VICAM_MAX_FRAME_SIZE );
+					   frame * VICAM_MAX_FRAME_SIZE);
 
 			break;
 		}
@@ -522,7 +523,7 @@ vicam_open(struct file *file)
 	mutex_unlock(&cam->cam_lock);
 
 
-	// First upload firmware, then turn the camera on
+	/* First upload firmware, then turn the camera on */
 
 	if (!cam->is_initialized) {
 		initialize_camera(cam);
@@ -562,9 +563,8 @@ vicam_close(struct file *file)
 
 	mutex_unlock(&cam->cam_lock);
 
-	if (!open_count && !udev) {
+	if (!open_count && !udev)
 		kfree(cam);
-	}
 
 	return 0;
 }
@@ -582,57 +582,55 @@ static void vicam_decode_color(const u8 *data, u8 *rgb)
 
 	data += VICAM_HEADER_SIZE;
 
-	for( i = 0; i < 240; i++, data += 512 ) {
-		const int y = ( i * 242 ) / 240;
+	for (i = 0; i < 240; i++, data += 512) {
+		const int y = (i * 242) / 240;
 
 		int j, prevX, nextX;
 		int Y, Cr, Cb;
 
-		if ( y == 242 - 1 ) {
+		if (y == 242 - 1)
 			nextY = -512;
-		}
 
 		prevX = 1;
 		nextX = 1;
 
-		for ( j = 0; j < 320; j++, rgb += 3 ) {
-			const int x = ( j * 512 ) / 320;
+		for (j = 0; j < 320; j++, rgb += 3) {
+			const int x = (j * 512) / 320;
 			const u8 * const src = &data[x];
 
-			if ( x == 512 - 1 ) {
+			if (x == 512 - 1)
 				nextX = -1;
-			}
 
-			Cr = ( src[prevX] - src[0] ) +
-				( src[nextX] - src[0] );
+			Cr = (src[prevX] - src[0]) +
+				(src[nextX] - src[0]);
 			Cr /= 2;
 
-			Cb = ( src[prevY] - src[prevX + prevY] ) +
-				( src[prevY] - src[nextX + prevY] ) +
-				( src[nextY] - src[prevX + nextY] ) +
-				( src[nextY] - src[nextX + nextY] );
+			Cb = (src[prevY] - src[prevX + prevY]) +
+				(src[prevY] - src[nextX + prevY]) +
+				(src[nextY] - src[prevX + nextY]) +
+				(src[nextY] - src[nextX + nextY]);
 			Cb /= 4;
 
-			Y = 1160 * ( src[0] + ( Cr / 2 ) - 16 );
+			Y = 1160 * (src[0] + (Cr / 2) - 16);
 
-			if ( i & 1 ) {
+			if (i & 1) {
 				int Ct = Cr;
 				Cr = Cb;
 				Cb = Ct;
 			}
 
-			if ( ( x ^ i ) & 1 ) {
+			if ((x ^ i) & 1) {
 				Cr = -Cr;
 				Cb = -Cb;
 			}
 
-			rgb[0] = clamp( ( ( Y + ( 2017 * Cb ) ) +
-					500 ) / 900, 0, 255 );
-			rgb[1] = clamp( ( ( Y - ( 392 * Cb ) -
-					  ( 813 * Cr ) ) +
-					  500 ) / 1000, 0, 255 );
-			rgb[2] = clamp( ( ( Y + ( 1594 * Cr ) ) +
-					500 ) / 1300, 0, 255 );
+			rgb[0] = clamp(((Y + (2017 * Cb)) +
+					500) / 900, 0, 255);
+			rgb[1] = clamp(((Y - (392 * Cb) -
+					  (813 * Cr)) +
+					  500) / 1000, 0, 255);
+			rgb[2] = clamp(((Y + (1594 * Cr)) +
+					500) / 1300, 0, 255);
 
 			prevX = -1;
 		}
@@ -655,15 +653,15 @@ read_frame(struct vicam_camera *cam, int framenum)
 	}
 
 	memset(request, 0, 16);
-	request[0] = cam->gain;	// 0 = 0% gain, FF = 100% gain
+	request[0] = cam->gain;	/* 0 = 0% gain, FF = 100% gain */
 
-	request[1] = 0;	// 512x242 capture
+	request[1] = 0;	/* 512x242 capture */
 
-	request[2] = 0x90;	// the function of these two bytes
-	request[3] = 0x07;	// is not yet understood
+	request[2] = 0x90;	/* the function of these two bytes */
+	request[3] = 0x07;	/* is not yet understood */
 
 	if (cam->shutter_speed > 60) {
-		// Short exposure
+		/* Short exposure */
 		realShutter =
 		    ((-15631900 / cam->shutter_speed) + 260533) / 1000;
 		request[4] = realShutter & 0xFF;
@@ -671,7 +669,7 @@ read_frame(struct vicam_camera *cam, int framenum)
 		request[6] = 0x03;
 		request[7] = 0x01;
 	} else {
-		// Long exposure
+		/* Long exposure */
 		realShutter = 15600 / cam->shutter_speed - 1;
 		request[4] = 0;
 		request[5] = 0;
@@ -679,15 +677,14 @@ read_frame(struct vicam_camera *cam, int framenum)
 		request[7] = realShutter >> 8;
 	}
 
-	// Per John Markus Bjørndalen, byte at index 8 causes problems if it isn't 0
+	/* Per John Markus Bjørndalen, byte at index 8 causes problems if it isn't 0*/
 	request[8] = 0;
-	// bytes 9-15 do not seem to affect exposure or image quality
+	/* bytes 9-15 do not seem to affect exposure or image quality */
 
 	mutex_lock(&cam->cam_lock);
 
-	if (!cam->udev) {
+	if (!cam->udev)
 		goto done;
-	}
 
 	n = __send_control_msg(cam, 0x51, 0x80, 0, request, 16);
 
@@ -712,7 +709,7 @@ read_frame(struct vicam_camera *cam, int framenum)
 }
 
 static ssize_t
-vicam_read( struct file *file, char __user *buf, size_t count, loff_t *ppos )
+vicam_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct vicam_camera *cam = file->private_data;
 
@@ -732,15 +729,13 @@ vicam_read( struct file *file, char __user *buf, size_t count, loff_t *ppos )
 
 	count = min_t(size_t, count, VICAM_MAX_FRAME_SIZE - *ppos);
 
-	if (copy_to_user(buf, &cam->framebuf[*ppos], count)) {
+	if (copy_to_user(buf, &cam->framebuf[*ppos], count))
 		count = -EFAULT;
-	} else {
+	else
 		*ppos += count;
-	}
 
-	if (count == VICAM_MAX_FRAME_SIZE) {
+	if (count == VICAM_MAX_FRAME_SIZE)
 		*ppos = 0;
-	}
 
 	return count;
 }
@@ -749,7 +744,7 @@ vicam_read( struct file *file, char __user *buf, size_t count, loff_t *ppos )
 static int
 vicam_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	// TODO: allocate the raw frame buffer if necessary
+	/* TODO: allocate the raw frame buffer if necessary */
 	unsigned long page, pos;
 	unsigned long start = vma->vm_start;
 	unsigned long size  = vma->vm_end-vma->vm_start;
@@ -793,9 +788,9 @@ static const struct v4l2_file_operations vicam_fops = {
 };
 
 static struct video_device vicam_template = {
-	.name 		= "ViCam-based USB Camera",
-	.fops 		= &vicam_fops,
-	.release 	= video_device_release_empty,
+	.name		= "ViCam-based USB Camera",
+	.fops		= &vicam_fops,
+	.release	= video_device_release_empty,
 };
 
 /* table of devices that work with this driver */
@@ -823,7 +818,7 @@ static struct usb_driver vicam_driver = {
  *	this driver might be interested in.
  */
 static int
-vicam_probe( struct usb_interface *intf, const struct usb_device_id *id)
+vicam_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	int bulkEndpoint = 0;
@@ -847,8 +842,8 @@ vicam_probe( struct usb_interface *intf, const struct usb_device_id *id)
 		       "No bulk in endpoint was found ?! (this is bad)\n");
 	}
 
-	if ((cam =
-	     kzalloc(sizeof (struct vicam_camera), GFP_KERNEL)) == NULL) {
+	cam = kzalloc(sizeof(struct vicam_camera), GFP_KERNEL);
+	if (cam == NULL) {
 		printk(KERN_WARNING
 		       "could not allocate kernel memory for vicam_camera struct\n");
 		return -ENOMEM;
@@ -874,7 +869,7 @@ vicam_probe( struct usb_interface *intf, const struct usb_device_id *id)
 	printk(KERN_INFO "ViCam webcam driver now controlling device %s\n",
 		video_device_node_name(&cam->vdev));
 
-	usb_set_intfdata (intf, cam);
+	usb_set_intfdata(intf, cam);
 
 	return 0;
 }
@@ -883,8 +878,8 @@ static void
 vicam_disconnect(struct usb_interface *intf)
 {
 	int open_count;
-	struct vicam_camera *cam = usb_get_intfdata (intf);
-	usb_set_intfdata (intf, NULL);
+	struct vicam_camera *cam = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
 
 	/* we must unregister the device before taking its
 	 * cam_lock. This is because the video open call
@@ -914,9 +909,8 @@ vicam_disconnect(struct usb_interface *intf)
 
 	mutex_unlock(&cam->cam_lock);
 
-	if (!open_count) {
+	if (!open_count)
 		kfree(cam);
-	}
 
 	printk(KERN_DEBUG "ViCam-based WebCam disconnected\n");
 }
-- 
1.7.3.5

