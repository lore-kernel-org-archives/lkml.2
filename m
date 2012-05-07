Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2EGORt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:17:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab2EGORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:17:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Use newly added devres_release() rather than open coding
Date: Mon,  7 May 2012 15:17:44 +0100
Message-Id: <1336400264-15529-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devres_release() will call the destructor for the resource as well as
freeing the devres data.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 62a46b2..b2e6043 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1459,12 +1459,9 @@ void devm_regulator_put(struct regulator *regulator)
 {
 	int rc;
 
-	rc = devres_destroy(regulator->dev, devm_regulator_release,
+	rc = devres_release(regulator->dev, devm_regulator_release,
 			    devm_regulator_match, regulator);
-	if (rc == 0)
-		regulator_put(regulator);
-	else
-		WARN_ON(rc);
+	WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
-- 
1.7.10

