Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2FCOqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 10:46:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54388 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2FCOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 10:46:24 -0400
Message-ID: <1338734774.21662.2.camel@phoenix>
Subject: [PATCH] regulator: max77686: Use regulator_map_voltage_linear for
 simple linear mappings
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sun, 03 Jun 2012 22:46:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both max77686_ops and max77686_buck_dvs_ops use simple linear voltage maps.
Thus use regulator_map_voltage_linear is more efficient than using the defult
regulator_map_voltage_iterate.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max77686.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 70046f8..4e9f4f3 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -90,6 +90,7 @@ static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
@@ -100,6 +101,7 @@ static struct regulator_ops max77686_ops = {
 
 static struct regulator_ops max77686_buck_dvs_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-- 
1.7.9.5



