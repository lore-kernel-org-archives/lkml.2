Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2J2LGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:06:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab2J2LGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:06:02 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 7/7] staging/gdm72xx: Use dev_ printks in usb_boot.c
Date: Mon, 29 Oct 2012 20:05:57 +0900
Message-Id: <1351508757-1928-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
References: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/usb_boot.c |   49 ++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 0787188..3e2103a 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -82,7 +82,8 @@ static int gdm_wibro_send(struct usb_device *usbdev, void *data, int len)
 			&actual, 1000);
 
 	if (ret < 0) {
-		printk(KERN_ERR "Error : usb_bulk_msg ( result = %d )\n", ret);
+		dev_err(&usbdev->dev, "Error : usb_bulk_msg ( result = %d )\n",
+			ret);
 		return ret;
 	}
 	return 0;
@@ -97,8 +98,8 @@ static int gdm_wibro_recv(struct usb_device *usbdev, void *data, int len)
 			&actual, 5000);
 
 	if (ret < 0) {
-		printk(KERN_ERR "Error : usb_bulk_msg(recv) ( result = %d )\n",
-			ret);
+		dev_err(&usbdev->dev,
+			"Error : usb_bulk_msg(recv) ( result = %d )\n", ret);
 		return ret;
 	}
 	return 0;
@@ -150,20 +151,20 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 
 	ret = request_firmware(&firm, img_name, &usbdev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR
-		       "requesting firmware %s failed with error %d\n",
+		dev_err(&usbdev->dev,
+			"requesting firmware %s failed with error %d\n",
 			img_name, ret);
 		return ret;
 	}
 
 	tx_buf = kmalloc(DOWNLOAD_SIZE, GFP_KERNEL);
 	if (tx_buf == NULL) {
-		printk(KERN_ERR "Error: kmalloc\n");
+		dev_err(&usbdev->dev, "Error: kmalloc\n");
 		return -ENOMEM;
 	}
 
 	if (firm->size < sizeof(hdr)) {
-		printk(KERN_ERR "gdmwm: Cannot read the image info.\n");
+		dev_err(&usbdev->dev, "Cannot read the image info.\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -172,23 +173,22 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 	array_le32_to_cpu((u32 *)&hdr, 19);
 #if 0
 	if (hdr.magic_code != 0x10767fff) {
-		printk(KERN_ERR "gdmwm: Invalid magic code 0x%08x\n",
+		dev_err(&usbdev->dev, "Invalid magic code 0x%08x\n",
 			hdr.magic_code);
 		ret = -EINVAL;
 		goto out;
 	}
 #endif
 	if (hdr.count > MAX_IMG_CNT) {
-		printk(KERN_ERR "gdmwm: Too many images. %d\n", hdr.count);
+		dev_err(&usbdev->dev, "Too many images. %d\n", hdr.count);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	for (i = 0; i < hdr.count; i++) {
 		if (hdr.offset[i] > hdr.len) {
-			printk(KERN_ERR "gdmwm: Invalid offset. "
-				"Entry = %d Offset = 0x%08x "
-				"Image length = 0x%08x\n",
+			dev_err(&usbdev->dev,
+				"Invalid offset. Entry = %d Offset = 0x%08x Image length = 0x%08x\n",
 				i, hdr.offset[i], hdr.len);
 			ret = -EINVAL;
 			goto out;
@@ -196,7 +196,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 
 		pos = hdr.offset[i];
 		if (firm->size < sizeof(fw_info) + pos) {
-			printk(KERN_ERR "gdmwm: Cannot read the FW info.\n");
+			dev_err(&usbdev->dev, "Cannot read the FW info.\n");
 			ret = -EIO;
 			goto out;
 		}
@@ -205,7 +205,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 		array_le32_to_cpu((u32 *)&fw_info, 8);
 #if 0
 		if ((fw_info.id & 0xfffff000) != 0x10767000) {
-			printk(KERN_ERR "gdmwm: Invalid FW id. 0x%08x\n",
+			dev_err(&usbdev->dev, "Invalid FW id. 0x%08x\n",
 				fw_info.id);
 			ret = -EIO;
 			goto out;
@@ -217,7 +217,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 
 		pos = hdr.offset[i] + fw_info.kernel_offset;
 		if (firm->size < fw_info.kernel_len + pos) {
-			printk(KERN_ERR "gdmwm: Kernel FW is too small.\n");
+			dev_err(&usbdev->dev, "Kernel FW is too small.\n");
 			goto out;
 		}
 
@@ -225,24 +225,25 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 				fw_info.kernel_len, DN_KERNEL_MAGIC_NUMBER);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "GCT: Kernel download success.\n");
+		dev_info(&usbdev->dev, "GCT: Kernel download success.\n");
 
 		pos = hdr.offset[i] + fw_info.rootfs_offset;
 		if (firm->size < fw_info.rootfs_len + pos) {
-			printk(KERN_ERR "gdmwm: Filesystem FW is too small.\n");
+			dev_err(&usbdev->dev, "Filesystem FW is too small.\n");
 			goto out;
 		}
 		ret = download_image(usbdev, firm, pos, fw_info.rootfs_len,
 				DN_ROOTFS_MAGIC_NUMBER);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "GCT: Filesystem download success.\n");
+		dev_info(&usbdev->dev, "GCT: Filesystem download success.\n");
 
 		break;
 	}
 
 	if (i == hdr.count) {
-		printk(KERN_ERR "Firmware for gsk%x is not installed.\n", pid);
+		dev_err(&usbdev->dev, "Firmware for gsk%x is not installed.\n",
+			pid);
 		ret = -EINVAL;
 	}
 out:
@@ -293,15 +294,15 @@ static int em_download_image(struct usb_device *usbdev, const char *img_name,
 
 	ret = request_firmware(&firm, img_name, &usbdev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR
-		       "requesting firmware %s failed with error %d\n",
+		dev_err(&usbdev->dev,
+			"requesting firmware %s failed with error %d\n",
 			img_name, ret);
 		return ret;
 	}
 
 	buf = kmalloc(DOWNLOAD_CHUCK + pad_size, GFP_KERNEL);
 	if (buf == NULL) {
-		printk(KERN_ERR "Error: kmalloc\n");
+		dev_err(&usbdev->dev, "Error: kmalloc\n");
 		return -ENOMEM;
 	}
 
@@ -366,12 +367,12 @@ int usb_emergency(struct usb_device *usbdev)
 	ret = em_download_image(usbdev, kern_name, KERNEL_TYPE_STRING);
 	if (ret < 0)
 		return ret;
-	printk(KERN_INFO "GCT Emergency: Kernel download success.\n");
+	dev_err(&usbdev->dev, "GCT Emergency: Kernel download success.\n");
 
 	ret = em_download_image(usbdev, fs_name, FS_TYPE_STRING);
 	if (ret < 0)
 		return ret;
-	printk(KERN_INFO "GCT Emergency: Filesystem download success.\n");
+	dev_info(&usbdev->dev, "GCT Emergency: Filesystem download success.\n");
 
 	ret = em_fw_reset(usbdev);
 
-- 
1.7.9.5

