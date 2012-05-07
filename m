Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2EGHju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:39:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19935 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2EGHjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:39:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 May 2012 00:38:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lrg@ti.com, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 2/4] regulator: tps62360: enable register cache
Date: Mon,  7 May 2012 13:05:37 +0530
Message-Id: <1336376139-1048-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable cache of device register using regmap cache RBTREE.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps62360-regulator.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 20fef1d..375f757 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -262,8 +262,11 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 }
 
 static const struct regmap_config tps62360_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
+	.reg_bits		= 8,
+	.val_bits		= 8,
+	.max_register		= REG_CHIPID,
+	.num_reg_defaults_raw	= REG_CHIPID + 1,
+	.cache_type		= REGCACHE_RBTREE,
 };
 
 static int __devinit tps62360_probe(struct i2c_client *client,
-- 
1.7.1.1

