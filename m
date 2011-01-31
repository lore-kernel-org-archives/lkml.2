Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1AaK3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:29:01 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33271 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaK2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:28:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] hid-multitouch: Rename MT_CLS_DUAL1 and MT_CLS_DUAL2
Date: Mon, 31 Jan 2011 11:28:20 +0100
Message-Id: <1296469702-3710-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames MT_CLS_DUAL1 to MT_CLS_DUAL_INRANGE_CONTACTID
and MT_CLS_DUAL2 to MT_CLS_DUAL_INRANGE_CONTACTNUMBER for better
readability.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 86863a3..b976d10 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -65,10 +65,10 @@ struct mt_class {
 };
 
 /* classes of device behavior */
-#define MT_CLS_DEFAULT	1
-#define MT_CLS_DUAL1	2
-#define MT_CLS_DUAL2	3
-#define MT_CLS_CYPRESS	4
+#define MT_CLS_DEFAULT				1
+#define MT_CLS_DUAL_INRANGE_CONTACTID		2
+#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
+#define MT_CLS_CYPRESS				4
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -106,11 +106,11 @@ struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
 		.maxcontacts = 10 },
-	{ .name = MT_CLS_DUAL1,
+	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts = 2 },
-	{ .name = MT_CLS_DUAL2,
+	{ .name = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
@@ -466,15 +466,15 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
 	/* GeneralTouch panel */
-	{ .driver_data = MT_CLS_DUAL2,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
 
 	/* PixCir-based panels */
-	{ .driver_data = MT_CLS_DUAL1,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
 			USB_DEVICE_ID_HANVON_MULTITOUCH) },
-	{ .driver_data = MT_CLS_DUAL1,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
-- 
1.7.3.4

