Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2JKOEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:04:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39247 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2JKOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:04:05 -0400
Message-ID: <1349964231.9925.1.camel@phoenix>
Subject: [PATCH] hwmon: da9052: Use da9052_reg_update for rmw operations
From: Axel Lin <axel.lin@ingics.com>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 22:03:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/hwmon/da9052-hwmon.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index b8d01c5..1970494 100644
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -60,30 +60,17 @@ static inline int vbbat_reg_to_mV(int value)
 	return DIV_ROUND_CLOSEST(value * 2500, 512);
 }
 
-static int da9052_enable_vddout_channel(struct da9052 *da9052)
+static inline int da9052_enable_vddout_channel(struct da9052 *da9052)
 {
-	int ret;
-
-	ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
-	if (ret < 0)
-		return ret;
-
-	ret |= DA9052_ADCCONT_AUTOVDDEN;
-
-	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
+	return da9052_reg_update(da9052, DA9052_ADC_CONT_REG,
+				 DA9052_ADCCONT_AUTOVDDEN,
+				 DA9052_ADCCONT_AUTOVDDEN);
 }
 
-static int da9052_disable_vddout_channel(struct da9052 *da9052)
+static inline int da9052_disable_vddout_channel(struct da9052 *da9052)
 {
-	int ret;
-
-	ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
-	if (ret < 0)
-		return ret;
-
-	ret &= ~DA9052_ADCCONT_AUTOVDDEN;
-
-	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
+	return da9052_reg_update(da9052, DA9052_ADC_CONT_REG,
+				 DA9052_ADCCONT_AUTOVDDEN, 0);
 }
 
 static ssize_t da9052_read_vddout(struct device *dev,
-- 
1.7.9.5



