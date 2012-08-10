Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2HJBfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:35:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55058 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2HJBe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:34:59 -0400
Message-ID: <1344562493.2996.3.camel@phoenix>
Subject: [PATCH 3/6] regulator: ab8500: Remove get_voltage implementation
 for ab8500_regulator_fixed_ops
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Fri, 10 Aug 2012 09:34:53 +0800
In-Reply-To: <1344562353.2996.1.camel@phoenix>
References: <1344562353.2996.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not required after commit f7df20ec
"regulator: core: Use list_voltage() to read single voltage regulators"

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8807166..c884a5c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -257,16 +257,10 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
-static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
-{
-	return rdev->desc->min_uV;
-}
-
 static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
-	.get_voltage	= ab8500_fixed_get_voltage,
 	.list_voltage	= regulator_list_voltage_linear,
 };
 
-- 
1.7.9.5



