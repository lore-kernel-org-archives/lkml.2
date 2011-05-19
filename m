Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1ESMTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:19:06 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:35228 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab1ESMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:19:01 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] hid-multitouch: add support for Unitec panels
Date: Thu, 19 May 2011 14:18:17 +0200
Message-Id: <1305807498-8785-6-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce support for Unitec panels.
This device has not been optimized in term of kernel processing
operations (default class), but it will work.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    2 ++
 drivers/hid/hid-ids.h        |    4 ++++
 drivers/hid/hid-multitouch.c |    8 ++++++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7a53d8e..6145f2e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -321,6 +321,7 @@ config HID_MULTITOUCH
 	    Joojoo and Wetab tablets
 	  - Stantum multitouch panels
 	  - Touch International Panels
+	  - Unitec Panels
 
 	  If unsure, say N.
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4539aa1..e811b81 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1486,6 +1486,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP8060U) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UNITEC, USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UNITEC, USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_SMARTJOY_PLUS) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_5_8_INCH) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0f6aa2f..e715c43 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -607,6 +607,10 @@
 #define USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U	0x0004
 #define USB_DEVICE_ID_UCLOGIC_TABLET_WP8060U	0x0005
 
+#define USB_VENDOR_ID_UNITEC	0x227d
+#define USB_DEVICE_ID_UNITEC_USB_TOUCH_0709	0x0709
+#define USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19	0x0a19
+
 #define USB_VENDOR_ID_VERNIER		0x08f7
 #define USB_DEVICE_ID_VERNIER_LABPRO	0x0001
 #define USB_DEVICE_ID_VERNIER_GOTEMP	0x0002
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index bc57615..feeb0b7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -688,6 +688,14 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
 			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 
+	/* Unitec panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
+			USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_UNITEC,
+			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
-- 
1.7.4.4

