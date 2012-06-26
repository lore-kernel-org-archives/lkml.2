Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab2FZHUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:20:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10890 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2FZHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:20:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Jun 2012 00:20:31 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <ccross@android.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pgaikwad@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma".
Date: Tue, 26 Jun 2012 12:48:32 +0530
Message-ID: <1340695112-28270-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340695112-28270-1-git-send-email-ldewangan@nvidia.com>
References: <1340695112-28270-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the driver name of the clock entry of Tegra APBDMA to
tegra-apbdma from of tegra-dma.

This name is more aligned towards the movement of dmaengine based
new DMA driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/dma.c            |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c  |    2 +-
 arch/arm/mach-tegra/tegra30_clocks.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index 2698d7d..29c5114 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -714,7 +714,7 @@ int __init tegra_dma_init(void)
 
 	bitmap_fill(channel_usage, NV_DMA_MAX_CHANNELS);
 
-	c = clk_get_sys("tegra-dma", NULL);
+	c = clk_get_sys("tegra-apbdma", NULL);
 	if (IS_ERR(c)) {
 		pr_err("Unable to get clock for APB DMA\n");
 		ret = PTR_ERR(c);
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index b59315c..91281ab 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -2149,7 +2149,7 @@ static struct clk tegra_clk_emc = {
 	}
 
 static struct clk tegra_list_clks[] = {
-	PERIPH_CLK("apbdma",	"tegra-dma",		NULL,	34,	0,	108000000, mux_pclk,			0),
+	PERIPH_CLK("apbdma",	"tegra-apbdma",		NULL,	34,	0,	108000000, mux_pclk,			0),
 	PERIPH_CLK("rtc",	"rtc-tegra",		NULL,	4,	0,	32768,     mux_clk_32k,			PERIPH_NO_RESET),
 	PERIPH_CLK("timer",	"timer",		NULL,	5,	0,	26000000,  mux_clk_m,			0),
 	PERIPH_CLK("i2s1",	"tegra20-i2s.0",	NULL,	11,	0x100,	26000000,  mux_pllaout0_audio2x_pllp_clkm,	MUX | DIV_U71),
diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index e33fe4b..d622423 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -2871,7 +2871,7 @@ static struct clk tegra30_clk_twd = {
 		},					\
 	}
 struct clk tegra_list_clks[] = {
-	PERIPH_CLK("apbdma",	"tegra-dma",		NULL,	34,	0,	26000000,  mux_clk_m,			0),
+	PERIPH_CLK("apbdma",	"tegra-apbdma",		NULL,	34,	0,	26000000,  mux_clk_m,			0),
 	PERIPH_CLK("rtc",	"rtc-tegra",		NULL,	4,	0,	32768,     mux_clk_32k,			PERIPH_NO_RESET | PERIPH_ON_APB),
 	PERIPH_CLK("kbc",	"tegra-kbc",		NULL,	36,	0,	32768,     mux_clk_32k,			PERIPH_NO_RESET | PERIPH_ON_APB),
 	PERIPH_CLK("timer",	"timer",		NULL,	5,	0,	26000000,  mux_clk_m,			0),
-- 
1.7.1.1

