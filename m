Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1B1Bnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 20:43:52 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:65158 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1B1Bnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 20:43:51 -0500
From: Benson Leung <bleung@chromium.org>
To: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, bleung@chromium.org
Subject: [PATCH] power: bq20z75: Fix time and temp units
Date: Sun, 27 Feb 2011 17:41:48 -0800
Message-Id: <1298857308-22790-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298853672-21330-1-git-send-email-bleung@chromium.org>
References: <1298853672-21330-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected temperature and time to empty/full conversions.
Temperature is in 0.1°C, time is in seconds.

Corrected units in comment. "Convert to µWh."

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/power/bq20z75.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 4141775..123e169 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -269,12 +269,15 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 {
 #define BASE_UNIT_CONVERSION		1000
 #define BATTERY_MODE_CAP_MULT_WATT	(10 * BASE_UNIT_CONVERSION)
-#define TIME_UNIT_CONVERSION		600
-#define TEMP_KELVIN_TO_CELCIUS		2731
+#define TIME_UNIT_CONVERSION		60
+#define TEMP_KELVIN_TO_CELSIUS		2731
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
+		/* bq20z75 provides energy in units of 10mWh.
+		 * Convert to µWh
+		 */
 		val->intval *= BATTERY_MODE_CAP_MULT_WATT;
 		break;
 
@@ -288,14 +291,17 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
-		/* bq20z75 provides battery tempreture in 0.1°K
-		 * so convert it to 0.1°C */
-		val->intval -= TEMP_KELVIN_TO_CELCIUS;
-		val->intval *= 10;
+		/* bq20z75 provides battery temperature in 0.1K
+		 * so convert it to 0.1°C
+		 */
+		val->intval -= TEMP_KELVIN_TO_CELSIUS;
 		break;
 
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
+		/* bq20z75 provides time to empty and time to full in minutes.
+		 * Convert to seconds
+		 */
 		val->intval *= TIME_UNIT_CONVERSION;
 		break;
 
-- 
1.7.1

