Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2DWIca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:32:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11706 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2DWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:32:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Apr 2012 01:32:28 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: Initialize pll_p_out1
Date: Mon, 23 Apr 2012 11:31:49 +0300
Message-Id: <1335169910-29403-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pll_a uses pll_p_out1 as its parent. Therefore this clock needs to be
initialized to make sure pll_a has a known input clock. Failure to do so
will cause the system to crash early in the bootup.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

--

Changes in v2:

* moved pll_p_out1 initialization to early_init to make it similar to the
  tegra20 code.
---
 arch/arm/mach-tegra/common.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index c50f2ee..654a457 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -95,6 +95,17 @@ static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 };
 #endif
 
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+static __initdata struct tegra_clk_init_table tegra30_clk_init_table[] = {
+	/* name		parent		rate		enabled */
+	{ "clk_m",	NULL,		0,		true },
+	{ "pll_p",	"clk_m",	408000000,	true },
+	{ "pll_p_out1",	"pll_p",	9600000,	true },
+	{ NULL,		NULL,		0,		0},
+};
+#endif
+
+
 static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 {
 #ifdef CONFIG_CACHE_L2X0
@@ -129,6 +140,7 @@ void __init tegra30_init_early(void)
 {
 	tegra_init_fuse();
 	tegra30_init_clocks();
+	tegra_clk_init_from_table(tegra30_clk_init_table);
 	tegra_init_cache(0x441, 0x551);
 	tegra_pmc_init();
 	tegra_powergate_init();
-- 
1.7.7.rc0.72.g4b5ea.dirty

