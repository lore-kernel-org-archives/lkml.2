Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1EFAZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:23 -0400
Received: from kroah.org ([198.145.64.141]:36932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab1EFAZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.494294413@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Nicolas Boichat <nicolas@boichat.ch>,
        Jean Delvare <khali@linux-fr.org>
Subject: [074/143] hwmon: (applesmc) Add iMac9,1 and MacBookPro2,2 support
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Justin P. Mattock <justinmattock@gmail.com>

commit e1741712e85cec8004c7eeeea81186618f78eff1 upstream.

Add the iMac9,1 and the MacBookPro2,2 temperature sensors to hwmon
driver applesmc to fix kernel bug #14429:
https://bugzilla.kernel.org/show_bug.cgi?id=14429

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -142,6 +142,12 @@ static const char *temperature_sensors_s
 	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
 	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
 	  NULL },
+/* Set 17: iMac 9,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
+	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
+/* Set 18: MacBook Pro 2,2 */
+	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
+	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1350,6 +1356,10 @@ static __initdata struct dmi_match_data
 	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
 /* MacPro3,1: temperature set 16 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
+/* iMac 9,1: light sensor only, temperature set 17 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
+/* MacBook Pro 2,2: accelerometer, backlight and temperature set 18 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1375,6 +1385,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
 		&applesmc_dmi_data[9]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 2,2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Computer, Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2") },
+		&applesmc_dmi_data[18]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
@@ -1415,6 +1429,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 9,1", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
+		&applesmc_dmi_data[17]},
 	{ applesmc_dmi_match, "Apple iMac 8", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },


