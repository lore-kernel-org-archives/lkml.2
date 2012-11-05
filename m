Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2KELeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:34:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41374 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2KELet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:34:49 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
Date: Mon,  5 Nov 2012 20:34:42 +0900
Message-Id: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
index f1bd159..f57eb3b 100644
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ b/drivers/staging/media/go7007/s2250-loader.c
@@ -55,16 +55,16 @@ static int s2250loader_probe(struct usb_interface *interface,
 
 	usbdev = usb_get_dev(interface_to_usbdev(interface));
 	if (!usbdev) {
-		printk(KERN_ERR "Enter s2250loader_probe failed\n");
+		dev_err(&interface->dev, "Enter s2250loader_probe failed\n");
 		return -1;
 	}
-	printk(KERN_INFO "Enter s2250loader_probe 2.6 kernel\n");
-	printk(KERN_INFO "vendor id 0x%x, device id 0x%x devnum:%d\n",
-	   usbdev->descriptor.idVendor, usbdev->descriptor.idProduct,
-	   usbdev->devnum);
+	dev_info(&interface->dev, "Enter s2250loader_probe 2.6 kernel\n");
+	dev_info(&interface->dev, "vendor id 0x%x, device id 0x%x devnum:%d\n",
+		 usbdev->descriptor.idVendor, usbdev->descriptor.idProduct,
+		 usbdev->devnum);
 
 	if (usbdev->descriptor.bNumConfigurations != 1) {
-		printk(KERN_ERR "can't handle multiple config\n");
+		dev_err(&interface->dev, "can't handle multiple config\n");
 		return -1;
 	}
 	mutex_lock(&s2250_dev_table_mutex);
@@ -75,31 +75,32 @@ static int s2250loader_probe(struct usb_interface *interface,
 	}
 
 	if (minor < 0 || minor >= MAX_DEVICES) {
-		printk(KERN_ERR "Invalid minor: %d\n", minor);
+		dev_err(&interface->dev, "Invalid minor: %d\n", minor);
 		goto failed;
 	}
 
 	/* Allocate dev data structure */
 	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
 	if (s == NULL) {
-		printk(KERN_ERR "Out of memory\n");
+		dev_err(&interface->dev, "Out of memory\n");
 		goto failed;
 	}
 	s2250_dev_table[minor] = s;
 
-	printk(KERN_INFO "s2250loader_probe: Device %d on Bus %d Minor %d\n",
-		usbdev->devnum, usbdev->bus->busnum, minor);
+	dev_info(&interface->dev,
+		 "s2250loader_probe: Device %d on Bus %d Minor %d\n",
+		 usbdev->devnum, usbdev->bus->busnum, minor);
 
 	memset(s, 0, sizeof(device_extension_t));
 	s->usbdev = usbdev;
-	printk(KERN_INFO "loading 2250 loader\n");
+	dev_info(&interface->dev, "loading 2250 loader\n");
 
 	kref_init(&(s->kref));
 
 	mutex_unlock(&s2250_dev_table_mutex);
 
 	if (request_firmware(&fw, S2250_LOADER_FIRMWARE, &usbdev->dev)) {
-		printk(KERN_ERR
+		dev_err(&interface->dev,
 			"s2250: unable to load firmware from file \"%s\"\n",
 			S2250_LOADER_FIRMWARE);
 		goto failed2;
@@ -107,12 +108,12 @@ static int s2250loader_probe(struct usb_interface *interface,
 	ret = usb_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
-		printk(KERN_ERR "loader download failed\n");
+		dev_err(&interface->dev, "loader download failed\n");
 		goto failed2;
 	}
 
 	if (request_firmware(&fw, S2250_FIRMWARE, &usbdev->dev)) {
-		printk(KERN_ERR
+		dev_err(&interface->dev,
 			"s2250: unable to load firmware from file \"%s\"\n",
 			S2250_FIRMWARE);
 		goto failed2;
@@ -120,7 +121,7 @@ static int s2250loader_probe(struct usb_interface *interface,
 	ret = usb_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
-		printk(KERN_ERR "firmware_s2250 download failed\n");
+		dev_err(&interface->dev, "firmware_s2250 download failed\n");
 		goto failed2;
 	}
 
@@ -133,14 +134,14 @@ failed2:
 	if (s)
 		kref_put(&(s->kref), s2250loader_delete);
 
-	printk(KERN_ERR "probe failed\n");
+	dev_err(&interface->dev, "probe failed\n");
 	return -1;
 }
 
 static void s2250loader_disconnect(struct usb_interface *interface)
 {
 	pdevice_extension_t s;
-	printk(KERN_INFO "s2250: disconnect\n");
+	dev_info(&interface->dev, "s2250: disconnect\n");
 	s = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 	kref_put(&(s->kref), s2250loader_delete);
-- 
1.7.9.5

