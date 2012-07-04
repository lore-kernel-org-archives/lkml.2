Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2GDLuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:50:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207Ab2GDLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:50:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: arizona-micsupp: Force regulated mode until we have API support
Date: Wed,  4 Jul 2012 12:50:28 +0100
Message-Id: <1341402628-22742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's almost certainly what the user would expect.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index fdd7473..450a069 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -144,6 +144,10 @@ static __devinit int arizona_micsupp_probe(struct platform_device *pdev)
 	else
 		config.init_data = &micsupp->init_data;
 
+	/* Default to regulated mode until the API supports bypass */
+	regmap_update_bits(arizona->regmap, ARIZONA_MIC_CHARGE_PUMP_1,
+			   ARIZONA_CPMIC_BYPASS, 0);
+
 	micsupp->regulator = regulator_register(&arizona_micsupp, &config);
 	if (IS_ERR(micsupp->regulator)) {
 		ret = PTR_ERR(micsupp->regulator);
-- 
1.7.10

