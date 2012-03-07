Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2CGHPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:15:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59966 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2CGHPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:15:50 -0500
Message-ID: <1331104540.7801.2.camel@phoenix>
Subject: [PATCH] regulator: Silence error message in max8998_pmic_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 07 Mar 2012 15:15:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a mistakenly committed debug logging.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 634f257..5890265 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -824,7 +824,6 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		       buck12_voltage_map_desc.step*i
 		       < (pdata->buck2_voltage2 / 1000))
 			i++;
-		printk(KERN_ERR "i2:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
 		max8998->buck2_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
 		if (ret)
-- 
1.7.5.4



