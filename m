Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2KZPm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:42:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33262 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2KZPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:42:27 -0500
Message-ID: <1353944534.13762.1.camel@phoenix>
Subject: [PATCH] regulator: tps51632: Fix writing to wrong register when
 enable_pwm_dvfs is set
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 23:42:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tps->enable_pwm_dvfs is true, write to TPS51632_VOLTAGE_BASE_REG rather
than TPS51632_VOLTAGE_SELECT_REG.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps51632-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index a9c3a4a..b22c3f2 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -128,7 +128,7 @@ static int tps51632_dcdc_set_voltage_sel(struct regulator_dev *rdev,
 	if (vsel > TPS51632_MAX_VSEL)
 		return -EINVAL;
 
-	ret = regmap_write(tps->regmap, TPS51632_VOLTAGE_SELECT_REG, vsel);
+	ret = regmap_write(tps->regmap, reg, vsel);
 	if (ret < 0)
 		dev_err(tps->dev, "reg write failed, err %d\n", ret);
 	return ret;
-- 
1.7.9.5



