Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2EGMpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:45:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1906 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab2EGMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:45:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 May 2012 05:45:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 1/2] regulator: tps62360: enable register cache
Date: Mon,  7 May 2012 18:08:25 +0530
Message-Id: <1336394306-2211-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
References: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable cache of device register using regmap cache RBTREE.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Just resending as part of this series.

 drivers/regulator/tps62360-regulator.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 20fef1d..e893080 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -262,8 +262,10 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 }
 
 static const struct regmap_config tps62360_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
+	.reg_bits		= 8,
+	.val_bits		= 8,
+	.max_register		= REG_CHIPID,
+	.cache_type		= REGCACHE_RBTREE,
 };
 
 static int __devinit tps62360_probe(struct i2c_client *client,
-- 
1.7.1.1

