Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1ERN1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:27:38 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:40864 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab1ERN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:27:36 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid-multitouch: Add support for Lumio panels
Date: Wed, 18 May 2011 15:27:24 +0200
Message-Id: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for Lumio optical devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d9635d6..5a54b13 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -308,6 +308,7 @@ config HID_MULTITOUCH
 	  - Hanvon dual touch panels
 	  - Ilitek dual touch panel
 	  - IrTouch Infrared USB panels
+	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
 	  - Pixcir dual touch panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 77f27ed..8a3ae13 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1411,6 +1411,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LUMIO, USB_DEVICE_ID_CRYSTALTOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2e46eb2..a8c46b0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -411,6 +411,9 @@
 #define USB_DEVICE_ID_DINOVO_MINI	0xc71f
 #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2	0xca03
 
+#define USB_VENDOR_ID_LUMIO		0x202e
+#define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b21251b..ef33e2d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -599,6 +599,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
+	/* Lumio panels */
+	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
+		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
+			USB_DEVICE_ID_CRYSTALTOUCH) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		HID_USB_DEVICE(USB_VENDOR_ID_ASUS,
-- 
1.7.4.4

