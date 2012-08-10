Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2HJBdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:33:52 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43599 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab2HJBdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:33:50 -0400
Message-ID: <1344562424.2996.2.camel@phoenix>
Subject: [PATCH 2/6] regulator: ab3100: Remove get_voltage implementation
 for regulator_ops_fixed
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Fri, 10 Aug 2012 09:33:44 +0800
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
 drivers/regulator/ab3100.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index c151fd5..65ad2b3 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -347,17 +347,11 @@ static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
 	return abreg->plfdata->external_voltage;
 }
 
-static int ab3100_get_fixed_voltage_regulator(struct regulator_dev *reg)
-{
-	return reg->desc->min_uV;
-}
-
 static struct regulator_ops regulator_ops_fixed = {
 	.list_voltage = regulator_list_voltage_linear,
 	.enable      = ab3100_enable_regulator,
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
-	.get_voltage = ab3100_get_fixed_voltage_regulator,
 };
 
 static struct regulator_ops regulator_ops_variable = {
-- 
1.7.9.5



