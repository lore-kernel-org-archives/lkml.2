Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2K0G7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:59:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15445 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2K0G7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:59:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 26 Nov 2012 22:59:41 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: moving stuff away from mach/clk.h
Date: Tue, 27 Nov 2012 08:59:13 +0200
Message-ID: <1353999553-5196-2-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com>
References: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some stuff away from mach/clk.h to other mach-tegra
files. This is part of the efforts to get rid of mach/clk.h which in
turn will help to enable single zImage.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/clock.c            |    1 +
 arch/arm/mach-tegra/clock.h            |   12 ++++++++++--
 arch/arm/mach-tegra/include/mach/clk.h |   11 -----------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 867bf8b..4440626 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <mach/clk.h>
 
 #include "board.h"
 #include "clock.h"
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 2aa37f5..e6685d4 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -25,8 +25,6 @@
 #include <linux/clkdev.h>
 #include <linux/list.h>
 
-#include <mach/clk.h>
-
 #define DIV_BUS			(1 << 0)
 #define DIV_U71			(1 << 1)
 #define DIV_U71_FIXED		(1 << 2)
@@ -70,6 +68,15 @@ struct clk_pll_freq_table {
 	u8		cpcon;
 };
 
+enum tegra_clk_ex_param {
+	TEGRA_CLK_VI_INP_SEL,
+	TEGRA_CLK_DTV_INVERT,
+	TEGRA_CLK_NAND_PAD_DIV2_ENB,
+	TEGRA_CLK_PLLD_CSI_OUT_ENB,
+	TEGRA_CLK_PLLD_DSI_OUT_ENB,
+	TEGRA_CLK_PLLD_MIPI_MUX_SEL,
+};
+
 enum clk_state {
 	UNINITIALIZED = 0,
 	ON,
@@ -149,5 +156,6 @@ void tegra2_init_clocks(void);
 void tegra30_init_clocks(void);
 struct clk *tegra_get_clock_by_name(const char *name);
 void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
+int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
 
 #endif
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index 64d2657..6338652 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -22,18 +22,7 @@
 
 struct clk;
 
-enum tegra_clk_ex_param {
-	TEGRA_CLK_VI_INP_SEL,
-	TEGRA_CLK_DTV_INVERT,
-	TEGRA_CLK_NAND_PAD_DIV2_ENB,
-	TEGRA_CLK_PLLD_CSI_OUT_ENB,
-	TEGRA_CLK_PLLD_DSI_OUT_ENB,
-	TEGRA_CLK_PLLD_MIPI_MUX_SEL,
-};
-
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
-int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
-
 #endif
-- 
1.7.9.5

