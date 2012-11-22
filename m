Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2KVT6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:58:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107Ab2KVTvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:45 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 35/46] staging: line6: drop variax active sysfs attr
Date: Thu, 22 Nov 2012 20:49:14 +0100
Message-Id: <1353613765-18690-36-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_string() function has no other callers so remove it too.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 0f1846e..4600d24 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -276,38 +276,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 }
 
 /*
-	"read" request on "active" special file.
-*/
-static ssize_t variax_get_active(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n",
-		       variax->buffer_activate[VARIAX_OFFSET_ACTIVATE]);
-}
-
-/*
-	"write" request on "active" special file.
-*/
-static ssize_t variax_set_active(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	variax_activate_async(variax, value ? 1 : 0);
-	return count;
-}
-
-/*
 	"read" request on "guitar" special file.
 */
 static ssize_t variax_get_guitar(struct device *dev,
@@ -366,8 +334,6 @@ static ssize_t variax_set_raw2(struct device *dev,
 #endif
 
 /* Variax workbench special files: */
-static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active,
-		   variax_set_active);
 static DEVICE_ATTR(guitar, S_IRUGO, variax_get_guitar, line6_nop_write);
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -404,7 +370,6 @@ static void variax_destruct(struct usb_interface *interface)
 static int variax_create_files2(struct device *dev)
 {
 	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_active));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_guitar));
 #ifdef CONFIG_LINE6_USB_RAW
 	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
@@ -504,7 +469,6 @@ void line6_variax_disconnect(struct usb_interface *interface)
 	if (dev != NULL) {
 		/* remove sysfs entries: */
 		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_active);
 		device_remove_file(dev, &dev_attr_guitar);
 #ifdef CONFIG_LINE6_USB_RAW
 		device_remove_file(dev, &dev_attr_raw);
-- 
1.8.0

