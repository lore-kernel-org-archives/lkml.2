Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0KIPQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:16:31 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:53564 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815Ab0KIPQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:16:30 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Edgar Hucek <gimli@dark-green.com>, stable@kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 01/11] hwmon: applesmc: Add MacBookAir3,1(3,2) support
Date: Tue,  9 Nov 2010 16:15:01 +0100
Message-Id: <1289315711-3011-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpvj-0000jQ-44.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpvj-0000jQ-44 f84af2c1f45856cb786d7aa8e8c65f50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgar Hucek <gimli@dark-green.com>

This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
applesmc driver.

[rydberg@euromail.se: minor cleanup]
Cc: stable@kernel.org
Signed-off-by: Edgar Hucek <gimli@dark-green.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b6598aa..d616174 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -162,6 +162,10 @@ static const char *temperature_sensors_sets[][41] = {
 /* Set 22: MacBook Pro 7,1 */
 	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
 	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
+/* Set 23: MacBook Air 3,1 */
+	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0E", "TC0P", "TC1E", "TCZ3",
+	  "TCZ4", "TCZ5", "TG0E", "TG1E", "TG2E", "TGZ3", "TGZ4", "TGZ5",
+	  "TH0F", "TH0O", "TM0P" },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1524,11 +1528,17 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
 /* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
+/* MacBook Air 3,1: accelerometer, backlight and temperature set 23 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air 3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3") },
+		&applesmc_dmi_data[23]},
 	{ applesmc_dmi_match, "Apple MacBook Air 2", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2") },
-- 
1.7.1

