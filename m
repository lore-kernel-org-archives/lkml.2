Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab2ECWY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:24:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35213 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab2ECWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:22:33 -0400
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 1/6] drivers/media: add missing __devexit_p() annotations
Date: Thu,  3 May 2012 16:22:22 -0600
Message-Id: <1336083747-3142-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Drivers that refer to a __devexit function in an operations
structure need to annotate that pointer with __devexit_p so
replace it with a NULL pointer when the section gets discarded.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    2 +-
 drivers/media/radio/radio-timb.c           |    2 +-
 drivers/media/radio/saa7706h.c             |    2 +-
 drivers/media/radio/tef6862.c              |    2 +-
 drivers/media/rc/imon.c                    |    2 +-
 drivers/media/rc/mceusb.c                  |    2 +-
 drivers/media/rc/redrat3.c                 |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index d88c4aa..ef4c0f8 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -1696,7 +1696,7 @@ static struct pci_driver ddb_pci_driver = {
 	.name        = "DDBridge",
 	.id_table    = ddb_id_tbl,
 	.probe       = ddb_probe,
-	.remove      = ddb_remove,
+	.remove      = __devexit_p(ddb_remove),
 };
 
 static __init int module_init_ddbridge(void)
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 5d9a90a..7052adc 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -223,7 +223,7 @@ static struct platform_driver timbradio_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= timbradio_probe,
-	.remove		= timbradio_remove,
+	.remove		= __devexit_p(timbradio_remove),
 };
 
 module_platform_driver(timbradio_platform_driver);
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 9474706..bb953ef 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -430,7 +430,7 @@ static struct i2c_driver saa7706h_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= saa7706h_probe,
-	.remove		= saa7706h_remove,
+	.remove		= __devexit_p(saa7706h_remove),
 	.id_table	= saa7706h_id,
 };
 
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 6418c4c..06d47e5 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -211,7 +211,7 @@ static struct i2c_driver tef6862_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= tef6862_probe,
-	.remove		= tef6862_remove,
+	.remove		= __devexit_p(tef6862_remove),
 	.id_table	= tef6862_id,
 };
 
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7f26fdf..5dd0386 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -255,7 +255,7 @@ static struct usb_device_id imon_usb_id_table[] = {
 static struct usb_driver imon_driver = {
 	.name		= MOD_NAME,
 	.probe		= imon_probe,
-	.disconnect	= imon_disconnect,
+	.disconnect	= __devexit_p(imon_disconnect),
 	.suspend	= imon_suspend,
 	.resume		= imon_resume,
 	.id_table	= imon_usb_id_table,
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index e150a2e..845cae3 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1443,7 +1443,7 @@ static int mceusb_dev_resume(struct usb_interface *intf)
 static struct usb_driver mceusb_dev_driver = {
 	.name =		DRIVER_NAME,
 	.probe =	mceusb_dev_probe,
-	.disconnect =	mceusb_dev_disconnect,
+	.disconnect =	__devexit_p(mceusb_dev_disconnect),
 	.suspend =	mceusb_dev_suspend,
 	.resume =	mceusb_dev_resume,
 	.reset_resume =	mceusb_dev_resume,
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index ad95c67..2878b0e 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1277,7 +1277,7 @@ static int redrat3_dev_resume(struct usb_interface *intf)
 static struct usb_driver redrat3_dev_driver = {
 	.name		= DRIVER_NAME,
 	.probe		= redrat3_dev_probe,
-	.disconnect	= redrat3_dev_disconnect,
+	.disconnect	= __devexit_p(redrat3_dev_disconnect),
 	.suspend	= redrat3_dev_suspend,
 	.resume		= redrat3_dev_resume,
 	.reset_resume	= redrat3_dev_resume,
-- 
1.7.5.4

