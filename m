Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2EPCJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:09:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46528 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab2EPCJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:09:40 -0400
Message-ID: <1337134167.5940.2.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: isl6271a: Use
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 16 May 2012 10:09:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 5caaf1f..78cdc90 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -83,15 +83,10 @@ static int isl6271a_set_voltage(struct regulator_dev *dev,
 	return err;
 }
 
-static int isl6271a_list_voltage(struct regulator_dev *dev, unsigned selector)
-{
-	return ISL6271A_VOLTAGE_MIN + (ISL6271A_VOLTAGE_STEP * selector);
-}
-
 static struct regulator_ops isl_core_ops = {
 	.get_voltage	= isl6271a_get_voltage,
 	.set_voltage	= isl6271a_set_voltage,
-	.list_voltage	= isl6271a_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 };
 
 static int isl6271a_get_fixed_voltage(struct regulator_dev *dev)
@@ -119,6 +114,8 @@ static const struct regulator_desc isl_rd[] = {
 		.ops		= &isl_core_ops,
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
+		.min_uV		= ISL6271A_VOLTAGE_MIN,
+		.uV_step	= ISL6271A_VOLTAGE_STEP,
 	}, {
 		.name		= "LDO1",
 		.id		= 1,
-- 
1.7.5.4



