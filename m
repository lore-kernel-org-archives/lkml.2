Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1LTJMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:12:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42106 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1LTJMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:12:07 -0500
Message-ID: <1324372320.16878.6.camel@phoenix>
Subject: [PATCH] regulator: da9052: Staticize non-exported symbols
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 20 Dec 2011 17:12:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da9052_regulator_info and da9053_regulator_info are not used outside
this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index f2840b5..3767364 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -461,7 +461,7 @@ static struct regulator_ops da9052_ldo_ops = {
 	.activate_bit = (abits),\
 }
 
-struct da9052_regulator_info da9052_regulator_info[] = {
+static struct da9052_regulator_info da9052_regulator_info[] = {
 	/* Buck1 - 4 */
 	DA9052_DCDC(0, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
 	DA9052_DCDC(1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
@@ -480,7 +480,7 @@ struct da9052_regulator_info da9052_regulator_info[] = {
 	DA9052_LDO(13, 50, 1200, 3600, 6, 6, 0),
 };
 
-struct da9052_regulator_info da9053_regulator_info[] = {
+static struct da9052_regulator_info da9053_regulator_info[] = {
 	/* Buck1 - 4 */
 	DA9052_DCDC(0, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
 	DA9052_DCDC(1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
-- 
1.7.5.4



