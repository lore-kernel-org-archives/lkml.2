Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0FYWua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 18:50:30 -0400
Received: from qmta02.westchester.pa.hmc1.comcast.net ([76.96.53.9]:46855 "EHLO
	qmta02.westchester.pa.hmc1.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756824Ab0FYWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 18:50:29 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 18:50:29 EDT
From: Rob Emanuele <rob@emanuele.us>
To: linux-kernel@vger.kernel.org
Cc: Rob Emanuele <rob@emanuele.us>
Subject: [PATCH] usb gadget, serial: Add a serial number field to the usb descriptor.
Date: Fri, 25 Jun 2010 15:45:14 -0700
Message-Id: <1277505914-22719-1-git-send-email-rob@emanuele.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way it can support the iSerialNumber parameter.

Signed-off-by: Rob Emanuele <rob@emanuele.us>
---
 drivers/usb/gadget/serial.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index f46a609..7f64524 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -63,13 +63,16 @@
 
 #define STRING_MANUFACTURER_IDX		0
 #define STRING_PRODUCT_IDX		1
-#define STRING_DESCRIPTION_IDX		2
+#define STRING_SERIAL_IDX		2
+#define STRING_DESCRIPTION_IDX		3
 
 static char manufacturer[50];
+static char serialnum[25];
 
 static struct usb_string strings_dev[] = {
 	[STRING_MANUFACTURER_IDX].s = manufacturer,
 	[STRING_PRODUCT_IDX].s = GS_VERSION_NAME,
+	[STRING_SERIAL_IDX].s = serialnum,
 	[STRING_DESCRIPTION_IDX].s = NULL /* updated; f(use_acm) */,
 	{  } /* end of list */
 };
@@ -175,7 +178,7 @@ static int __init gs_bind(struct usb_composite_dev *cdev)
 	 * contents can be overridden by the composite_dev glue.
 	 */
 
-	/* device description: manufacturer, product */
+	/* device description: manufacturer, product, serialnum */
 	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
 		init_utsname()->sysname, init_utsname()->release,
 		gadget->name);
@@ -193,6 +196,14 @@ static int __init gs_bind(struct usb_composite_dev *cdev)
 
 	device_desc.iProduct = status;
 
+	snprintf(serialnum, sizeof serialnum, "non-unique");
+	status = usb_string_id(cdev);
+	if (status < 0)
+		goto fail;
+	strings_dev[STRING_SERIAL_IDX].id = status;
+
+	device_desc.iSerialNumber = status;
+
 	/* config description */
 	status = usb_string_id(cdev);
 	if (status < 0)
-- 
1.7.0.4

