Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1EFAZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:17 -0400
Received: from kroah.org ([198.145.64.141]:36943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab1EFAZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.702924861@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>,
        Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>
Subject: [076/143] hwmon: (applesmc) Add generic support for MacBook Pro 6
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>

commit 872bad55e2d3fcc13e1e8770a3b200f0c6ca5126 upstream.

This patch adds generic support for the MacBook Pro 6 family
based on the 6,2 model.

[rydberg@euromail.se: patch cleanup]
Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -155,6 +155,10 @@ static const char *temperature_sensors_s
 /* Set 20: MacBook Pro 5,4 */
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
 	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
+/* Set 21: MacBook Pro 6,2 */
+	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
+	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
+	  "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1371,6 +1375,8 @@ static __initdata struct dmi_match_data
 	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
 /* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
+/* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1392,6 +1398,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3") },
 		&applesmc_dmi_data[19]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 6", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro6") },
+		&applesmc_dmi_data[21]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },


