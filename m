Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1LZPvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 10:51:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52610 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab1LZPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 10:51:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix annotations in da9052-core
Date: Mon, 26 Dec 2011 15:51:32 +0000
Message-Id: <1324914692-8477-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device initialisation should be marked __devinit and __devinitdata.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/da9052-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a7c115c..2a5e271 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -383,7 +383,7 @@ static struct resource da9052_tsi_resources[] = {
 	},
 };
 
-static struct mfd_cell __initdata da9052_subdev_info[] = {
+static struct mfd_cell __devinitdata da9052_subdev_info[] = {
 	{
 		.name = "da9052-regulator",
 		.id = 1,
@@ -637,7 +637,7 @@ struct regmap_config da9052_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(da9052_regmap_config);
 
-int da9052_device_init(struct da9052 *da9052, u8 chip_id)
+int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
 	struct irq_desc *desc;
-- 
1.7.7.3

