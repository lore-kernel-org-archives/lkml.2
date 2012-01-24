Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2AXCq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:46:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab2AXCqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.773042548@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Masatoshi Hoshikawa <hoshikawa@xiroku.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [088/129] HID: hid-multitouch: add support 9 new Xiroku devices
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 3912
Lines: 104

From: Masatoshi Hoshikawa <hoshikawa@xiroku.com>

commit 11576c6114c3b6505aea2e0c988bedb856a0e20c upstream.

This patch adds support for the Xiroku Inc. panels (SPX/MPX/CSR/etc.).

Signed-off-by: Masatoshi Hoshikawa <hoshikawa@xiroku.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    9 +++++++++
 drivers/hid/hid-ids.h        |   11 +++++++++++
 drivers/hid/hid-multitouch.c |   29 +++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -356,6 +356,7 @@ config HID_MULTITOUCH
 	  - Touch International Panels
 	  - Unitec Panels
 	  - XAT optical touch panels
+	  - Xiroku optical touch panels
 
 	  If unsure, say N.
 
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1552,6 +1552,15 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_SPX2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_MPX2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_XIROKU, USB_DEVICE_ID_XIROKU_CSR2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_X_TENSIONS, USB_DEVICE_ID_SPEEDLINK_VAD_CEZANNE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -717,6 +717,17 @@
 #define USB_VENDOR_ID_XAT	0x2505
 #define USB_DEVICE_ID_XAT_CSR	0x0220
 
+#define USB_VENDOR_ID_XIROKU		0x1477
+#define USB_DEVICE_ID_XIROKU_SPX	0x1006
+#define USB_DEVICE_ID_XIROKU_MPX	0x1007
+#define USB_DEVICE_ID_XIROKU_CSR	0x100e
+#define USB_DEVICE_ID_XIROKU_SPX1	0x1021
+#define USB_DEVICE_ID_XIROKU_CSR1	0x1022
+#define USB_DEVICE_ID_XIROKU_MPX1	0x1023
+#define USB_DEVICE_ID_XIROKU_SPX2	0x1024
+#define USB_DEVICE_ID_XIROKU_CSR2	0x1025
+#define USB_DEVICE_ID_XIROKU_MPX2	0x1026
+
 #define USB_VENDOR_ID_YEALINK		0x6993
 #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K	0xb001
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -780,6 +780,35 @@ static const struct hid_device_id mt_dev
 		HID_USB_DEVICE(USB_VENDOR_ID_XAT,
 			USB_DEVICE_ID_XAT_CSR) },
 
+	/* Xiroku */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_SPX) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_MPX) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_CSR) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_SPX1) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_MPX1) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_CSR1) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_SPX2) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_MPX2) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_XIROKU,
+			USB_DEVICE_ID_XIROKU_CSR2) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);


