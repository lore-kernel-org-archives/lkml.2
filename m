Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab1F1QfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764Ab1F1QcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:08 -0400
Date: Mon, 27 Jun 2011 23:17:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 09/13] [media] uvcvideo: Use LINUX_VERSION_CODE for
 VIDIOC_QUERYCAP
Message-ID: <20110627231732.14593452@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uvcvideo doesn't use vidioc_ioctl2. As the API is changing to use
a common version for all drivers, we need to expliticly fix this
driver.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..749c722 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -31,6 +31,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/version.h>
 #include <asm/atomic.h>
 #include <asm/unaligned.h>
 
@@ -1857,7 +1858,7 @@ static int uvc_probe(struct usb_interface *intf,
 			sizeof(dev->mdev.serial));
 	strcpy(dev->mdev.bus_info, udev->devpath);
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	dev->mdev.driver_version = DRIVER_VERSION_NUMBER;
+	dev->mdev.driver_version = LINUX_VERSION_CODE;
 	if (media_device_register(&dev->mdev) < 0)
 		goto error;
 
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 543a803..cdd967b 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -571,7 +571,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		strlcpy(cap->card, vdev->name, sizeof cap->card);
 		usb_make_path(stream->dev->udev,
 			      cap->bus_info, sizeof(cap->bus_info));
-		cap->version = DRIVER_VERSION_NUMBER;
+		cap->version = LINUX_VERSION_CODE;
 		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 					  | V4L2_CAP_STREAMING;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 20107fd..df32a43 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -183,8 +183,7 @@ struct uvc_xu_control {
  * Driver specific constants.
  */
 
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(1, 1, 0)
-#define DRIVER_VERSION		"v1.1.0"
+#define DRIVER_VERSION		"1.1.1"
 
 /* Number of isochronous URBs. */
 #define UVC_URBS		5
-- 
1.7.1


