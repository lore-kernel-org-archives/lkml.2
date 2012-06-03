Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2FCPMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 11:12:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36980 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2FCPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 11:12:22 -0400
Message-ID: <1338736336.21662.7.camel@phoenix>
Subject: [PATCH] regulator: wm8350: Use regulator_map_voltage_linear for
 wm8350_dcdc_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 03 Jun 2012 23:12:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8350_dcdc_ops uses simple linear voltage maps.
Thus use regulator_map_voltage_linear is more efficient than using the default
regulator_map_voltage_iterate.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index a618284..33c37f9 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1036,6 +1036,7 @@ static struct regulator_ops wm8350_dcdc_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
-- 
1.7.9.5



