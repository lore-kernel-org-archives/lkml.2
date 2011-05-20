Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab1ETN7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:59:48 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:34631 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ETN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:59:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid-multitouch: cosmetic changes, sort classes and devices
Date: Fri, 20 May 2011 15:59:34 +0200
Message-Id: <1305899974-5641-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sorts the defs for the MT_CLS. I choose to split
generic classes and device specific ones to be able to add
more generic classes in the future.

It also put eGalax devices at their right place (alphabetically)
in mt_devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

Hi Jiri,

If you want, you can apply this one too. No semantic changes,
just some sorting and corrections in KConfig.

Cheers,
Benjamin

 drivers/hid/Kconfig          |    9 ++--
 drivers/hid/hid-multitouch.c |   93 ++++++++++++++++++++++-------------------
 2 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6145f2e..67d2a75 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -304,21 +304,20 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - 3M PCT touch screens
 	  - ActionStar dual touch panels
-	  - Cando dual touch panel
+	  - Cando dual touch panels
 	  - CVTouch panels
 	  - Cypress TrueTouch panels
 	  - Elo TouchSystems IntelliTouch Plus panels
+	  - GeneralTouch 'Sensing Win7-TwoFinger' panels
 	  - GoodTouch panels
 	  - Hanvon dual touch panels
-	  - Ilitek dual touch panel
+	  - Ilitek dual touch panels
 	  - IrTouch Infrared USB panels
 	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
 	  - Pixcir dual touch panels
-	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
-          - eGalax dual-touch panels, including the
-	    Joojoo and Wetab tablets
+	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 65b92d2..ecd4d2d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -83,15 +83,18 @@ struct mt_class {
 };
 
 /* classes of device behavior */
-#define MT_CLS_DEFAULT				1
-#define MT_CLS_DUAL_INRANGE_CONTACTID		2
-#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
-#define MT_CLS_CYPRESS				4
-#define MT_CLS_EGALAX				5
-#define MT_CLS_3M				7
-#define MT_CLS_CONFIDENCE			8
-#define MT_CLS_CONFIDENCE_MINUS_ONE		9
-#define MT_CLS_DUAL_NSMU_CONTACTID		10
+#define MT_CLS_DEFAULT				0x0001
+
+#define MT_CLS_CONFIDENCE			0x0002
+#define MT_CLS_CONFIDENCE_MINUS_ONE		0x0003
+#define MT_CLS_DUAL_INRANGE_CONTACTID		0x0004
+#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0005
+#define MT_CLS_DUAL_NSMU_CONTACTID		0x0006
+
+/* vendor specific classes */
+#define MT_CLS_3M				0x0101
+#define MT_CLS_CYPRESS				0x0102
+#define MT_CLS_EGALAX				0x0103
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -130,6 +133,11 @@ static int find_slot_from_contactid(struct mt_device *td)
 struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
+	{ .name = MT_CLS_CONFIDENCE,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
+	{ .name = MT_CLS_CONFIDENCE_MINUS_ONE,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
+			MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE },
 	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
@@ -138,13 +146,24 @@ struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
+	{ .name = MT_CLS_DUAL_NSMU_CONTACTID,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.maxcontacts = 2 },
+
+	/*
+	 * vendor specific classes
+	 */
+	{ .name = MT_CLS_3M,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.sn_move = 2048,
+		.sn_width = 128,
+		.sn_height = 128 },
 	{ .name = MT_CLS_CYPRESS,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_CYPRESS,
 		.maxcontacts = 10 },
-	{ .name = MT_CLS_CONFIDENCE_MINUS_ONE,
-		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
-			MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE },
 	{ .name = MT_CLS_EGALAX,
 		.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
 			MT_QUIRK_VALID_IS_INRANGE |
@@ -153,18 +172,6 @@ struct mt_class mt_classes[] = {
 		.sn_move = 4096,
 		.sn_pressure = 32,
 	},
-	{ .name = MT_CLS_3M,
-		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
-			MT_QUIRK_SLOT_IS_CONTACTID,
-		.sn_move = 2048,
-		.sn_width = 128,
-		.sn_height = 128 },
-	{ .name = MT_CLS_CONFIDENCE,
-		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
-	{ .name = MT_CLS_DUAL_NSMU_CONTACTID,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_SLOT_IS_CONTACTID,
-		.maxcontacts = 2 },
 
 	{ }
 };
@@ -596,6 +603,25 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
+	/* eGalax devices (resistive) */
+	{  .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
+	{  .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
+
+	/* eGalax devices (capacitive) */
+	{  .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
+	{  .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
+	{  .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
+
 	/* Elo TouchSystems IntelliTouch Plus panel */
 	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_ELO,
@@ -650,25 +676,6 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
-	/* Resistive eGalax devices */
-	{  .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
-	{  .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
-
-	/* Capacitive eGalax devices */
-	{  .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
-	{  .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
-	{  .driver_data = MT_CLS_EGALAX,
-		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
-
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
-- 
1.7.4.4

