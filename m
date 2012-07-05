Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2GETgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:36:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41975 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958Ab2GETfh (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] mfd: arizona: Release DCVDD if we fail to resume the device
Date: Thu,  5 Jul 2012 20:35:29 +0100
Message-Id: <1341516933-16474-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensures we don't leak the enable we just did.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index d5ef6fa..2ca43a0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -232,8 +232,10 @@ static int arizona_runtime_resume(struct device *dev)
 	regcache_cache_only(arizona->regmap, false);
 
 	ret = arizona_wait_for_boot(arizona);
-	if (ret != 0)
+	if (ret != 0) {
+		regulator_disable(arizona->dcvdd);
 		return ret;
+	}
 
 	regcache_sync(arizona->regmap);
 
-- 
1.7.10

