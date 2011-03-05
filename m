Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1CEBFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:05:13 -0500
Received: from kroah.org ([198.145.64.141]:47720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab1CEBFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:52 2011
Message-Id: <20110305010352.883022372@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, maximilian attems <max@stro.at>
Subject: [11/18] HID: add support for Acan FG-8100 barcode reader
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit e8d0eab4d9eda9f5e97852f780f020bfb134f9f0 upstream.

Acan FG-8100 barcode reader (0x04b4/0xbca1) has vendor ID of
cypress and requires the same MIN/MAX swap descriptor quirk
as other barcode readers from cypress.

Reported-by: Stijn Ghesquiere <stijn@applesnail.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-cypress.c |    2 ++
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1297,6 +1297,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -126,6 +126,8 @@ static const struct hid_device_id cp_dev
 		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2),
 		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3),
+		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE),
 		.driver_data = CP_2WHEEL_MOUSE_HACK },
 	{ }
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -148,6 +148,7 @@
 #define USB_DEVICE_ID_CYPRESS_ULTRAMOUSE	0x7417
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
+#define USB_DEVICE_ID_CYPRESS_BARCODE_3	0xbca1
 
 #define USB_VENDOR_ID_DEALEXTREAME	0x10c5
 #define USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701	0x819a


