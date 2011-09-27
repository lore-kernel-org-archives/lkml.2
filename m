Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1I0SRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:17:03 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1033 "HELO
	smtp-out-133.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751631Ab1I0SRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:17:00 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 19656
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] regmap: regcache_rbtree_{set,get}_register: Use regcache_{set,get}_val
Date: Tue, 27 Sep 2011 20:15:37 +0200
Message-Id: <1317147338-21492-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regcache_{set,get}_val in regcache_rbtree_{set,get}_register instead of
re-implementing its functionality.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c |   35 +-------------------------------
 1 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index dd1b937..52669de 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -46,45 +46,14 @@ static unsigned int regcache_rbtree_get_register(
 	struct regcache_rbtree_node *rbnode, unsigned int idx,
 	unsigned int word_size)
 {
-	unsigned int val;
-
-	switch (word_size) {
-	case 1: {
-		u8 *p = rbnode->block;
-		val = p[idx];
-		return val;
-	}
-	case 2: {
-		u16 *p = rbnode->block;
-		val = p[idx];
-		return val;
-	}
-	default:
-		BUG();
-		break;
-	}
-	return -1;
+	return regcache_get_val(rbnode->block, idx, word_size);
 }
 
 static void regcache_rbtree_set_register(struct regcache_rbtree_node *rbnode,
 					 unsigned int idx, unsigned int val,
 					 unsigned int word_size)
 {
-	switch (word_size) {
-	case 1: {
-		u8 *p = rbnode->block;
-		p[idx] = val;
-		break;
-	}
-	case 2: {
-		u16 *p = rbnode->block;
-		p[idx] = val;
-		break;
-	}
-	default:
-		BUG();
-		break;
-	}
+	regcache_set_val(rbnode->block, idx, val, word_size);
 }
 
 static struct regcache_rbtree_node *regcache_rbtree_lookup(
-- 
1.7.2.5

