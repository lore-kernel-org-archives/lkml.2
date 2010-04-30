Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab0D3Vi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:38:56 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:55876 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759689Ab0D3Viy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:38:54 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Bernhard Froemel <froemel@vmars.tuwien.ac.at>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/3] hwmon: applesmc: Add generic support for MacBook Pro 6
Date: Fri, 30 Apr 2010 23:38:05 +0200
Message-Id: <1272663486-16945-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272663486-16945-1-git-send-email-rydberg@euromail.se>
References: <1272663486-16945-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O7xux-000527-5V.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1O7xux-000527-5V 31ddd160b7e022f8622afb384f332db0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>

This patch adds generic support for the MacBook Pro 6 family
based on the 6,2 model.

[rydberg@euromail.se: patch cleanup]
Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 67626c1..2ea6e67 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -155,6 +155,10 @@ static const char *temperature_sensors_sets[][41] = {
 /* Set 20: MacBook Pro 5,4 */
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
 	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
+/* Set 21: MacBook Pro 6,2 */
+	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
+	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
+	  "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1371,6 +1375,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
 /* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
+/* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1392,6 +1398,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
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
-- 
1.6.3.3

