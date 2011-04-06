Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1DFPaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:30:16 -0400
Received: from imr4.ericy.com ([198.24.6.8]:58703 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab1DFPaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:30:15 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Chew <achew@nvidia.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] hwmon: (lm90) Add support for ADT7461A and NCT1008
Date: Wed, 6 Apr 2011 08:41:19 -0700
Message-ID: <1302104479-13363-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ADT7461A and NCT1008 to the lm90 driver.
Both chips have identical functionality and report the same manufacturing ID
and device ID values.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
Would this be a candidate for 2.6.39 and possibly -stable ?

 drivers/hwmon/Kconfig |    8 ++++----
 drivers/hwmon/lm90.c  |    6 ++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 060ef63..92d0251 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -618,10 +618,10 @@ config SENSORS_LM90
 	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
-	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, Maxim
-	  MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
-	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, and Winbond/Nuvoton
-	  W83L771W/G/AWG/ASG sensor chips.
+	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
+	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
+	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
+	  and Winbond/Nuvoton W83L771W/G/AWG/ASG sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 812781c..0aa892c 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -174,6 +174,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 static const struct i2c_device_id lm90_id[] = {
 	{ "adm1032", adm1032 },
 	{ "adt7461", adt7461 },
+	{ "adt7461a", adt7461 },
 	{ "lm90", lm90 },
 	{ "lm86", lm86 },
 	{ "lm89", lm86 },
@@ -1153,6 +1154,11 @@ static int lm90_detect(struct i2c_client *new_client,
 		 && (reg_config1 & 0x1B) == 0x00
 		 && reg_convrate <= 0x0A) {
 			name = "adt7461";
+		} else
+		if (chip_id == 0x57 /* ADT7461A, NCT1008 */
+		 && (reg_config1 & 0x1B) == 0x00
+		 && reg_convrate <= 0x0A) {
+			name = "adt7461a";
 		}
 	} else
 	if (man_id == 0x4D) { /* Maxim */
-- 
1.7.3.1

