Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2GGBqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:46:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62559 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GGBqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:46:53 -0400
Message-ID: <1341625605.7754.1.camel@phoenix>
Subject: [PATCH] regulator: da9052: Use for_each_child_of_node() macro
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 07 Jul 2012 09:46:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 88976d8..5f8f71a 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -405,8 +405,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 		if (!nproot)
 			return -ENODEV;
 
-		for (np = of_get_next_child(nproot, NULL); np;
-		     np = of_get_next_child(nproot, np)) {
+		for_each_child_of_node(nproot, np) {
 			if (!of_node_cmp(np->name,
 					 regulator->info->reg_desc.name)) {
 				config.init_data = of_get_regulator_init_data(
-- 
1.7.9.5



