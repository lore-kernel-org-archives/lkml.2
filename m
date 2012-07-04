Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab2GDCby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:31:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42468 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2GDCbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:31:51 -0400
Message-ID: <1341369105.10587.8.camel@phoenix>
Subject: [PATCH RFT] regulator: ab8500: Set enable enable_time in
 regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 10:31:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Linus,
While working on this patch, I found in original code:
ab8500_regulator_ops set enable_time callback to ab8500_regulator_enable_time,
but does not set the delay in ab8500_regulator_info.
I'm not sure the delay value is 0 for ab8500_regulator_ops, or the setting is
just missing.
Anyway, there is no behavior change by this patch.

Regards,
Axel
 drivers/regulator/ab8500.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 13d424f..6230c40 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -238,13 +238,6 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int ab8500_regulator_enable_time(struct regulator_dev *rdev)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return info->delay;
-}
-
 static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int old_sel,
 					     unsigned int new_sel)
@@ -261,7 +254,6 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
-	.enable_time	= ab8500_regulator_enable_time,
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
@@ -276,7 +268,6 @@ static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage	= ab8500_fixed_get_voltage,
 	.list_voltage	= regulator_list_voltage_linear,
-	.enable_time	= ab8500_regulator_enable_time,
 };
 
 static struct ab8500_regulator_info
@@ -374,6 +365,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2000000,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.update_bank		= 0x03,
-- 
1.7.9.5



