Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286Ab1ETFNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:13:40 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:33237
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935212Ab1ETFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:13:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 09/12] staging: usbip: stub_dev.c: move stub_driver definition and update driver name
Date: Thu, 19 May 2011 21:37:03 -0700
Message-Id: <91b3e9e7b24eb432f40edc93ef175f3c41114bf7.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the stub_driver definition to the end of file and, therefore,
remove foward declarations. Update driver name to usbip-host.

A few comments were slightly edited too.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_dev.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index e35d62c..e26b2ee 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -23,14 +23,10 @@
 #include "usbip_common.h"
 #include "stub.h"
 
-static int stub_probe(struct usb_interface *interface,
-		      const struct usb_device_id *id);
-static void stub_disconnect(struct usb_interface *interface);
-
 /*
  * Define device IDs here if you want to explicitly limit exportable devices.
- * In the most cases, wild card matching will be ok because driver binding can
- * be changed dynamically by a userland program.
+ * In most cases, wildcard matching will be okay because driver binding can be
+ * changed dynamically by a userland program.
  */
 static struct usb_device_id stub_table[] = {
 #if 0
@@ -54,16 +50,9 @@ static struct usb_device_id stub_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, stub_table);
 
-struct usb_driver stub_driver = {
-	.name		= "usbip",
-	.probe		= stub_probe,
-	.disconnect	= stub_disconnect,
-	.id_table	= stub_table,
-};
-
 /*
- * usbip_status shows status of usbip as long as this driver is bound to the
- * target device.
+ * usbip_status shows the status of usbip-host as long as this driver is bound
+ * to the target device.
  */
 static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 			   char *buf)
@@ -423,7 +412,7 @@ static int stub_probe(struct usb_interface *interface,
 		return 0;
 	}
 
-	/* ok. this is my device. */
+	/* ok, this is my device */
 	sdev = stub_device_alloc(udev, interface);
 	if (!sdev)
 		return -ENOMEM;
@@ -534,3 +523,10 @@ static void stub_disconnect(struct usb_interface *interface)
 		del_match_busid((char *)udev_busid);
 	}
 }
+
+struct usb_driver stub_driver = {
+	.name		= "usbip-host",
+	.probe		= stub_probe,
+	.disconnect	= stub_disconnect,
+	.id_table	= stub_table,
+};
-- 
1.7.5.1

