Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2HJBgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:36:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2HJBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:36:04 -0400
Message-ID: <1344562559.2996.4.camel@phoenix>
Subject: [PATCH 4/6] regulator: isl6271a: Remove get_voltage implementation
 for isl_fixed_ops
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>
Date: Fri, 10 Aug 2012 09:35:59 +0800
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
 drivers/regulator/isl6271a-regulator.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 1d145a0..d8ecf49 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -73,13 +73,7 @@ static struct regulator_ops isl_core_ops = {
 	.map_voltage	= regulator_map_voltage_linear,
 };
 
-static int isl6271a_get_fixed_voltage(struct regulator_dev *dev)
-{
-	return dev->desc->min_uV;
-}
-
 static struct regulator_ops isl_fixed_ops = {
-	.get_voltage	= isl6271a_get_fixed_voltage,
 	.list_voltage	= regulator_list_voltage_linear,
 };
 
-- 
1.7.9.5



