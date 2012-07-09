Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2GIMqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:46:55 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:46824 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2GIMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:46:53 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5OAAPS+k9V5qg+PGdsb2JhbABFiiGtShkBAQEBHhkNJ4IgAVwTAQ8YGFIYChoTh34DELEJDYlOFIpGZoYMA5sbhR+HYg
X-IronPort-AV: E=Sophos;i="4.77,553,1336341600"; 
   d="scan'208";a="371149500"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Bourgeois <bluedragonx@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] HID: Add support for 2012 MacBook Pro Retina
Date: Mon,  9 Jul 2012 14:46:45 +0200
Message-Id: <1341838006-22407-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Bourgeois <bluedragonx@gmail.com>

Add support for the 15'' MacBook Pro Retina. The keyboard is
the same as recent models.

The patch needs to be synchronized with the bcm5974 patch for
the trackpad - as usual.

Patch originally written by clipcarl (forums.opensuse.org).

[rydberg@euromail.se: Amended mouse ignore lines]
Signed-off-by: Ryan Bourgeois <bluedragonx@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri, Ryan

Here is the retina patch, cleaned up and with the mouse ignore stuff
amended. The accompanying bcm5974 patch follows this one.

Simple enough for 3.5, me thinks, but 3.6 should be alright as well.

Cheers,
Henrik

 drivers/hid/hid-apple.c | 6 ++++++
 drivers/hid/hid-core.c  | 6 ++++++
 drivers/hid/hid-ids.h   | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index fa10f84..585344b 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -517,6 +517,12 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 6ac0286..6089df5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1503,6 +1503,9 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_JIS) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
@@ -2089,6 +2092,9 @@ static const struct hid_device_id hid_mouse_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d1cdd2d..eaf5449 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -125,6 +125,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI	0x024c
 #define USB_DEVICE_ID_APPLE_WELLSPRING6_ISO	0x024d
 #define USB_DEVICE_ID_APPLE_WELLSPRING6_JIS	0x024e
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI	0x0262
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_ISO	0x0263
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_JIS	0x0264
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
-- 
1.7.11.1

