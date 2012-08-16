Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2HPEc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:32:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2HPEc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:32:58 -0400
Message-ID: <1345091162.14780.0.camel@phoenix>
Subject: [PATCH] regulator: max8907: Fix n_voltages for MAX8907B SD1
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Thu, 16 Aug 2012 12:26:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For linear voltage mapping, the n_voltages is (max - min) / step + 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8907-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index bd3b28b..bdf21a1 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -286,7 +286,8 @@ static __devinit int max8907_regulator_probe(struct platform_device *pdev)
 	    MAX8907_II2RR_VERSION_REV_B) {
 		pmic->desc[MAX8907_SD1].min_uV = 637500;
 		pmic->desc[MAX8907_SD1].uV_step = 12500;
-		pmic->desc[MAX8907_SD1].n_voltages = (1425000 - 637500) / 12500;
+		pmic->desc[MAX8907_SD1].n_voltages =
+						(1425000 - 637500) / 12500 + 1;
 	}
 
 	for (i = 0; i < MAX8907_NUM_REGULATORS; i++) {
-- 
1.7.9.5



