Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2KVT7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:59:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab2KVTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:43 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 34/46] staging: line6: drop variax dump sysfs attr
Date: Thu, 22 Nov 2012 20:49:13 +0100
Message-Id: <1353613765-18690-35-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 8eec139..0f1846e 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -308,23 +308,6 @@ static ssize_t variax_set_active(struct device *dev,
 }
 
 /*
-	"read" request on "dump" special file.
-*/
-static ssize_t variax_get_dump(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	int retval;
-	retval = line6_dump_wait_interruptible(&variax->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &variax->model_data.control,
-	       sizeof(variax->model_data.control));
-	return sizeof(variax->model_data.control);
-}
-
-/*
 	"read" request on "guitar" special file.
 */
 static ssize_t variax_get_guitar(struct device *dev,
@@ -383,7 +366,6 @@ static ssize_t variax_set_raw2(struct device *dev,
 #endif
 
 /* Variax workbench special files: */
-static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
 static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active,
 		   variax_set_active);
 static DEVICE_ATTR(guitar, S_IRUGO, variax_get_guitar, line6_nop_write);
@@ -422,7 +404,6 @@ static void variax_destruct(struct usb_interface *interface)
 static int variax_create_files2(struct device *dev)
 {
 	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_active));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_guitar));
 #ifdef CONFIG_LINE6_USB_RAW
@@ -523,7 +504,6 @@ void line6_variax_disconnect(struct usb_interface *interface)
 	if (dev != NULL) {
 		/* remove sysfs entries: */
 		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_dump);
 		device_remove_file(dev, &dev_attr_active);
 		device_remove_file(dev, &dev_attr_guitar);
 #ifdef CONFIG_LINE6_USB_RAW
-- 
1.8.0

