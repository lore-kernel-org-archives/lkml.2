Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2DFVQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:16:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60047 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab2DFVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:16:10 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: validate regmap_raw_read/write val_len
Date: Fri,  6 Apr 2012 15:16:03 -0600
Message-Id: <1333746963-6793-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

val_len should be a multiple of val_bytes. If it's not, error out early.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Mark, these checks are currently implemented in regmap-mmio.c. In a second,
I'll send a patch to remove them from there.

 drivers/base/regmap/regmap.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2b5e7ae..40f9101 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -621,6 +621,9 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	if (val_len % map->format.val_bytes)
+		return -EINVAL;
+
 	map->lock(map);
 
 	ret = _regmap_raw_write(map, reg, val, val_len);
@@ -779,6 +782,9 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
+	if (val_len % map->format.val_bytes)
+		return -EINVAL;
+
 	map->lock(map);
 
 	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
-- 
1.7.0.4

