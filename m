Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GEBi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:38:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2GEBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:38:24 -0400
Message-ID: <1341452295.5435.1.camel@phoenix>
Subject: [PATCH] regulator: ab3100: Use rdev_get_drvdata() rather than use
 reg->reg_data driectly
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 09:38:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 5f771a8..182b553 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -155,7 +155,7 @@ ab3100_regulators[AB3100_NUM_REGULATORS] = {
  */
 static int ab3100_enable_regulator(struct regulator_dev *reg)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	int err;
 	u8 regval;
 
@@ -186,7 +186,7 @@ static int ab3100_enable_regulator(struct regulator_dev *reg)
 
 static int ab3100_disable_regulator(struct regulator_dev *reg)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	int err;
 	u8 regval;
 
@@ -219,7 +219,7 @@ static int ab3100_disable_regulator(struct regulator_dev *reg)
 
 static int ab3100_is_enabled_regulator(struct regulator_dev *reg)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	u8 regval;
 	int err;
 
@@ -236,7 +236,7 @@ static int ab3100_is_enabled_regulator(struct regulator_dev *reg)
 
 static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	u8 regval;
 	int err;
 
@@ -270,7 +270,7 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
 					    unsigned selector)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	u8 regval;
 	int err;
 
@@ -299,7 +299,7 @@ static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
 static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
 						int uV)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 	u8 regval;
 	int err;
 	int bestindex;
@@ -342,7 +342,7 @@ static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
  */
 static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
 {
-	struct ab3100_regulator *abreg = reg->reg_data;
+	struct ab3100_regulator *abreg = rdev_get_drvdata(reg);
 
 	return abreg->plfdata->external_voltage;
 }
-- 
1.7.9.5



