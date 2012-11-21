Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2KULm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:42:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9176 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KULm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:42:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 21 Nov 2012 03:42:45 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/1] arm: tegra: fix comment in dsib clk set_parent
Date: Wed, 21 Nov 2012 13:42:27 +0200
Message-ID: <1353498147-14574-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the clk framework has already taken necessary locks before calling
into the arch clk ops code, no further locks are needed while setting
the parent of dsib clk. This patch removes a comment that indicated
otherwise, and yet did not take any locks.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/tegra30_clocks.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index efc000e..d714777 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -2045,9 +2045,7 @@ struct clk_ops tegra30_periph_clk_ops = {
 static int tegra30_dsib_clk_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct clk *d = clk_get_sys(NULL, "pll_d");
-	/* The DSIB parent selection bit is in PLLD base
-	   register - can not do direct r-m-w, must be
-	   protected by PLLD lock */
+	/* The DSIB parent selection bit is in PLLD base register */
 	tegra_clk_cfg_ex(
 		d, TEGRA_CLK_PLLD_MIPI_MUX_SEL, index);
 
-- 
1.7.9.5

