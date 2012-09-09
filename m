Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2IIAna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 20:43:30 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62675 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2IIAn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 20:43:27 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: balbi@ti.com
Cc: puzzleduck@gmail.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: Conform with checkpatch -3 warnings, 1 error
Date: Sun,  9 Sep 2012 10:50:35 +1000
Message-Id: <1347151835-19028-1-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 3 checkpatch.sh warnings and 1 error in
drivers/usb/gadget/serial.c.
-sizeof brackets x2
-remove initialise to 0
-pr_warning to pr_warn

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/gadget/serial.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index 665c074..af69cd2 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -101,9 +101,8 @@ static struct usb_device_descriptor device_desc = {
 };
 
 static struct usb_otg_descriptor otg_descriptor = {
-	.bLength =		sizeof otg_descriptor,
+	.bLength =		sizeof(otg_descriptor),
 	.bDescriptorType =	USB_DT_OTG,
-
 	/* REVISIT SRP-only hardware is possible, although
 	 * it would not be called "OTG" ...
 	 */
@@ -127,7 +126,7 @@ static bool use_acm = true;
 module_param(use_acm, bool, 0);
 MODULE_PARM_DESC(use_acm, "Use CDC ACM, default=yes");
 
-static bool use_obex = false;
+static bool use_obex;
 module_param(use_obex, bool, 0);
 MODULE_PARM_DESC(use_obex, "Use CDC OBEX, default=no");
 
@@ -175,7 +174,7 @@ static int __init gs_bind(struct usb_composite_dev *cdev)
 	 */
 
 	/* device description: manufacturer, product */
-	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
+	snprintf(manufacturer, sizeof(manufacturer), "%s %s with %s",
 		init_utsname()->sysname, init_utsname()->release,
 		gadget->name);
 	status = usb_string_id(cdev);
@@ -212,7 +211,7 @@ static int __init gs_bind(struct usb_composite_dev *cdev)
 		 * things like configuration and altsetting numbering
 		 * can need hardware-specific attention though.
 		 */
-		pr_warning("gs_bind: controller '%s' not recognized\n",
+		pr_warn("gs_bind: controller '%s' not recognized\n",
 			gadget->name);
 		device_desc.bcdDevice =
 			cpu_to_le16(GS_VERSION_NUM | 0x0099);
-- 
1.7.2.5

