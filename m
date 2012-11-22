Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab2KVTvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259Ab2KVTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:47 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 36/46] staging: line6: drop variax guitar sysfs attr
Date: Thu, 22 Nov 2012 20:49:15 +0100
Message-Id: <1353613765-18690-37-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 22 ----------------------
 drivers/staging/line6/variax.h |  5 -----
 2 files changed, 27 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 4600d24..4db21a3 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -250,11 +250,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 				  sizeof(variax_request_bank) - 2) == 0) {
 			line6_dump_finished(&variax->dumpreq);
 			variax_startup6(variax);
-		} else if (memcmp(buf + 1, variax_init_model + 1,
-				  sizeof(variax_init_model) - 1) == 0) {
-			memcpy(variax->guitar,
-			       buf + sizeof(variax_init_model),
-			       sizeof(variax->guitar));
 		} else if (memcmp(buf + 1, variax_init_version + 1,
 				  sizeof(variax_init_version) - 1) == 0) {
 			variax_startup3(variax);
@@ -275,17 +270,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 	}
 }
 
-/*
-	"read" request on "guitar" special file.
-*/
-static ssize_t variax_get_guitar(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%s\n", variax->guitar);
-}
-
 #ifdef CONFIG_LINE6_USB_RAW
 
 static char *variax_alloc_sysex_buffer(struct usb_line6_variax *variax,
@@ -333,9 +317,6 @@ static ssize_t variax_set_raw2(struct device *dev,
 
 #endif
 
-/* Variax workbench special files: */
-static DEVICE_ATTR(guitar, S_IRUGO, variax_get_guitar, line6_nop_write);
-
 #ifdef CONFIG_LINE6_USB_RAW
 static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
 static DEVICE_ATTR(raw2, S_IWUSR, line6_nop_read, variax_set_raw2);
@@ -369,8 +350,6 @@ static void variax_destruct(struct usb_interface *interface)
 */
 static int variax_create_files2(struct device *dev)
 {
-	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_guitar));
 #ifdef CONFIG_LINE6_USB_RAW
 	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_raw2));
@@ -469,7 +448,6 @@ void line6_variax_disconnect(struct usb_interface *interface)
 	if (dev != NULL) {
 		/* remove sysfs entries: */
 		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_guitar);
 #ifdef CONFIG_LINE6_USB_RAW
 		device_remove_file(dev, &dev_attr_raw);
 		device_remove_file(dev, &dev_attr_raw2);
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index b5d6a66..f3d95fa 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -83,11 +83,6 @@ struct usb_line6_variax {
 	struct variax_model model_data;
 
 	/**
-		Name of connected guitar.
-	*/
-	unsigned char guitar[18];
-
-	/**
 		Handler for device initializaton.
 	*/
 	struct work_struct startup_work;
-- 
1.8.0

