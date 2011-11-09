Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151Ab1KJDxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:53:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966059Ab1KJDs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.543628761@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, jeffbrown@android.com,
        Jiri Kosina <jkosina@suse.cz>
Subject: [258/264] HID: hid-multitouch: Add LG Display Multitouch device.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Brown <jeffbrown@android.com>

commit c50bb1a4005630f47b5da26336f74a485033a515 upstream.

This panel is also known as the Dell ST2220Tc.

Signed-off-by: jeffbrown@android.com
Reviewed-By: Benjamin Tissoires <Benjamin_Tissoires@logitech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 4 files changed, 10 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -328,6 +328,7 @@ config HID_MULTITOUCH
 	  - Hanvon dual touch panels
 	  - Ilitek dual touch panels
 	  - IrTouch Infrared USB panels
+	  - LG Display panels (Dell ST2220Tc)
 	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1399,6 +1399,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LG, USB_DEVICE_ID_LG_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -426,6 +426,9 @@
 #define USB_DEVICE_ID_LD_HYBRID		0x2090
 #define USB_DEVICE_ID_LD_HEATCONTROL	0x20A0
 
+#define USB_VENDOR_ID_LG		0x1fd2
+#define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
+
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -672,6 +672,11 @@ static const struct hid_device_id mt_dev
 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
+	/* LG Display panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_LG,
+			USB_DEVICE_ID_LG_MULTITOUCH) },
+
 	/* Lumio panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,


