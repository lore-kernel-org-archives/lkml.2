Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2EINOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:14:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3072 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab2EINOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:14:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 May 2012 06:13:58 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] mfd: tps65910: cache register when we need it
Date: Wed,  9 May 2012 18:40:54 +0530
Message-Id: <1336569057-3890-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During regmap initialization, we do not provide the default value and
hence in place of caching register during regmap_init(), cache it
when actually we need it i.e. after reading of that register.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 7a55af9..0f95ddf 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -85,8 +85,7 @@ static const struct regmap_config tps65910_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.volatile_reg = is_volatile_reg,
-	.max_register = TPS65910_MAX_REGISTER,
-	.num_reg_defaults_raw = TPS65910_MAX_REGISTER,
+	.max_register = TPS65910_MAX_REGISTER - 1,
 	.cache_type = REGCACHE_RBTREE,
 };
 
-- 
1.7.1.1

