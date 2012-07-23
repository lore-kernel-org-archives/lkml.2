Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2GWCCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:02:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab2GWBmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:47 -0400
Message-Id: <20120723010707.363798756@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 104/108] Input: bcm5974 - Add support for 2012 MacBook Pro Retina
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 3dde22a98e94eb18527f0ff0068fb2fb945e58d4 upstream.

Add support for the 15'' MacBook Pro Retina model (MacBookPro10,1).

Patch originally written by clipcarl (forums.opensuse.org).

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/bcm5974.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index f9e2758..e410b98 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -79,6 +79,10 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI	0x0252
 #define USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO	0x0253
 #define USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS	0x0254
+/* MacbookPro10,1 (unibody, June 2012) */
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI	0x0262
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_ISO	0x0263
+#define USB_DEVICE_ID_APPLE_WELLSPRING7_JIS	0x0264
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -128,6 +132,10 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5A_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING5A_JIS),
+	/* MacbookPro10,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -354,6 +362,18 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
 		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING7_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING7_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4750, 5280 },
+		{ DIM_Y, DIM_Y / SN_COORD, -150, 6730 }
+	},
 	{}
 };
 


