Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111Ab2GLOXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:23:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933848Ab2GLOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:23:35 -0400
Message-ID: <1342103005.2857.1.camel@phoenix>
Subject: [PATCH] regulator: da9052: initialize of_node param for regulator
 register
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 22:23:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize config.of_node for regulator before registering.
This is needed for DT based regulator support.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 5f8f71a..903299c 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -410,6 +410,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 					 regulator->info->reg_desc.name)) {
 				config.init_data = of_get_regulator_init_data(
 					&pdev->dev, np);
+				config.of_node = np;
 				break;
 			}
 		}
-- 
1.7.9.5



