Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2HMWYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:24:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59678 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2HMWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Lionel Vaux (iouri)" <lionel.vaux@free.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 46/65] HID: add support for Cypress barcode scanner 04B4:ED81
Date: Mon, 13 Aug 2012 15:14:30 -0700
Message-Id: <20120813221419.048987776@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lionel Vaux <lionel.vaux@free.fr>

commit 76c9d8fe2c7fc34ffc387d8022c5828d6ff9df48 upstream.

Add yet another device to the list of Cypress barcode scanners
needing the CP_RDESC_SWAPPED_MIN_MAX quirk.

Signed-off-by: Lionel Vaux (iouri) <lionel.vaux@free.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-cypress.c |    2 ++
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1410,6 +1410,7 @@ static const struct hid_device_id hid_ha
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
@@ -231,6 +231,7 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
 #define USB_DEVICE_ID_CYPRESS_BARCODE_3	0xbca1
+#define USB_DEVICE_ID_CYPRESS_BARCODE_4	0xed81
 #define USB_DEVICE_ID_CYPRESS_TRUETOUCH	0xc001
 
 #define USB_VENDOR_ID_DEALEXTREAME	0x10c5


