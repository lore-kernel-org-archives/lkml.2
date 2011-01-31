Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1AaK2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:28:40 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33279 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1AaK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:28:38 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] hid-multitouch: introduce IrTouch Infrared USB device
Date: Mon, 31 Jan 2011 11:28:22 +0100
Message-Id: <1296469702-3710-5-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for IrTouch 42 inches.

Tested-by: Victor Zhuk <v.zhuk@acs-ltd.ru>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

No changes here except the commit message.

 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24cca2f..a0b117d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -304,6 +304,7 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - Cypress TrueTouch panels
 	  - Hanvon dual touch panels
+	  - IrTouch Infrared USB panels
 	  - Pixcir dual touch panels
 	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92a0d61..b1dd7ad 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -333,6 +333,9 @@
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
 
+#define USB_VENDOR_ID_IRTOUCHSYSTEMS	0x6615
+#define USB_DEVICE_ID_IRTOUCH_INFRARED_USB	0x0070
+
 #define USB_VENDOR_ID_JESS		0x0c45
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4f63409..69f8744 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -471,6 +471,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
 
+	/* IRTOUCH panels */
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
+		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
+			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
+
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
-- 
1.7.3.4

