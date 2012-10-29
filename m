Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab2J2LFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:05:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab2J2LFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:05:49 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 6/7] staging/gdm72xx: Use dev_ printks in gdm_usb.c
Date: Mon, 29 Oct 2012 20:05:43 +0900
Message-Id: <1351508743-1892-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/gdm72xx/gdm_usb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 39db582..435037f 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -305,7 +305,7 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	unsigned long flags;
 
 	if (!udev->usbdev) {
-		printk(KERN_ERR "%s: No such device\n", __func__);
+		dev_err(&usbdev->dev, "%s: No such device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -484,7 +484,7 @@ static int gdm_usb_receive(void *priv_dev,
 	unsigned long flags;
 
 	if (!udev->usbdev) {
-		printk(KERN_ERR "%s: No such device\n", __func__);
+		dev_err(&usbdev->dev, "%s: No such device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -559,9 +559,9 @@ static int gdm_usb_probe(struct usb_interface *intf,
 	idProduct = L2H(usbdev->descriptor.idProduct);
 	bcdDevice = L2H(usbdev->descriptor.bcdDevice);
 
-	printk(KERN_INFO "Found GDM USB VID = 0x%04x PID = 0x%04x...\n",
-		idVendor, idProduct);
-	printk(KERN_INFO "GCT WiMax driver version %s\n", DRIVER_VERSION);
+	dev_info(&intf->dev, "Found GDM USB VID = 0x%04x PID = 0x%04x...\n",
+		 idVendor, idProduct);
+	dev_info(&intf->dev, "GCT WiMax driver version %s\n", DRIVER_VERSION);
 
 
 	if (idProduct == EMERGENCY_PID) {
-- 
1.7.9.5

