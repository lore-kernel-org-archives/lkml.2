Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3ABPeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:34:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34390 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab3ABPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:34:44 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: debugfs: Fix attempts to read nonexistant register blocks
Date: Wed,  2 Jan 2013 15:34:41 +0000
Message-Id: <1357140881-6524-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the start of the last block we tried to read rather than a position,
and also make sure we update the byte position while we're at it.  Without
this reads that go into nonexistant areas get confused.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 07aad78..3ec8bc5 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -103,12 +103,12 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 
 	/* Find the relevant block */
 	list_for_each_entry(c, &map->debugfs_off_cache, list) {
-		if (*pos >= c->min && *pos <= c->max) {
-			*pos = c->min;
+		*pos = c->min;
+
+		if (*pos >= c->min && *pos <= c->max)
 			return c->base_reg;
-		}
 
-		ret = c->max;
+		ret = c->base_reg;
 	}
 
 	return ret;
-- 
1.7.10.4

