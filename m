Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab2FHC3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:29:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42905 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2FHC32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:29:28 -0400
Message-ID: <1339122561.5794.4.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: ab8500: Remove min_uV and max_uV from
 struct ab8500_regulator_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 08 Jun 2012 10:29:21 +0800
In-Reply-To: <1339122469.5794.2.camel@phoenix>
References: <1339122469.5794.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_uV and max_uV are not really used in the code and misleading because
the min_uV and max_uV settings does not match the value in the voltage table.

For example, we have
static const unsigned int ldo_vaux3_voltages[] = {
        1200000,
        1500000,
        1800000,
        2100000,
        2500000,
        2750000,
        2790000,
        2910000,
};

With below min_uV/max_uV settings for AB8500_LDO_AUX3.
.min_uV                 = 1100000,
.max_uV                 = 3300000,

The min_uV/max_uV for AB8500_LDO_AUX3 seems copy-paste from AB8500_LDO_AUX2
and is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c931c7c..13d424f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -30,8 +30,6 @@
  * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
- * @max_uV: maximum voltage (for variable voltage supplies)
- * @min_uV: minimum voltage (for variable voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable regulator
@@ -45,8 +43,6 @@ struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
-	int max_uV;
-	int min_uV;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
@@ -301,8 +297,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x03,
@@ -321,8 +315,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
 		.update_mask		= 0x0c,
@@ -341,8 +333,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
 		.update_mask		= 0x03,
@@ -361,8 +351,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
-- 
1.7.9.5



