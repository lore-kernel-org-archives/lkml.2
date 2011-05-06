Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1EFAZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:19 -0400
Received: from kroah.org ([198.145.64.141]:36938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1EFAZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.597554744@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>
Subject: [075/143] hwmon: (applesmc) Add support for MacBook Pro 5,3 and 5,4
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 4e4a99d32721800c061191027f18f780dcbd9e0b upstream.

The MacBookPro 5,3 model has two fans, whereas the 5,4 model has
only one. This patch adds explicit support for the 5,3 and 5,4 models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/applesmc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -148,6 +148,13 @@ static const char *temperature_sensors_s
 /* Set 18: MacBook Pro 2,2 */
 	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
 	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
+/* Set 19: Macbook Pro 5,3 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
+	  "TG0F", "TG0H", "TG0P", "TG0T", "TN0D", "TN0P", "TTF0", "Th2H",
+	  "Tm0P", "Ts0P", "Ts0S", NULL },
+/* Set 20: MacBook Pro 5,4 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
+	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1360,6 +1367,10 @@ static __initdata struct dmi_match_data
 	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
 /* MacBook Pro 2,2: accelerometer, backlight and temperature set 18 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
+/* MacBook Pro 5,3: accelerometer, backlight and temperature set 19 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
+/* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1373,6 +1384,14 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5,4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4") },
+		&applesmc_dmi_data[20]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5,3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3") },
+		&applesmc_dmi_data[19]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },


