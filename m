Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696Ab2JZSG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:06:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37443 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965561Ab2JZSGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:06:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: core: Report registers in hex when we can't cache
Date: Fri, 26 Oct 2012 19:05:57 +0100
Message-Id: <1351274757-26260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be the most common way of reporting register numbers, it's
certainly what we do for trace.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0585726..354b5cb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -850,7 +850,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 					     ival);
 			if (ret) {
 				dev_err(map->dev,
-				   "Error in caching of register: %u ret: %d\n",
+					"Error in caching of register: %x ret: %d\n",
 					reg + i, ret);
 				return ret;
 			}
-- 
1.7.10.4

