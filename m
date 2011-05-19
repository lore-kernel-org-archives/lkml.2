Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1ESJhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:37:41 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:39587 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab1ESJhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:37:39 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        Bastien Nocera <hadess@hadess.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hid-multitouch: Introduce Elo TouchSystems 2515 IntelliTouch Plus
Date: Thu, 19 May 2011 11:37:29 +0200
Message-Id: <1305797849-5181-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Elo TouchSystems 2515 IntelliTouch Plus
that can be found in Lenovo A700 all-in-one.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Tested-by: Bastien Nocera <hadess@hadess.net>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |   10 ++++++++++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index edc43ed..d83c23b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -305,6 +305,7 @@ config HID_MULTITOUCH
 	  - 3M PCT touch screens
 	  - Cando dual touch panel
 	  - Cypress TrueTouch panels
+	  - Elo TouchSystems IntelliTouch Plus panels
 	  - Hanvon dual touch panels
 	  - Ilitek dual touch panel
 	  - IrTouch Infrared USB panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 715fa0a..72f5a4f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1369,6 +1369,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2515) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 851c71d..dd0805a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -220,6 +220,7 @@
 #define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
 
 #define USB_VENDOR_ID_ELO		0x04E7
+#define USB_DEVICE_ID_ELO_TS2515	0x0022
 #define USB_DEVICE_ID_ELO_TS2700	0x0020
 
 #define USB_VENDOR_ID_EMS		0x2006
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ef33e2d..3bc8de6 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -92,6 +92,7 @@ struct mt_class {
 #define MT_CLS_3M				7
 #define MT_CLS_CONFIDENCE			8
 #define MT_CLS_CONFIDENCE_MINUS_ONE		9
+#define MT_CLS_DUAL_NSMU_CONTACTID		10
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -163,6 +164,10 @@ struct mt_class mt_classes[] = {
 		.sn_height = 128 },
 	{ .name = MT_CLS_CONFIDENCE,
 		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
+	{ .name = MT_CLS_DUAL_NSMU_CONTACTID,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.maxcontacts = 2 },
 
 	{ }
 };
@@ -584,6 +589,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
+	/* Elo TouchSystems IntelliTouch Plus panel */
+	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
+		HID_USB_DEVICE(USB_VENDOR_ID_ELO,
+			USB_DEVICE_ID_ELO_TS2515) },
+
 	/* GeneralTouch panel */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
-- 
1.7.4.4

