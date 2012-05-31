Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2EaJjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:39:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2EaJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:39:32 -0400
Message-ID: <1338457140.4165.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: wm831x-ldo: Use regulator_map_voltage_linear
 for wm831x_alive_ldo_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 31 May 2012 17:39:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm831x_alive_ldo_ops uses simple linear voltage maps.
Thus use regulator_map_voltage_linear is more efficient than using the default
regulator_map_voltage_iterate.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index a9a28d8..f23d020e9 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -690,6 +690,7 @@ static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_alive_ldo_ops = {
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage = wm831x_alive_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
-- 
1.7.9.5



