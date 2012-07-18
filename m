Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2GRNSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:18:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36663 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab2GRNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:18:07 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: Fix incorrect arguments to kzalloc() call
Date: Wed, 18 Jul 2012 14:17:23 +0100
Message-Id: <1342617443-20450-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index d64a7fc..f05fc74 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -172,7 +172,7 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 		return ERR_PTR(-EINVAL);
 	}
 
-	ctx = kzalloc(GFP_KERNEL, sizeof(*ctx));
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.11.2

