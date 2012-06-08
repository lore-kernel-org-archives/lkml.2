Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2FHAPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:15:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48918 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2FHAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:14:59 -0400
Message-ID: <1339114489.4310.1.camel@phoenix>
Subject: [PATCH v2] regulator: isl6271a: Use regulator_list_voltage_linear
 for isl_fixed_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 08:14:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This is v2 of
regulator: isl6271a: Use regulator_[list|map]_voltage_linear for isl_fixed_ops.
I changed the subject line because map_voltage_linear is not used in this patch.

 drivers/regulator/isl6271a-regulator.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 56d273f..1d145a0 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -75,19 +75,12 @@ static struct regulator_ops isl_core_ops = {
 
 static int isl6271a_get_fixed_voltage(struct regulator_dev *dev)
 {
-	int id = rdev_get_id(dev);
-	return (id == 1) ? 1100000 : 1300000;
-}
-
-static int isl6271a_list_fixed_voltage(struct regulator_dev *dev, unsigned selector)
-{
-	int id = rdev_get_id(dev);
-	return (id == 1) ? 1100000 : 1300000;
+	return dev->desc->min_uV;
 }
 
 static struct regulator_ops isl_fixed_ops = {
 	.get_voltage	= isl6271a_get_fixed_voltage,
-	.list_voltage	= isl6271a_list_fixed_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 };
 
 static const struct regulator_desc isl_rd[] = {
@@ -107,6 +100,7 @@ static const struct regulator_desc isl_rd[] = {
 		.ops		= &isl_fixed_ops,
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
+		.min_uV		= 1100000,
 	}, {
 		.name		= "LDO2",
 		.id		= 2,
@@ -114,6 +108,7 @@ static const struct regulator_desc isl_rd[] = {
 		.ops		= &isl_fixed_ops,
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
+		.min_uV		= 1300000,
 	},
 };
 
-- 
1.7.9.5



