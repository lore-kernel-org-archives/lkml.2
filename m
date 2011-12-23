Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1LWOle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:41:34 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:59398 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1LWOlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:41:31 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 1/2] HID: multitouch: add support of Atmel multitouch panels
Date: Fri, 23 Dec 2011 15:40:59 +0100
Message-Id: <1324651260-4067-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5d6eb4e..e95b07c 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -335,6 +335,7 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - 3M PCT touch screens
 	  - ActionStar dual touch panels
+	  - Atmel panels
 	  - Cando dual touch panels
 	  - Chunghwa panels
 	  - CVTouch panels
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 96e139f..8705249 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -145,6 +145,9 @@
 #define USB_DEVICE_ID_ATEN_4PORTKVM	0x2205
 #define USB_DEVICE_ID_ATEN_4PORTKVMC	0x2208
 
+#define USB_VENDOR_ID_ATMEL		0x03eb
+#define USB_DEVICE_ID_ATMEL_MULTITOUCH	0x211c
+
 #define USB_VENDOR_ID_AVERMEDIA		0x07ca
 #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 513329d..d038864 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -667,6 +667,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
+	/* Atmel panels */
+	{ .driver_data = MT_CLS_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
+			USB_DEVICE_ID_ATMEL_MULTITOUCH) },
+
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
-- 
1.7.4.4

