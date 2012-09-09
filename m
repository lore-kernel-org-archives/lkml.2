Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2IIXdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51169 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755821Ab2IIXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:08 -0400
Message-Id: <20120909224202.762483929@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lionel Vaux <lionel.vaux@free.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 89/95] HID: add support for Cypress barcode scanner 04B4:ED81
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lionel Vaux <lionel.vaux@free.fr>

commit 76c9d8fe2c7fc34ffc387d8022c5828d6ff9df48 upstream.

Add yet another device to the list of Cypress barcode scanners
needing the CP_RDESC_SWAPPED_MIN_MAX quirk.

Signed-off-by: Lionel Vaux (iouri) <lionel.vaux@free.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-cypress.c |    2 ++
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1405,6 +1405,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -129,6 +129,8 @@ static const struct hid_device_id cp_dev
 		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3),
 		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_4),
+		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE),
 		.driver_data = CP_2WHEEL_MOUSE_HACK },
 	{ }
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -226,6 +226,7 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
 #define USB_DEVICE_ID_CYPRESS_BARCODE_3	0xbca1
+#define USB_DEVICE_ID_CYPRESS_BARCODE_4	0xed81
 #define USB_DEVICE_ID_CYPRESS_TRUETOUCH	0xc001
 
 #define USB_VENDOR_ID_DEALEXTREAME	0x10c5


