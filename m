Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab0D3VjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:39:13 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45786 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759686Ab0D3VjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:39:01 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/3] hwmon: applesmc: Add generic support for MacBook Pro 7
Date: Fri, 30 Apr 2010 23:38:06 +0200
Message-Id: <1272663486-16945-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272663486-16945-2-git-send-email-rydberg@euromail.se>
References: <1272663486-16945-1-git-send-email-rydberg@euromail.se>
 <1272663486-16945-2-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O7xv8-0005zr-8c.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O7xv8-0005zr-8c 831ea4bc2d317c93db4838ff9051ad63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds generic support for the MacBook Pro 7 family
based on the 7,1 model.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2ea6e67..36a0d62 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -159,6 +159,9 @@ static const char *temperature_sensors_sets[][41] = {
 	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
 	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
 	  "Ts0P", "Ts0S", NULL },
+/* Set 22: MacBook Pro 7,1 */
+	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
+	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1377,6 +1380,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
 /* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
+/* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1390,6 +1395,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
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
-- 
1.6.3.3

