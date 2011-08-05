Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1HETHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:07:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56836 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1HETHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:07:47 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Joshua V. Dillon" <jvdillon@gmail.com>
Subject: [PATCH] Added product codes and device constants for MacBookAir4,2 trackpad.
Date: Fri,  5 Aug 2011 12:07:41 -0700
Message-Id: <1312571261-32465-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joshua V. Dillon <jvdillon@gmail.com>

Added USB device IDs for MacBookAir4,2 trackpad. Device constants were
copied from the MacBookAir3,2 constants. The 4,2 device specification is
reportedly unchanged from the 3,2 predecessor and seems to work well.

Signed-off-by: Joshua V Dillon <jvdillon@gmail.com>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
I received this patch from Joshua. He preferred that I send it on his
behalf. I have compile tested the patch, and Joshua has runtime tested
it using a dkms package against 2.6.38.

 drivers/input/mouse/bcm5974.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 3126983..48d9ec1 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -67,6 +67,10 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI	0x0245
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_ISO	0x0246
 #define USB_DEVICE_ID_APPLE_WELLSPRING5_JIS	0x0247
+/* MacbookAir4,2 (unibody, July 2011) */
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI	0x024c
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_ISO	0x024d
+#define USB_DEVICE_ID_APPLE_WELLSPRING6_JIS	0x024e
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -104,6 +108,10 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5_JIS),
+	/* MacbookAir4,2 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING6_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING6_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -294,6 +302,18 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ DIM_X, DIM_X / SN_COORD, -4415, 5050 },
 		{ DIM_Y, DIM_Y / SN_COORD, -55, 6680 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING6_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING6_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
+		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+	},
 	{}
 };
 
-- 
1.7.4.1

