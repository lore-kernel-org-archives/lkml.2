Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1JINaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:30:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40118 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab1JINae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:30:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dp@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Allow rbtree to cache zero default values
Date: Sun,  9 Oct 2011 14:30:31 +0100
Message-Id: <1318167031-15412-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that when we start up in cache only mode we can store defaults of
zero, otherwise if the hardware is unavailable we won't be able to read.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e04e36e..e314984 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -252,9 +252,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		regcache_rbtree_set_register(rbnode, reg_tmp, value,
 					     map->cache_word_size);
 	} else {
-		/* bail out early, no need to create the rbnode yet */
-		if (!value)
-			return 0;
 		/* look for an adjacent register to the one we are about to add */
 		for (node = rb_first(&rbtree_ctx->root); node;
 		     node = rb_next(node)) {
-- 
1.7.6.3

