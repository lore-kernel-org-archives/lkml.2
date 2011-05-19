Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1ESMSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:18:55 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:35216 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab1ESMSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:18:52 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] hid-multitouch: add support for Touch International panels
Date: Thu, 19 May 2011 14:18:16 +0200
Message-Id: <1305807498-8785-5-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce support for Touch International panels.
This device has not been optimized in term of kernel processing
operations (default class), but it will work.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 10b8f90..7a53d8e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -320,6 +320,7 @@ config HID_MULTITOUCH
           - eGalax dual-touch panels, including the
 	    Joojoo and Wetab tablets
 	  - Stantum multitouch panels
+	  - Touch International Panels
 
 	  If unsure, say N.
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 02c6c93..4539aa1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1479,6 +1479,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65a) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED2, USB_DEVICE_ID_TOPSEED2_RF_COMBO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL, USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7db188f..0f6aa2f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -587,6 +587,9 @@
 #define USB_VENDOR_ID_TOPMAX		0x0663
 #define USB_DEVICE_ID_TOPMAX_COBRAPAD	0x0103
 
+#define USB_VENDOR_ID_TOUCH_INTL	0x1e5e
+#define USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH	0x0313
+
 #define USB_VENDOR_ID_TOUCHPACK		0x1bfd
 #define USB_DEVICE_ID_TOUCHPACK_RTS	0x1688
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 76ef60d..bc57615 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -683,6 +683,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
+	/* Touch International panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
+			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mt_devices);
-- 
1.7.4.4

