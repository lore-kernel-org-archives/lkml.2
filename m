Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2KDIi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:38:58 -0500
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:55809 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab2KDIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:38:54 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 1B6938576
Subject: [PATCH 1/4] HID: roccat: Added support for KoneXTD
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Nov 2012 09:38:52 +0100
Message-ID: <1352018332.2673.131.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KoneXTD is just a Kone[+] with updated sensor, so it's handled by
koneplus driver.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-ids.h             |    1 +
 drivers/hid/hid-roccat-koneplus.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index aea84f3..32c03d1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -677,6 +677,7 @@
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
+#define USB_DEVICE_ID_ROCCAT_KONEXTD	0x2e22
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index c47540a..0df4083 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -14,6 +14,7 @@
 /*
  * Roccat Kone[+] is an updated/improved version of the Kone with more memory
  * and functionality and without the non-standard behaviours the Kone had.
+ * KoneXTD has same capabilities but updated sensor.
  */
 
 #include <linux/device.h>
@@ -718,6 +719,7 @@ static int koneplus_raw_event(struct hid_device *hdev,
 
 static const struct hid_device_id koneplus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEXTD) },
 	{ }
 };
 
@@ -758,5 +760,5 @@ module_init(koneplus_init);
 module_exit(koneplus_exit);
 
 MODULE_AUTHOR("Stefan Achatz");
-MODULE_DESCRIPTION("USB Roccat Kone[+] driver");
+MODULE_DESCRIPTION("USB Roccat Kone[+]/XTD driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.3.4



