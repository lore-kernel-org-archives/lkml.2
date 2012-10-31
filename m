Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab2J3SR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:17:27 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59052 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933957Ab2J3SMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:43 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] omap2-clk: Add missing lcdc clock definition
Date: Wed, 31 Oct 2012 17:56:02 +0200
Message-Id: <1351698962-3923-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the lcdc clock definition got dropped.
It is required for the LCD controller to work. Reintroduce.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/mach-omap2/clock33xx_data.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-omap2/clock33xx_data.c b/arch/arm/mach-omap2/clock33xx_data.c
index 1a45d6b..b7b7995 100644
--- a/arch/arm/mach-omap2/clock33xx_data.c
+++ b/arch/arm/mach-omap2/clock33xx_data.c
@@ -867,6 +867,16 @@ static struct clk lcd_gclk = {
 	.recalc		= &followparent_recalc,
 };
 
+static struct clk lcdc_fck = {
+	.name           = "lcdc_fck",
+	.clkdm_name     = "lcdc_clkdm",
+	.parent         = &lcd_gclk,
+	.enable_reg     = AM33XX_CM_PER_LCDC_CLKCTRL,
+	.enable_bit     = AM33XX_MODULEMODE_SWCTRL,
+	.ops            = &clkops_omap2_dflt,
+	.recalc         = &followparent_recalc,
+};
+
 static struct clk mmc_clk = {
 	.name		= "mmc_clk",
 	.clkdm_name	= "l4ls_clkdm",
@@ -1075,6 +1085,7 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"clkout2_ck",		&clkout2_ck,	CK_AM33XX),
 	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick,	CK_AM33XX),
 	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck,	CK_AM33XX),
+	CLK("da8xx_lcdc.0",     NULL,           &lcdc_fck,      CK_AM33XX),
 };
 
 int __init am33xx_clk_init(void)
-- 
1.7.12

