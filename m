Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2LNPAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:00:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53123 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2LNPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:00:10 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Fix MSHC clocks instance names
Date: Fri, 14 Dec 2012 23:59:44 +0900
Message-Id: <1355497184-26825-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clock instance name of MSHC controller for BIC and CIU of Exynos4412.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/mach-exynos/clock-exynos4.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-exynos/clock-exynos4.c
index efead60..ae83011 100644
--- a/arch/arm/mach-exynos/clock-exynos4.c
+++ b/arch/arm/mach-exynos/clock-exynos4.c
@@ -529,8 +529,8 @@ static struct clk exynos4_init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= "dwmmc",
-		.parent		= &exynos4_clk_aclk_133.clk,
+		.name		= "biu",
+		.parent		= &exynos4_clk_aclk_200.clk,
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
@@ -1132,15 +1132,7 @@ static struct clksrc_clk exynos4_clksrcs[] = {
 		.sources = &exynos4_clkset_mout_mfc,
 		.reg_src = { .reg = EXYNOS4_CLKSRC_MFC, .shift = 8, .size = 1 },
 		.reg_div = { .reg = EXYNOS4_CLKDIV_MFC, .shift = 0, .size = 4 },
-	}, {
-		.clk	= {
-			.name		= "sclk_dwmmc",
-			.parent		= &exynos4_clk_dout_mmc4.clk,
-			.enable		= exynos4_clksrc_mask_fsys_ctrl,
-			.ctrlbit	= (1 << 16),
-		},
-		.reg_div = { .reg = EXYNOS4_CLKDIV_FSYS3, .shift = 8, .size = 8 },
-	}
+	},
 };
 
 static struct clksrc_clk exynos4_clk_sclk_uart0 = {
@@ -1235,6 +1227,16 @@ static struct clksrc_clk exynos4_clk_sclk_mmc3 = {
 	.reg_div = { .reg = EXYNOS4_CLKDIV_FSYS2, .shift = 24, .size = 8 },
 };
 
+static struct clksrc_clk exynos4_clk_sclk_dwmci = {
+	.clk    = {
+		.name           = "ciu",
+		.parent         = &exynos4_clk_dout_mmc4.clk,
+		.enable         = exynos4_clksrc_mask_fsys_ctrl,
+		.ctrlbit        = (1 << 16),
+	},
+	.reg_div = { .reg = EXYNOS4_CLKDIV_FSYS3, .shift = 8, .size = 8 },
+};
+
 static struct clksrc_clk exynos4_clk_mdout_spi0 = {
 	.clk	= {
 		.name		= "mdout_spi",
@@ -1348,6 +1350,7 @@ static struct clksrc_clk *exynos4_clksrc_cdev[] = {
 	&exynos4_clk_sclk_mmc1,
 	&exynos4_clk_sclk_mmc2,
 	&exynos4_clk_sclk_mmc3,
+	&exynos4_clk_sclk_dwmci,
 	&exynos4_clk_sclk_spi0,
 	&exynos4_clk_sclk_spi1,
 	&exynos4_clk_sclk_spi2,
-- 
1.7.9.5

