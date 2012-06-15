Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2FORzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:55:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698Ab2FORzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:55:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix double free in devm_regulator_put()
Date: Fri, 15 Jun 2012 18:55:43 +0100
Message-Id: <1339782943-16652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 63507a5..a2c5cfb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1461,9 +1461,7 @@ void devm_regulator_put(struct regulator *regulator)
 
 	rc = devres_release(regulator->dev, devm_regulator_release,
 			    devm_regulator_match, regulator);
-	if (rc == 0)
-		regulator_put(regulator);
-	else
+	if (rc != 0)
 		WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
-- 
1.7.10

