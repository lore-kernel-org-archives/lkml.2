Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0DKVnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:43:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62196 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab0DKVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C7xv0hu1ppu3CSEqkeM3CRvbBRljktVZhEJuQlgOugv5f3GTr7Tban0Kg9f0dpwv9w
         knJJYcBztkp8PXG46eb0bU1p49PzTOUeF3Eyt40EF7e5GOMCVE0q4KXr/4eaKmQf7n/Q
         5Li+/YS+aNI4mmcCTmB3JiAvN73VH5HbSx4f8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]BUG FIX: hwmon applesmc.c add iMac9,1 and MacBookPro2,2 to fix bug 14429 
Date: Sun, 11 Apr 2010 14:43:22 -0700
Message-Id: <1271022202-4348-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the iMac9,1 and the MacBookPro2,2
temperature sensors to hwmon applesmc.c to fix bug entry: 
https://bugzilla.kernel.org/show_bug.cgi?id=14429

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index c1605b5..5e762ac 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -142,6 +142,12 @@ static const char *temperature_sensors_sets[][41] = {
 	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
 	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
 	  NULL },
+/* Set 17: iMac9,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
+	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
+/* Set 18: MacBookPro2,2 */
+	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
+	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1350,6 +1356,10 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
 /* MacPro3,1: temperature set 16 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
+/* iMac9,1: light sensor only, temperature set 17 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
+/* MacBookPro2,2: accelerometer, backlight and temperature set 18 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1375,6 +1385,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
 		&applesmc_dmi_data[9]},
+	{ applesmc_dmi_match, "Apple MacBookPro2,2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Computer, Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2") },
+		&applesmc_dmi_data[18]},
 	{ applesmc_dmi_match, "Apple MacBook Pro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
@@ -1415,6 +1429,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac9,1", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
+		&applesmc_dmi_data[17]},
 	{ applesmc_dmi_match, "Apple iMac 8", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
-- 
1.6.5.GIT

