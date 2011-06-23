Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab1FWRaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:30:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:65394 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab1FWRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:30:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 043/247] input: bcm5974: Add support for MacBookAir3
Date: Thu, 23 Jun 2011 13:25:42 -0400
Message-Id: <1308850146-15061-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgar (gimli) Hucek <gimli@dark-green.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6021afcf19d8c6f5db6d11cadcfb6a22d0c28a48 upstream.

This patch adds support for the MacBookAir3,1 and MacBookAir3,2
models.

[rydberg@euromail.se: touchpad range calibration]
Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/mouse/bcm5974.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index b89879b..6d9eea2 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -55,6 +55,14 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
 #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
+/* MacbookAir3,2 (unibody), aka wellspring5 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI	0x023f
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_ISO	0x0240
+#define USB_DEVICE_ID_APPLE_WELLSPRING4_JIS	0x0241
+/* MacbookAir3,1 (unibody), aka wellspring4 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI	0x0242
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO	0x0243
+#define USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS	0x0244
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -80,6 +88,14 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
+	/* MacbookAir3,2 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_JIS),
+	/* MacbookAir3,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -234,6 +250,30 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
 		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING4_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING4_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
+		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4616, 5112 },
+		{ DIM_Y, DIM_Y / SN_COORD, -142, 5234 }
+	},
 	{}
 };
 
-- 
1.7.4.4

