Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1KBPA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:00:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48160 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab1KBPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:00:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Rename LZO cache type to compressed
Date: Wed,  2 Nov 2011 15:00:23 +0000
Message-Id: <1320246023-8835-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users probably don't care about the specific compression algorithm and
we might want to use a different algorithm (snappy being the one I'm
thinking of right now) so update the public interface to have a more
generic name.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-lzo.c |    2 +-
 include/linux/regmap.h             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 0075690..226ffc1 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -354,7 +354,7 @@ static int regcache_lzo_sync(struct regmap *map)
 }
 
 struct regcache_ops regcache_lzo_ops = {
-	.type = REGCACHE_LZO,
+	.type = REGCACHE_COMPRESSED,
 	.name = "lzo",
 	.init = regcache_lzo_init,
 	.exit = regcache_lzo_exit,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 1198c9a..1e4ec2b 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -25,7 +25,7 @@ enum regcache_type {
 	REGCACHE_NONE,
 	REGCACHE_INDEXED,
 	REGCACHE_RBTREE,
-	REGCACHE_LZO
+	REGCACHE_COMPRESSED
 };
 
 /**
-- 
1.7.7.1

