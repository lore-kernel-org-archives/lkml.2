Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1BMJoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:44:25 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1BMJnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:03 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] ARM: tegra: clock: Rearrange static clock tables
Date: Sun, 13 Feb 2011 01:40:20 -0800
Message-Id: <1297590033-15035-9-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the static clocks look more like the array of clocks
so they can all be initalized with the same helper function.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |  106 +++++++++++++++++------------------
 1 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index e1e0d81f..62ec3fb 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -1770,7 +1770,7 @@ static struct clk_mux_sel mux_clk_32k[] = {
 		.max_rate  = _max,			\
 	}
 
-struct clk tegra_periph_clks[] = {
+struct clk tegra_list_clks[] = {
 	PERIPH_CLK("rtc",	"rtc-tegra",		NULL,	4,	0,	32768,     mux_clk_32k,			PERIPH_NO_RESET),
 	PERIPH_CLK("timer",	"timer",		NULL,	5,	0,	26000000,  mux_clk_m,			0),
 	PERIPH_CLK("i2s1",	"i2s.0",		NULL,	11,	0x100,	26000000,  mux_pllaout0_audio2x_pllp_clkm,	MUX | DIV_U71),
@@ -1879,71 +1879,67 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 		.clk = ck,	\
 	}
 
-struct clk_lookup tegra_clk_lookups[] = {
-	/* external root sources */
-	CLK(NULL,	"32k_clk",	&tegra_clk_32k),
-	CLK(NULL,	"pll_s",	&tegra_pll_s),
-	CLK(NULL,	"clk_m",	&tegra_clk_m),
-	CLK(NULL,	"pll_m",	&tegra_pll_m),
-	CLK(NULL,	"pll_m_out1",	&tegra_pll_m_out1),
-	CLK(NULL,	"pll_c",	&tegra_pll_c),
-	CLK(NULL,	"pll_c_out1",	&tegra_pll_c_out1),
-	CLK(NULL,	"pll_p",	&tegra_pll_p),
-	CLK(NULL,	"pll_p_out1",	&tegra_pll_p_out1),
-	CLK(NULL,	"pll_p_out2",	&tegra_pll_p_out2),
-	CLK(NULL,	"pll_p_out3",	&tegra_pll_p_out3),
-	CLK(NULL,	"pll_p_out4",	&tegra_pll_p_out4),
-	CLK(NULL,	"pll_a",	&tegra_pll_a),
-	CLK(NULL,	"pll_a_out0",	&tegra_pll_a_out0),
-	CLK(NULL,	"pll_d",	&tegra_pll_d),
-	CLK(NULL,	"pll_d_out0",	&tegra_pll_d_out0),
-	CLK(NULL,	"pll_u",	&tegra_pll_u),
-	CLK(NULL,	"pll_x",	&tegra_pll_x),
-	CLK(NULL,	"pll_e",	&tegra_pll_e),
-	CLK(NULL,	"cclk",		&tegra_clk_cclk),
-	CLK(NULL,	"sclk",		&tegra_clk_sclk),
-	CLK(NULL,	"hclk",		&tegra_clk_hclk),
-	CLK(NULL,	"pclk",		&tegra_clk_pclk),
-	CLK(NULL,	"clk_d",	&tegra_clk_d),
-	CLK(NULL,	"clk_dev1",	&tegra_dev1_clk),
-	CLK(NULL,	"clk_dev2",	&tegra_dev2_clk),
-	CLK(NULL,	"cpu",		&tegra_clk_virtual_cpu),
-	CLK(NULL,	"blink",	&tegra_clk_blink),
-};
+struct clk *tegra_ptr_clks[] = {
+	&tegra_clk_32k,
+	&tegra_pll_s,
+	&tegra_clk_m,
+	&tegra_pll_m,
+	&tegra_pll_m_out1,
+	&tegra_pll_c,
+	&tegra_pll_c_out1,
+	&tegra_pll_p,
+	&tegra_pll_p_out1,
+	&tegra_pll_p_out2,
+	&tegra_pll_p_out3,
+	&tegra_pll_p_out4,
+	&tegra_pll_a,
+	&tegra_pll_a_out0,
+	&tegra_pll_d,
+	&tegra_pll_d_out0,
+	&tegra_pll_u,
+	&tegra_pll_x,
+	&tegra_pll_e,
+	&tegra_clk_cclk,
+	&tegra_clk_sclk,
+	&tegra_clk_hclk,
+	&tegra_clk_pclk,
+	&tegra_clk_d,
+	&tegra_dev1_clk,
+	&tegra_dev2_clk,
+	&tegra_clk_virtual_cpu,
+	&tegra_clk_blink,
+};
+
+static void tegra2_init_one_clock(struct clk *c)
+{
+	clk_init(c);
+	if (!c->lookup.dev_id && !c->lookup.con_id)
+		c->lookup.con_id = c->name;
+	c->lookup.clk = c;
+	clkdev_add(&c->lookup);
+}
 
 void __init tegra2_init_clocks(void)
 {
 	int i;
-	struct clk_lookup *cl;
 	struct clk *c;
-	struct clk_duplicate *cd;
-
-	for (i = 0; i < ARRAY_SIZE(tegra_clk_lookups); i++) {
-		cl = &tegra_clk_lookups[i];
-		clk_init(cl->clk);
-		clkdev_add(cl);
-	}
 
-	for (i = 0; i < ARRAY_SIZE(tegra_periph_clks); i++) {
-		c = &tegra_periph_clks[i];
-		cl = &c->lookup;
-		cl->clk = c;
+	for (i = 0; i < ARRAY_SIZE(tegra_ptr_clks); i++)
+		tegra2_init_one_clock(tegra_ptr_clks[i]);
 
-		clk_init(cl->clk);
-		clkdev_add(cl);
-	}
+	for (i = 0; i < ARRAY_SIZE(tegra_list_clks); i++)
+		tegra2_init_one_clock(&tegra_list_clks[i]);
 
 	for (i = 0; i < ARRAY_SIZE(tegra_clk_duplicates); i++) {
-		cd = &tegra_clk_duplicates[i];
-		c = tegra_get_clock_by_name(cd->name);
-		if (c) {
-			cl = &cd->lookup;
-			cl->clk = c;
-			clkdev_add(cl);
-		} else {
+		c = tegra_get_clock_by_name(tegra_clk_duplicates[i].name);
+		if (!c) {
 			pr_err("%s: Unknown duplicate clock %s\n", __func__,
-				cd->name);
+				tegra_clk_duplicates[i].name);
+			continue;
 		}
+
+		tegra_clk_duplicates[i].lookup.clk = c;
+		clkdev_add(&tegra_clk_duplicates[i].lookup);
 	}
 
 	init_audio_sync_clock_mux();
-- 
1.7.3.1

