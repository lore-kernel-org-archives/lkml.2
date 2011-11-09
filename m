Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936049Ab1KJDtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:49:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966081Ab1KJDtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.847764464@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?G=C3=B6k=C3=A7en=20Eraslan?= <gokcen@pardus.org.tr>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [261/264] HID: Add device IDs for Macbook Pro 8 keyboards
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gökçen Eraslan <gokcen@pardus.org.tr>

commit 213f9da80533940560bef8fa43b10c590895459c upstream.

This patch adds keyboard support for Macbook Pro 8 models which has
WELLSPRING5A model name and 0x0252, 0x0253 and 0x0254 USB IDs. Trackpad
support for those models are added to bcm5974 in
c331eb580a0a7906c0cdb8dbae3cfe99e3c0e555 ("Input: bcm5974 - Add
support for newer MacBookPro8,2).

Signed-off-by: Gökçen Eraslan <gokcen@pardus.org.tr>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-apple.c |    6 ++++++
 drivers/hid/hid-core.c  |    6 ++++++
 drivers/hid/hid-ids.h   |    3 +++
 3 files changed, 15 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -533,6 +533,12 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6A_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1340,6 +1340,9 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING6_JIS) },
@@ -1899,6 +1902,9 @@ static const struct hid_device_id hid_mo
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -118,6 +118,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_REVB_ANSI	0x024f
 #define USB_DEVICE_ID_APPLE_ALU_REVB_ISO	0x0250
 #define USB_DEVICE_ID_APPLE_ALU_REVB_JIS	0x0251
+#define USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI	0x0252
+#define USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO	0x0253
+#define USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS	0x0254
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b


