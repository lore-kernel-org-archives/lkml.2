Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1HETF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:05:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab1HETF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:05:27 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Joshua V. Dillon" <jvdillon@gmail.com>
Subject: [PATCH] Added product codes and device constants for MacBookAir4,2 keyboard.
Date: Fri,  5 Aug 2011 12:05:22 -0700
Message-Id: <1312571122-30547-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joshua V. Dillon <jvdillon@gmail.com>

Added USB device IDs for MacBookAir4,2 keyboard. Device constants were
copied from the MacBookAir3,2 constants. The 4,2 device specification is
reportedly unchanged from the 3,2 predecessor and seems to work well.

Signed-off-by: Joshua V Dillon <jvdillon@gmail.com>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
I received this patch from Joshua. He preferred that I send it on his
behalf. I have compile tested the patch, and Joshua has runtime tested
it using a dkms package against 2.6.38.

 drivers/hid/hid-apple.c |    9 +++++++++
 drivers/hid/hid-ids.h   |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index b85744f..8bfd87b 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -183,6 +183,9 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
+		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
+				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
+			table = macbookair_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
 			table = powerbook_fn_keys;
 		else
@@ -487,6 +490,12 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ea2c338..a0d59d4 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -109,6 +109,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI	0x0245
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ISO	0x0246
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_JIS	0x0247
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI	0x024c
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ISO	0x024d
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_JIS	0x024e
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
-- 
1.7.4.1

