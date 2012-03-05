Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab2CEXcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:32:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49006 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906Ab2CEXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:32:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regcache: Make sure we sync register 0 in an rbtree cache
Date: Mon,  5 Mar 2012 23:32:09 +0000
Message-Id: <1330990329-8566-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the current users have register 0 as a volatile register or don't
have a register 0 so it's not been apparent that it's not getting synced.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 313c20f..8d51916 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -396,7 +396,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 
 			/* Is this the hardware default?  If so skip. */
 			ret = regcache_lookup_reg(map, i);
-			if (ret > 0 && val == map->reg_defaults[ret].def)
+			if (ret >= 0 && val == map->reg_defaults[ret].def)
 				continue;
 
 			map->cache_bypass = 1;
-- 
1.7.9.1

