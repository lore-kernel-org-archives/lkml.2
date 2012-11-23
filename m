Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2KWPhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:37:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63392 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2KWPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:37:53 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] HID: hid-multitouch: rename MT_CLS_DEFAULT into MT_CLS_NSMU
Date: Fri, 23 Nov 2012 16:31:30 +0100
Message-Id: <1353684694-5723-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to add support for Nexio 1870:0100, I found that the
trick required to make it work is much more reliable than the previous
default class.
Rename the current default class for backward compatibility.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 48 +++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f10105f..50fb79f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -115,6 +115,7 @@ struct mt_device {
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
+#define MT_CLS_NSMU				0x000a
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -147,7 +148,8 @@ static int cypress_compute_slot(struct mt_device *td)
 }
 
 static struct mt_class mt_classes[] = {
-	{ .name = MT_CLS_DEFAULT,
+	{ .name = MT_CLS_DEFAULT},
+	{ .name = MT_CLS_NSMU,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
 	{ .name = MT_CLS_SERIAL,
 		.quirks = MT_QUIRK_ALWAYS_VALID},
@@ -927,7 +929,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
@@ -940,7 +942,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
 
 	/* Baanto multitouch devices */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_BAANTO,
 			USB_DEVICE_ID_BAANTO_MT_190W2) },
 	/* Cando panels */
@@ -958,12 +960,12 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 
 	/* Chunghwa Telecom touch panels */
-	{  .driver_data = MT_CLS_DEFAULT,
+	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
 			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 
 	/* CVTouch panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
 			USB_DEVICE_ID_CVTOUCH_SCREEN) },
 
@@ -1052,12 +1054,12 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
 
 	/* Gametel game controller */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_BT_DEVICE(USB_VENDOR_ID_FRUCTEL,
 			USB_DEVICE_ID_GAMETEL_MT_MODE) },
 
 	/* GoodTouch panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
 			USB_DEVICE_ID_GOODTOUCH_000f) },
 
@@ -1075,7 +1077,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_IDEACOM_IDC6651) },
 
 	/* Ilitek dual touch panel */
-	{  .driver_data = MT_CLS_DEFAULT,
+	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
 			USB_DEVICE_ID_ILITEK_MULTITOUCH) },
 
@@ -1085,7 +1087,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
 	/* LG Display panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_LG,
 			USB_DEVICE_ID_LG_MULTITOUCH) },
 
@@ -1117,7 +1119,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_PANABOARD_UBT880) },
 
 	/* Novatek Panel */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
 			USB_DEVICE_ID_NOVATEK_PCT) },
 
@@ -1173,48 +1175,48 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_TOPSEED2_PERIPAD_701) },
 
 	/* Touch International panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
 			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 
 	/* Unitec panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 	/* XAT */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XAT,
 			USB_DEVICE_ID_XAT_CSR) },
 
 	/* Xiroku */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX2) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX2) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
-- 
1.8.0

