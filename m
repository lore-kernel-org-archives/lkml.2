Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0DBVHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:07:46 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:54090 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0DBVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nSQMXMaD+dFV5YBLDdMKKylOJvnXIjldgLv7ovcwXxtr+8LjNZhLstyv+Zdj0h331z
         BR0jfxvoNFQo2Hp+F28dzAeLNASrOd07cuqKmFAcDotyXTnpwl81cYpNdYsODgTIIt5T
         z/rO7BuTM2Bbof3BKZ6Yf04MfJkzNpkG1YloI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] hwmon:applesmc: Add support for iMac 9.
Date: Fri,  2 Apr 2010 14:07:26 -0700
Message-Id: <1270242446-12333-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds support to hwmon:applesmc for the iMac9,1.
Without this the default settings for applesmc and iMac
are to set the machine to use only nine temperature
sensors, with this patch you get all fourteen of them.


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index c1605b5..6ab3e78 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -142,6 +142,9 @@ static const char *temperature_sensors_sets[][41] = {
 	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
 	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
 	  NULL },
+/* Set 17: iMac9,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
+	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1350,6 +1353,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
 /* MacPro3,1: temperature set 16 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
+/* iMac 9: light sensor only, temperature set 17 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1415,6 +1420,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 9", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
+		&applesmc_dmi_data[17]},
 	{ applesmc_dmi_match, "Apple iMac 8", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
-- 
1.6.5.GIT

