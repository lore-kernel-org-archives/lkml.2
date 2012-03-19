Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162165Ab2CSQgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:36:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52959 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910Ab2CSQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:36:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Mark all get and enable calls as __must_check
Date: Mon, 19 Mar 2012 16:36:35 +0000
Message-Id: <1332174995-9915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's generally important that devices have power when they expect it so
drivers really ought to be checking for errors on the power up paths.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/consumer.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 4ed1b30..ed05443 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -141,18 +141,18 @@ void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
 /* regulator output control and status */
-int regulator_enable(struct regulator *regulator);
+int __must_check regulator_enable(struct regulator *regulator);
 int regulator_disable(struct regulator *regulator);
 int regulator_force_disable(struct regulator *regulator);
 int regulator_is_enabled(struct regulator *regulator);
 int regulator_disable_deferred(struct regulator *regulator, int ms);
 
-int regulator_bulk_get(struct device *dev, int num_consumers,
-		       struct regulator_bulk_data *consumers);
-int devm_regulator_bulk_get(struct device *dev, int num_consumers,
-			    struct regulator_bulk_data *consumers);
-int regulator_bulk_enable(int num_consumers,
-			  struct regulator_bulk_data *consumers);
+int __must_check regulator_bulk_get(struct device *dev, int num_consumers,
+				    struct regulator_bulk_data *consumers);
+int __must_check devm_regulator_bulk_get(struct device *dev, int num_consumers,
+					 struct regulator_bulk_data *consumers);
+int __must_check regulator_bulk_enable(int num_consumers,
+				       struct regulator_bulk_data *consumers);
 int regulator_bulk_disable(int num_consumers,
 			   struct regulator_bulk_data *consumers);
 int regulator_bulk_force_disable(int num_consumers,
-- 
1.7.9.1

