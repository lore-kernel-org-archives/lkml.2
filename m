Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1JRTQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:16:54 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59643 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1JRTQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:16:51 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Cc: Kyle Manna <kyle.manna@fuel7.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP: Fix early init definitions
Date: Tue, 18 Oct 2011 13:43:06 -0500
Message-Id: <1318963386-27382-1-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <CAM9fjH6TZnAWAPvp8Uvr4hHpf77CeRz3k=hv6FGN73X1aXTXQQ@mail.gmail.com>
References: <CAM9fjH6TZnAWAPvp8Uvr4hHpf77CeRz3k=hv6FGN73X1aXTXQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the archs defined in the config, some functions are
referenced without being defined. This fixes compile time errors that
would otherwise result.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 arch/arm/mach-omap2/io.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index aa96538..f1d18a2 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -359,6 +359,8 @@ static void __init omap_hwmod_init_postsetup(void)
 	omap_pm_if_early_init();
 }
 
+#if defined(CONFIG_SOC_OMAP2420)
+
 void __init omap2420_init_early(void)
 {
 	omap2_set_globals_242x();
@@ -370,6 +372,9 @@ void __init omap2420_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap2420_clk_init();
 }
+#endif
+
+#if defined(CONFIG_SOC_OMAP2430)
 
 void __init omap2430_init_early(void)
 {
@@ -382,11 +387,14 @@ void __init omap2430_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap2430_clk_init();
 }
+#endif
 
 /*
  * Currently only board-omap3beagle.c should call this because of the
  * same machine_id for 34xx and 36xx beagle.. Will get fixed with DT.
  */
+#if defined(CONFIG_ARCH_OMAP3)
+
 void __init omap3_init_early(void)
 {
 	omap2_set_globals_3xxx();
@@ -398,6 +406,7 @@ void __init omap3_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap3xxx_clk_init();
 }
+#endif
 
 void __init omap3430_init_early(void)
 {
@@ -431,6 +440,8 @@ void __init ti816x_init_early(void)
 	omap3xxx_clk_init();
 }
 
+#if defined(CONFIG_ARCH_OMAP4)
+
 void __init omap4430_init_early(void)
 {
 	omap2_set_globals_443x();
@@ -442,6 +453,8 @@ void __init omap4430_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap4xxx_clk_init();
 }
+#endif
+
 
 void __init omap_sdrc_init(struct omap_sdrc_params *sdrc_cs0,
 				      struct omap_sdrc_params *sdrc_cs1)
-- 
1.7.5.4

