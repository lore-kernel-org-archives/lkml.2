Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1FUNCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:02:10 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:48736 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab1FUNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:02:05 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] hid-multitouch: add support for a new Lumio dual-touch panel
Date: Tue, 21 Jun 2011 15:01:55 +0200
Message-Id: <1308661315-6240-4-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f7440e8..6f3289a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1423,6 +1423,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LUMIO, USB_DEVICE_ID_CRYSTALTOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LUMIO, USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index aecb5a4..a756ee6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -449,6 +449,7 @@
 
 #define USB_VENDOR_ID_LUMIO		0x202e
 #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
+#define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
 
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 467b518..62cac4d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -676,6 +676,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
 			USB_DEVICE_ID_CRYSTALTOUCH) },
+	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
+		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
+			USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
 
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-- 
1.7.4.4

