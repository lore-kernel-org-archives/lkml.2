Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966070Ab1KJDs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966050Ab1KJDsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.446993792@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joshua V Dillon <jvdillon@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [257/264] HID: add support for MacBookAir4,2 keyboard.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Joshua V. Dillon" <jvdillon@gmail.com>

commit 5d922baa631058c7e37ae33e81c4d3e6437f8d1d upstream.

Added USB device IDs for MacBookAir4,2 keyboard. Device constants were
copied from the MacBookAir3,2 constants. The 4,2 device specification is
reportedly unchanged from the 3,2 predecessor and seems to work well.

Signed-off-by: Joshua V Dillon <jvdillon@gmail.com>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-apple.c |    9 +++++++++
 drivers/hid/hid-ids.h   |    3 +++
 2 files changed, 12 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -183,6 +183,9 @@ static int hidinput_apple_event(struct h
 		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
+		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
+				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
+			table = macbookair_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
 			table = powerbook_fn_keys;
 		else
@@ -493,6 +496,12 @@ static const struct hid_device_id apple_
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
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -109,6 +109,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI	0x0245
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ISO	0x0246
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_JIS	0x0247
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI	0x024c
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ISO	0x024d
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_JIS	0x024e
 #define USB_DEVICE_ID_APPLE_ALU_REVB_ANSI	0x024f
 #define USB_DEVICE_ID_APPLE_ALU_REVB_ISO	0x0250
 #define USB_DEVICE_ID_APPLE_ALU_REVB_JIS	0x0251


