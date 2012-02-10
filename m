Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab2BJLaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:30:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57032 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab2BJLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:30:04 -0500
Message-ID: <1328873395.4203.1.camel@phoenix>
Subject: [PATCH] regmap: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 10 Feb 2012 19:29:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index f9cdaf3..11d54e7 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -785,7 +785,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 		}
 	}
 
-	map->patch = kcalloc(sizeof(struct reg_default), num_regs, GFP_KERNEL);
+	map->patch = kcalloc(num_regs, sizeof(struct reg_default), GFP_KERNEL);
 	if (map->patch != NULL) {
 		memcpy(map->patch, regs,
 		       num_regs * sizeof(struct reg_default));
-- 
1.7.5.4



