Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1EFAZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:25 -0400
Received: from kroah.org ([198.145.64.141]:36952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab1EFAZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.797640385@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>
Subject: [077/143] hwmon: (applesmc) Add generic support for MacBook Pro 7
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 405eaa1c1d045cdd872802fc515f638573984880 upstream.

This patch adds generic support for the MacBook Pro 7 family
based on the 7,1 model.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -159,6 +159,9 @@ static const char *temperature_sensors_s
 	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
 	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
 	  "Ts0P", "Ts0S", NULL },
+/* Set 22: MacBook Pro 7,1 */
+	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
+	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1377,6 +1380,8 @@ static __initdata struct dmi_match_data
 	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
 /* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
+/* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1390,6 +1395,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 7", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro7") },
+		&applesmc_dmi_data[22]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 5,4", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4") },


