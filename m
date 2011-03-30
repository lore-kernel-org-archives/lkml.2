Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab1C3WEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:04:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:21130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab1C3VG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236200"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: gimli@dark-green.com, rydberg@euromail.se, jkosina@suse.cz, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [47/275] input: bcm5974: Add support for MacBookAir3
Message-Id: <20110330210443.2D6443E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Edgar (gimli) Hucek <gimli@dark-green.com>

commit 6021afcf19d8c6f5db6d11cadcfb6a22d0c28a48 upstream.

This patch adds support for the MacBookAir3,1 and MacBookAir3,2
models.

[rydberg@euromail.se: touchpad range calibration]
Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/input/mouse/bcm5974.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

Index: linux-2.6.35.y/drivers/input/mouse/bcm5974.c
===================================================================
--- linux-2.6.35.y.orig/drivers/input/mouse/bcm5974.c	2011-03-29 22:51:50.618427970 -0700
+++ linux-2.6.35.y/drivers/input/mouse/bcm5974.c	2011-03-29 23:02:59.158321707 -0700
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
@@ -80,6 +88,14 @@
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
@@ -234,6 +250,30 @@
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
 
