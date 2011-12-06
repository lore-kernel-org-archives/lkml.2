Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab1LFKtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:49:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab1LFKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:49:30 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1
Date: Tue,  6 Dec 2011 16:15:55 +0530
Message-Id: <1323168355-2764-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
References: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amba core assumes the pclk to be named as apb_pclk. During device probe,
it tries to get that clock and enable that. When PM_RUNTIME is enabled,
dma clock is not explicitly enabled in pl330_probe, which causes device
probe to fail. Adding a clkdev entry for apb_pclk for mdma1 fixes the
problem.

This patch fixes following runtime error.

dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.2 failed with error -22

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/mach-exynos/clock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/clock.c b/arch/arm/mach-exynos/clock.c
index 28e2842..eb33a7a 100644
--- a/arch/arm/mach-exynos/clock.c
+++ b/arch/arm/mach-exynos/clock.c
@@ -1326,6 +1326,7 @@ static struct clk_lookup exynos4_clk_lookup[] = {
 	CLKDEV_INIT("s3c-sdhci.3", "mmc_busclk.2", &clk_sclk_mmc3.clk),
 	CLKDEV_INIT("dma-pl330.0", "apb_pclk", &clk_pdma0),
 	CLKDEV_INIT("dma-pl330.1", "apb_pclk", &clk_pdma1),
+	CLKDEV_INIT("dma-pl330.2", "apb_pclk", &clk_mdma1),
 };
 
 static int xtal_rate;
-- 
1.7.4.1

