Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1LUPot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:44:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52283 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1LUPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:44:46 -0500
From: Michael Williamson <michael.williamson@criticallink.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Williamson <michael.williamson@criticallink.com>,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de
Subject: [PATCH] regmap: fix return value in regcache-indexed read call.
Date: Wed, 21 Dec 2011 10:48:02 -0500
Message-Id: <1324482482-30889-1-git-send-email-michael.williamson@criticallink.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regcache_read() API for regmap requires a 0 return value for
successful cached reads.  The read method for the indexed type
cache implementation is returning the positive map offset for a
successful read, which is incorrect.  Fix it.

Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
---
 drivers/base/regmap/regcache-indexed.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
index 507731a..ade5b8c 100644
--- a/drivers/base/regmap/regcache-indexed.c
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -22,8 +22,10 @@ static int regcache_indexed_read(struct regmap *map, unsigned int reg,
 	ret = regcache_lookup_reg(map, reg);
 	if (ret >= 0)
 		*value = map->reg_defaults[ret].def;
+	else
+		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int regcache_indexed_write(struct regmap *map, unsigned int reg,
-- 
1.7.0.4

