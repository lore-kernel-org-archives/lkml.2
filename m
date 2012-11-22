Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2KVT7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:59:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab2KVTvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:40 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 32/46] staging: line6: drop variax name sysfs attr
Date: Thu, 22 Nov 2012 20:49:11 +0100
Message-Id: <1353613765-18690-33-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 31ece34..94a9f71 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -218,17 +218,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 			    VARIAX_MODEL_MESSAGE_LENGTH) {
 				switch (variax->dumpreq.in_progress) {
 				case VARIAX_DUMP_PASS1:
-					variax_decode(buf +
-						      VARIAX_MODEL_HEADER_LENGTH,
-						      (unsigned char *)
-						      &variax->model_data,
-						      (sizeof
-						       (variax->model_data.
-							name) +
-						       sizeof(variax->
-							      model_data.
-							      control)
-						       / 2) * 2);
 					line6_dump_request_async
 					    (&variax->dumpreq, &variax->line6,
 					     1, VARIAX_DUMP_PASS2);
@@ -338,19 +327,6 @@ static ssize_t get_string(char *buf, const char *data, int length)
 }
 
 /*
-	"read" request on "name" special file.
-*/
-static ssize_t variax_get_name(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	line6_dump_wait_interruptible(&variax->dumpreq);
-	return get_string(buf, variax->model_data.name,
-			  sizeof(variax->model_data.name));
-}
-
-/*
 	"read" request on "bank" special file.
 */
 static ssize_t variax_get_bank(struct device *dev,
@@ -438,7 +414,6 @@ static ssize_t variax_set_raw2(struct device *dev,
 #endif
 
 /* Variax workbench special files: */
-static DEVICE_ATTR(name, S_IRUGO, variax_get_name, line6_nop_write);
 static DEVICE_ATTR(bank, S_IRUGO, variax_get_bank, line6_nop_write);
 static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
 static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active,
@@ -479,7 +454,6 @@ static void variax_destruct(struct usb_interface *interface)
 static int variax_create_files2(struct device *dev)
 {
 	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_bank));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_active));
@@ -582,7 +556,6 @@ void line6_variax_disconnect(struct usb_interface *interface)
 	if (dev != NULL) {
 		/* remove sysfs entries: */
 		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_name);
 		device_remove_file(dev, &dev_attr_bank);
 		device_remove_file(dev, &dev_attr_dump);
 		device_remove_file(dev, &dev_attr_active);
-- 
1.8.0

