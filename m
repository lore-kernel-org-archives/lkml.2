Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2D3V4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:56:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab2D3V4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:56:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Cache single values read from the chip
Date: Mon, 30 Apr 2012 22:55:57 +0100
Message-Id: <1335822957-5492-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't have a cached value for a register and we can cache it then
when we do a read a value we should add it to the cache to save rereading
it later on. Do this for single register reads, for block reads the code
would be a little more complex and this covers most practical usage.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 178989a..b57bb86 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -698,6 +698,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 		trace_regmap_reg_read(map->dev, reg, *val);
 	}
 
+	if (!map->cache_bypass)
+		regcache_write(map, reg, *val);
+
 	return ret;
 }
 
-- 
1.7.10

