Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1KZKvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:51:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56243 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1KZKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:51:10 -0500
Message-ID: <1322304658.18498.0.camel@phoenix>
Subject: [PATCH] regulator: export of_get_regulator_init_data
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Sat, 26 Nov 2011 18:50:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_regulator_init_data is called in drivers/regulator/fixed.c
which could be a module.

Export of_get_regulator_init_data to fix below build error:
ERROR: "of_get_regulator_init_data" [drivers/regulator/fixed.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/of_regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 76673c7..acd7045 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -10,6 +10,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/regulator/machine.h>
@@ -79,3 +80,4 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev)
 	of_get_regulation_constraints(dev->of_node, &init_data);
 	return init_data;
 }
+EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
-- 
1.7.5.4



