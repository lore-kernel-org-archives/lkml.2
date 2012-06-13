Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2FMNjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:39:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab2FMNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:38:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Remove warning on stubbed dev_get_regmap()
Date: Wed, 13 Jun 2012 14:38:56 +0100
Message-Id: <1339594736-6712-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's perfectly sensible to ask if there's a regmap for a device which
doesn't have one so the stubbed version shouldn't complain, the caller
should be prepared for this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4c9e642..c3508d0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -388,7 +388,6 @@ static inline int regmap_register_patch(struct regmap *map,
 static inline struct regmap *dev_get_regmap(struct device *dev,
 					    const char *name)
 {
-	WARN_ONCE(1, "regmap API is disabled");
 	return NULL;
 }
 
-- 
1.7.10

