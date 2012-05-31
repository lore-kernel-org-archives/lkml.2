Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2EaJk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:40:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43652 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2EaJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:40:28 -0400
Message-ID: <1338457222.4165.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm8400: Use regulator_map_voltage_linear for
 wm8400_dcdc_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 31 May 2012 17:40:22 +0800
In-Reply-To: <1338457140.4165.1.camel@phoenix>
References: <1338457140.4165.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8400_dcdc_ops uses simple linear voltage maps.
Thus use regulator_map_voltage_linear is more efficient than using the default
regulator_map_voltage_iterate.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8400-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 69a2b7c..f365795 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -152,6 +152,7 @@ static struct regulator_ops wm8400_dcdc_ops = {
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = wm8400_dcdc_get_mode,
-- 
1.7.9.5



