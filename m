Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1ESMSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:18:42 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:57160 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab1ESMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:18:40 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] hid-multitouch: add support for ActionStar panels
Date: Thu, 19 May 2011 14:18:13 +0200
Message-Id: <1305807498-8785-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce support for ActionStar panels.
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
index d83c23b..e240f8f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -303,6 +303,7 @@ config HID_MULTITOUCH
 
 	  Say Y here if you have one of the following devices:
 	  - 3M PCT touch screens
+	  - ActionStar dual touch panels
 	  - Cando dual touch panel
 	  - Cypress TrueTouch panels
 	  - Elo TouchSystems IntelliTouch Plus panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 72f5a4f..1e7889b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1290,6 +1290,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR, USB_DEVICE_ID_ACTIONSTAR_1011) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index dd0805a..8ab0fc0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -37,6 +37,9 @@
 
 #define USB_VENDOR_ID_ACRUX		0x1a34
 
+#define USB_VENDOR_ID_ACTIONSTAR	0x2101
+#define USB_DEVICE_ID_ACTIONSTAR_1011	0x1011
+
 #define USB_VENDOR_ID_ADS_TECH 		0x06e1
 #define USB_DEVICE_ID_ADS_TECH_RADIO_SI470X	0xa155
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3bc8de6..10a8c76 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -570,6 +570,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M2256) },
 
+	/* ActionStar panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
+			USB_DEVICE_ID_ACTIONSTAR_1011) },
+
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
-- 
1.7.4.4

