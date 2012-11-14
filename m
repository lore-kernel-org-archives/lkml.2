Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2KNQyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:54:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2KNQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:54:06 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris MacDonald <chris@fourthandvine.com>
Subject: [PATCH] HID: usbhid: add quirk HID_QUIRK_NOGET to TPV optical touchscreen
Date: Wed, 14 Nov 2012 17:53:56 +0100
Message-Id: <1352912036-6670-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the device is blocked in dmesg at:
hid-multitouch 0003:25AA:8883.000X: usb_submit_urb(ctrl) failed: -1
hid-multitouch 0003:25AA:8883.000X: timeout initializing reports

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---

Hi guys,

Even if Chris did not answered, I had the confirmation that this device works
with the quirk in place.

Cheers,
Benjamin

 drivers/hid/hid-ids.h           | 3 +++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 30bc2db..56d5528 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -765,6 +765,9 @@
 #define USB_VENDOR_ID_TOUCHPACK		0x1bfd
 #define USB_DEVICE_ID_TOUCHPACK_RTS	0x1688
 
+#define USB_VENDOR_ID_TPV		0x25aa
+#define USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN	0x8883
+
 #define USB_VENDOR_ID_TURBOX		0x062a
 #define USB_DEVICE_ID_TURBOX_KEYBOARD	0x0201
 #define USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART	0x7100
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 11c7932..38a7cdd 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -82,6 +82,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_2, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_TPV, USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_KEYBOARD, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U, HID_QUIRK_MULTI_INPUT },
-- 
1.8.0

