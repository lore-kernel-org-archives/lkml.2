Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2KTBGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:06:23 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54992 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2KTBGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:06:20 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v5 5/5] ARM: OMAP4: hwmod data: ipu and dsp to use parent clocks instead of leaf clocks
Date: Mon, 19 Nov 2012 19:05:52 -0600
Message-Id: <1353373552-16039-6-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents hwmod _enable_clocks...omap2_dflt_clk_enable path
from enabling modulemode inside CLKCTRL using its clk->enable_reg
field. Instead is left to _omap4_enable_module though soc_ops, as
the one in charge of this setting.

According to comments received[1] for related patches the idea is
to get rid of leaf clocks in future. So remove these two while at it.

[1] http://lkml.org/lkml/2012/8/20/226

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/clock44xx_data.c       |   22 ----------------------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    4 ++--
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-omap2/clock44xx_data.c b/arch/arm/mach-omap2/clock44xx_data.c
index 6efc30c..067c486 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -1316,16 +1316,6 @@ static struct clk dmic_fck = {
 	.clkdm_name	= "abe_clkdm",
 };
 
-static struct clk dsp_fck = {
-	.name		= "dsp_fck",
-	.ops		= &clkops_omap2_dflt,
-	.enable_reg	= OMAP4430_CM_TESLA_TESLA_CLKCTRL,
-	.enable_bit	= OMAP4430_MODULEMODE_HWCTRL,
-	.clkdm_name	= "tesla_clkdm",
-	.parent		= &dpll_iva_m4x2_ck,
-	.recalc		= &followparent_recalc,
-};
-
 static struct clk dss_sys_clk = {
 	.name		= "dss_sys_clk",
 	.ops		= &clkops_omap2_dflt,
@@ -1696,16 +1686,6 @@ static struct clk i2c4_fck = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk ipu_fck = {
-	.name		= "ipu_fck",
-	.ops		= &clkops_omap2_dflt,
-	.enable_reg	= OMAP4430_CM_DUCATI_DUCATI_CLKCTRL,
-	.enable_bit	= OMAP4430_MODULEMODE_HWCTRL,
-	.clkdm_name	= "ducati_clkdm",
-	.parent		= &ducati_clk_mux_ck,
-	.recalc		= &followparent_recalc,
-};
-
 static struct clk iss_ctrlclk = {
 	.name		= "iss_ctrlclk",
 	.ops		= &clkops_omap2_dflt,
@@ -3151,7 +3131,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"div_ts_ck",			&div_ts_ck,	CK_446X),
 	CLK(NULL,	"dmic_sync_mux_ck",		&dmic_sync_mux_ck,	CK_443X),
 	CLK(NULL,	"dmic_fck",			&dmic_fck,	CK_443X),
-	CLK(NULL,	"dsp_fck",			&dsp_fck,	CK_443X),
 	CLK(NULL,	"dss_sys_clk",			&dss_sys_clk,	CK_443X),
 	CLK(NULL,	"dss_tv_clk",			&dss_tv_clk,	CK_443X),
 	CLK(NULL,	"dss_48mhz_clk",		&dss_48mhz_clk,	CK_443X),
@@ -3183,7 +3162,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"i2c2_fck",			&i2c2_fck,	CK_443X),
 	CLK(NULL,	"i2c3_fck",			&i2c3_fck,	CK_443X),
 	CLK(NULL,	"i2c4_fck",			&i2c4_fck,	CK_443X),
-	CLK(NULL,	"ipu_fck",			&ipu_fck,	CK_443X),
 	CLK(NULL,	"iss_ctrlclk",			&iss_ctrlclk,	CK_443X),
 	CLK(NULL,	"iss_fck",			&iss_fck,	CK_443X),
 	CLK(NULL,	"iva_fck",			&iva_fck,	CK_443X),
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index aab5c12..1f61093 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -650,7 +650,7 @@ static struct omap_hwmod omap44xx_dsp_hwmod = {
 	.mpu_irqs	= omap44xx_dsp_irqs,
 	.rst_lines	= omap44xx_dsp_resets,
 	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_dsp_resets),
-	.main_clk	= "dsp_fck",
+	.main_clk	= "dpll_iva_m4x2_ck",
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = OMAP4_CM_TESLA_TESLA_CLKCTRL_OFFSET,
@@ -1677,7 +1677,7 @@ static struct omap_hwmod omap44xx_ipu_hwmod = {
 	.mpu_irqs	= omap44xx_ipu_irqs,
 	.rst_lines	= omap44xx_ipu_resets,
 	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_ipu_resets),
-	.main_clk	= "ipu_fck",
+	.main_clk	= "ducati_clk_mux_ck",
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = OMAP4_CM_DUCATI_DUCATI_CLKCTRL_OFFSET,
-- 
1.7.4.1

