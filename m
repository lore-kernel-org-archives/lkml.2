Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2ENHsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:48:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3884 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab2ENHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:48:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 May 2012 00:47:21 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <joe@perches.com>, <linux-tegra@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] memory: tegra{20,30}-mc: Use dev_err_ratelimited()
Date: Mon, 14 May 2012 10:47:58 +0300
Message-ID: <1336981680-15297-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336981680-15297-1-git-send-email-hdoyu@nvidia.com>
References: <20120514.104512.775373956832728793.hdoyu@nvidia.com>
 <1336981680-15297-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new dev_*_ratelimited() instead of pr_*_ratelimited() for
better info to print.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/memory/tegra20-mc.c |    3 ++-
 drivers/memory/tegra30-mc.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 21a735e..d525322 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -161,7 +161,8 @@ static void tegra20_mc_decode(struct tegra20_mc *mc, int n)
 
 	idx = n - MC_INT_ERR_SHIFT;
 	if ((idx < 0) || (idx >= ARRAY_SIZE(reg))) {
-		pr_err_ratelimited("Unknown interrupt status %08lx\n", BIT(n));
+		dev_err_ratelimited(mc->dev, "Unknown interrupt status %08lx\n",
+				    BIT(n));
 		return;
 	}
 
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index c391c4e..fad6bb5 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -220,7 +220,8 @@ static void tegra30_mc_decode(struct tegra30_mc *mc, int n)
 
 	idx = n - MC_INT_ERR_SHIFT;
 	if ((idx < 0) || (idx >= ARRAY_SIZE(mc_int_err)) || (idx == 1)) {
-		pr_err_ratelimited("Unknown interrupt status %08lx\n", BIT(n));
+		dev_err_ratelimited(mc->dev, "Unknown interrupt status %08lx\n",
+				    BIT(n));
 		return;
 	}
 
-- 
1.7.5.4

