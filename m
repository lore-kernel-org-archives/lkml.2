Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1ESMTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:19:04 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:35226 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab1ESMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:19:00 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] hid-multitouch: class MT_CLS_STANTUM is redundant with MT_CLS_CONFIDENCE
Date: Thu, 19 May 2011 14:18:18 +0200
Message-Id: <1305807498-8785-7-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stantum devices used to work with MT_CLS_STANTUM but MT_CLS_CONFIDENCE
is exactly the same. This patch switches them to this generic class,
and remove the unused MT_CLS_STANTUM.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index feeb0b7..65b92d2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -88,7 +88,6 @@ struct mt_class {
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
 #define MT_CLS_CYPRESS				4
 #define MT_CLS_EGALAX				5
-#define MT_CLS_STANTUM				6
 #define MT_CLS_3M				7
 #define MT_CLS_CONFIDENCE			8
 #define MT_CLS_CONFIDENCE_MINUS_ONE		9
@@ -154,8 +153,6 @@ struct mt_class mt_classes[] = {
 		.sn_move = 4096,
 		.sn_pressure = 32,
 	},
-	{ .name = MT_CLS_STANTUM,
-		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
 	{ .name = MT_CLS_3M,
 		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
@@ -673,13 +670,13 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
 
 	/* Stantum panels */
-	{ .driver_data = MT_CLS_STANTUM,
+	{ .driver_data = MT_CLS_CONFIDENCE,
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP)},
-	{ .driver_data = MT_CLS_STANTUM,
+	{ .driver_data = MT_CLS_CONFIDENCE,
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP_STM)},
-	{ .driver_data = MT_CLS_STANTUM,
+	{ .driver_data = MT_CLS_CONFIDENCE,
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
-- 
1.7.4.4

