Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab1ESMSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:18:47 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:57167 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab1ESMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:18:44 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] hid-multitouch: add support for CVTouch panels
Date: Thu, 19 May 2011 14:18:14 +0200
Message-Id: <1305807498-8785-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce support for CVTouch panels.
This device has not been optimized in term of kernel processing
operations (default class), but it will work.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e240f8f..69a2cc9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -305,6 +305,7 @@ config HID_MULTITOUCH
 	  - 3M PCT touch screens
 	  - ActionStar dual touch panels
 	  - Cando dual touch panel
+	  - CVTouch panels
 	  - Cypress TrueTouch panels
 	  - Elo TouchSystems IntelliTouch Plus panels
 	  - Hanvon dual touch panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1e7889b..dbe949a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1357,6 +1357,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH, USB_DEVICE_ID_CVTOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8ab0fc0..f617acb 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -185,6 +185,9 @@
 #define USB_VENDOR_ID_CREATIVELABS	0x041e
 #define USB_DEVICE_ID_PRODIKEYS_PCMIDI	0x2801
 
+#define USB_VENDOR_ID_CVTOUCH		0x1ff7
+#define USB_DEVICE_ID_CVTOUCH_SCREEN	0x0013
+
 #define USB_VENDOR_ID_CYGNAL		0x10c4
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 10a8c76..af8789a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -589,6 +589,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 
+	/* CVTouch panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
+			USB_DEVICE_ID_CVTOUCH_SCREEN) },
+
 	/* Cypress panel */
 	{ .driver_data = MT_CLS_CYPRESS,
 		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
-- 
1.7.4.4

