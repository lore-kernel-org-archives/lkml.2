Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1BPCGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:06:43 -0500
Received: from kroah.org ([198.145.64.141]:48920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250Ab1BPBuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.728897832@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>
Subject: [044/115] input: bcm5974: Add support for MacBookAir3
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/input/mouse/bcm5974.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

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
@@ -80,6 +88,14 @@ static const struct usb_device_id bcm597
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
@@ -233,6 +249,30 @@ static const struct bcm5974_config bcm59
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
 


