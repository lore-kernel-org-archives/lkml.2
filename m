Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0JAMBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:01:18 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:49185 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470Ab0JAMAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:00:02 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 51/69] SPEAr: Adding and Updating Clock definitions
Date: Fri,  1 Oct 2010 17:26:11 +0530
Message-Id: <07df8f5b97e4c0ee24396873df8ec05ba6939cda.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: shiraz hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/clock.c                  |  210 ++++++++++++++++++++-
 arch/arm/mach-spear13xx/include/mach/misc_regs.h |   19 ++
 arch/arm/mach-spear3xx/clock.c                   |    6 +-
 arch/arm/mach-spear6xx/clock.c                   |    4 +-
 4 files changed, 224 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-spear13xx/clock.c b/arch/arm/mach-spear13xx/clock.c
index 79942a9..75cd89c 100644
--- a/arch/arm/mach-spear13xx/clock.c
+++ b/arch/arm/mach-spear13xx/clock.c
@@ -355,6 +355,7 @@ static struct aux_clk_config uart_synth_config = {
 /* aux rate configuration table, in ascending order of rates */
 struct aux_rate_tbl aux_rtbl[] = {
 	/* For PLL1div2 = 500 MHz */
+	{.xscale = 2, .yscale = 21, .eq = 1}, /* 48 MHz */
 	{.xscale = 1, .yscale = 6, .eq = 1}, /* 83 MHz */
 	{.xscale = 1, .yscale = 4, .eq = 1}, /* 125 MHz */
 	{.xscale = 1, .yscale = 3, .eq = 1}, /* 166 MHz */
@@ -369,7 +370,7 @@ static struct clk uart_synth_clk = {
 	.calc_rate = &aux_calc_rate,
 	.recalc = &aux_clk_recalc,
 	.set_rate = &aux_clk_set_rate,
-	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 0},
+	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 1},
 	.private_data = &uart_synth_config,
 };
 
@@ -415,7 +416,7 @@ static struct clk sdhci_synth_clk = {
 	.calc_rate = &aux_calc_rate,
 	.recalc = &aux_clk_recalc,
 	.set_rate = &aux_clk_set_rate,
-	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 2},
+	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 0},
 	.private_data = &sdhci_synth_config,
 };
 
@@ -441,7 +442,7 @@ static struct clk cfxd_synth_clk = {
 	.calc_rate = &aux_calc_rate,
 	.recalc = &aux_clk_recalc,
 	.set_rate = &aux_clk_set_rate,
-	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 2},
+	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 0},
 	.private_data = &cfxd_synth_config,
 };
 
@@ -467,7 +468,7 @@ static struct clk c3_synth_clk = {
 	.calc_rate = &aux_calc_rate,
 	.recalc = &aux_clk_recalc,
 	.set_rate = &aux_clk_set_rate,
-	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 0},
+	.rate_config = {aux_rtbl, ARRAY_SIZE(aux_rtbl), 1},
 	.private_data = &c3_synth_config,
 };
 
@@ -579,7 +580,7 @@ static struct pclk_sel gmac_phy_pclk_sel = {
 };
 
 /* gmac phy clock */
-static struct clk gmac_phy_clk = {
+static struct clk gmac_phy0_clk = {
 	.flags = ALWAYS_ENABLED,
 	.pclk_sel = &gmac_phy_pclk_sel,
 	.pclk_sel_shift = GMAC_PHY_CLK_SHIFT,
@@ -697,8 +698,8 @@ static struct clk jpeg_clk = {
 	.recalc = &follow_parent,
 };
 
-/* gmac clock */
-static struct clk gmac_clk = {
+/* gmac clock :Fixed Part*/
+static struct clk gmac0_clk = {
 	.pclk = &ahb_clk,
 	.en_reg = PERIP1_CLK_ENB,
 	.en_reg_bit = GMAC_CLK_ENB,
@@ -839,6 +840,92 @@ static struct clk kbd_clk = {
 	.recalc = &follow_parent,
 };
 
+/* RAS CLOCKS */
+/* pll3 generated clock */
+static struct clk ras_pll3_clk = {
+	.pclk = &pll3_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = PLL3_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* pll2 generated clock */
+static struct clk ras_pll2_clk = {
+	.pclk = &pll2_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = PLL2_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* 125MHz clock generated on Tx pad */
+static struct clk ras_tx125_clk = {
+	.pclk = &gmii_txclk125_pad,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = C125_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* 30 MHz clock generated by USB PHy Pll */
+static struct clk ras_30Mhz_clk = {
+	.rate = 30000000,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = C30_CLK_ENB,
+};
+
+/* 48 MHz clock generated by USB PHy Pll */
+static struct clk ras_48Mhz_clk = {
+	.pclk = &pll5_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = C48_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* osc3 generated clock */
+static struct clk ras_osc3_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = OSC3_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* osc2 generated clock */
+static struct clk ras_osc2_clk = {
+	.pclk = &osc2_32k_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = OSC2_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* osc1 generated clock */
+static struct clk ras_osc1_clk = {
+	.pclk = &osc1_24m_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = OSC1_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* apb generated clock */
+static struct clk ras_pclk_clk = {
+	.pclk = &apb_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = PCLK_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* ahb generated clock */
+static struct clk ras_aclk_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = RAS_CLK_ENB,
+	.en_reg_bit = ACLK_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+/* External pad 50 MHz clock for phy operation */
+static struct clk ras_tx50_clk = {
+	.flags = ALWAYS_ENABLED,
+	.rate = 50000000,
+};
+
 /* spear1300 machine specific clock structures */
 #ifdef CONFIG_MACH_SPEAR1300
 
@@ -859,10 +946,92 @@ static struct clk can1_clk = {
 	.pclk = &apb_clk,
 	.recalc = &follow_parent,
 };
+
+/* gmac clocks :RAS part*/
+static struct clk gmac_ras1_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ras_aclk_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk gmac_ras2_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ras_aclk_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk gmac_ras3_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ras_aclk_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk gmac_ras4_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ras_aclk_clk,
+	.recalc = &follow_parent,
+};
+
+/* phy clock parent select */
+static struct pclk_info phy_pclk_info[] = {
+	{
+		.pclk = &ras_pll2_clk,
+		.pclk_val = 0x8,
+	}, {
+		.pclk = &ras_tx125_clk,
+		.pclk_val = 0x4,
+	}, {
+		.pclk = &ras_tx50_clk,
+		.pclk_val = 0x0,
+	},
+};
+
+static struct pclk_sel phy_pclk_sel = {
+	.pclk_info = phy_pclk_info,
+	.pclk_count = ARRAY_SIZE(phy_pclk_info),
+	.pclk_sel_reg = (unsigned int *)(IO_ADDRESS(SPEAR1310_RAS_CTRL_REG1)),
+	.pclk_sel_mask = SPEAR1310_PHY_CLK_MASK,
+};
+
+/* Phy 1 Clock */
+struct clk gmac_phy1_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &phy_pclk_sel,
+	.pclk_sel_shift = SPEAR1310_PHY_CLK_SHIFT,
+	.recalc = &follow_parent,
+};
+
+/* Phy 2 Clock */
+static struct clk gmac_phy2_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &phy_pclk_sel,
+	.pclk_sel_shift = SPEAR1310_PHY_CLK_SHIFT,
+	.recalc = &follow_parent,
+};
+
+/* Phy 3 Clock */
+static struct clk gmac_phy3_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &phy_pclk_sel,
+	.pclk_sel_shift = SPEAR1310_PHY_CLK_SHIFT,
+	.recalc = &follow_parent,
+};
+
+/* Phy 4 Clock */
+static struct clk gmac_phy4_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &phy_pclk_sel,
+	.pclk_sel_shift = SPEAR1310_PHY_CLK_SHIFT,
+	.recalc = &follow_parent,
+};
+
 #endif
 
+static struct clk dummy_apb_pclk;
+
 /* array of all spear 13xx clock lookups */
 static struct clk_lookup spear_clk_lookups[] = {
+	{ .con_id = "apb_pclk",		.clk = &dummy_apb_pclk},
 	/* root clks */
 	{.con_id = "osc1_24m_clk",	.clk = &osc1_24m_clk},
 	{.con_id = "osc2_32k_clk",	.clk = &osc2_32k_clk},
@@ -896,7 +1065,20 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{.con_id = "cfxd_synth_clk",		.clk = &cfxd_synth_clk},
 	{.con_id = "gmac_phy_input_clk",	.clk = &gmac_phy_input_clk},
 	{.con_id = "gmac_phy_synth_clk",	.clk = &gmac_phy_synth_clk},
-	{.con_id = "gmac_phy_clk",		.clk = &gmac_phy_clk},
+	{.dev_id = "stmmacphy.0",		.clk = &gmac_phy0_clk},
+
+	/* RAS clocks */
+	{.con_id = "ras_pll3_clk",		.clk = &ras_pll3_clk},
+	{.con_id = "ras_pll2_clk",		.clk = &ras_pll2_clk},
+	{.con_id = "ras_tx125_clk",		.clk = &ras_tx125_clk},
+	{.con_id = "ras_30Mhz_clk",		.clk = &ras_30Mhz_clk},
+	{.con_id = "ras_48Mhz_clk",		.clk = &ras_48Mhz_clk},
+	{.con_id = "ras_osc3_clk",		.clk = &ras_osc3_clk},
+	{.con_id = "ras_osc2_clk",		.clk = &ras_osc2_clk},
+	{.con_id = "ras_osc1_clk",		.clk = &ras_osc1_clk},
+	{.con_id = "ras_pclk_clk",		.clk = &ras_pclk_clk},
+	{.con_id = "ras_aclk_clk",		.clk = &ras_aclk_clk},
+	{.con_id = "ras_tx50_clk",		.clk = &ras_tx50_clk},
 
 	/* clocks having multiple parent source from above clocks */
 	{.dev_id = "clcd",		.clk = &clcd_clk},
@@ -910,12 +1092,12 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{.dev_id = "smi",		.clk = &smi_clk},
 	{.con_id = "usbh.0_clk",	.clk = &uhci0_clk},
 	{.con_id = "usbh.1_clk",	.clk = &uhci1_clk},
-	{.dev_id = "usbd",		.clk = &usbd_clk},
+	{.dev_id = "designware_udc",	.clk = &usbd_clk},
 	{.dev_id = "i2c_designware.0",	.clk = &i2c_clk},
 	{.dev_id = "dma0",		.clk = &dma0_clk},
 	{.dev_id = "dma1",		.clk = &dma1_clk},
 	{.dev_id = "jpeg",		.clk = &jpeg_clk},
-	{.dev_id = "gmac",		.clk = &gmac_clk},
+	{.dev_id = "stmmaceth.0",	.clk = &gmac0_clk},
 	{.dev_id = "c3",		.clk = &c3_clk},
 	{.dev_id = "pcie0",		.clk = &pcie0_clk},
 	{.dev_id = "pcie1",		.clk = &pcie1_clk},
@@ -944,6 +1126,14 @@ static struct clk_lookup spear_clk_lookups[] = {
 #ifdef CONFIG_MACH_SPEAR1310
 	{.dev_id = "spear_can.0",	.clk = &can0_clk},
 	{.dev_id = "spear_can.1",	.clk = &can1_clk},
+	{.dev_id = "stmmaceth.1",	.clk = &gmac_ras1_clk},
+	{.dev_id = "stmmaceth.2",	.clk = &gmac_ras2_clk},
+	{.dev_id = "stmmaceth.3",	.clk = &gmac_ras3_clk},
+	{.dev_id = "stmmaceth.4",	.clk = &gmac_ras4_clk},
+	{.dev_id = "stmmacphy.1",	.clk = &gmac_phy1_clk},
+	{.dev_id = "stmmacphy.2",	.clk = &gmac_phy2_clk},
+	{.dev_id = "stmmacphy.3",	.clk = &gmac_phy3_clk},
+	{.dev_id = "stmmacphy.4",	.clk = &gmac_phy4_clk},
 #endif
 };
 
diff --git a/arch/arm/mach-spear13xx/include/mach/misc_regs.h b/arch/arm/mach-spear13xx/include/mach/misc_regs.h
index 3cfd4fc..ea6096f 100644
--- a/arch/arm/mach-spear13xx/include/mach/misc_regs.h
+++ b/arch/arm/mach-spear13xx/include/mach/misc_regs.h
@@ -191,6 +191,25 @@
 	#define JPEG_SOF_RST		28
 #define PERIP2_SW_RST		((unsigned int *)(MISC_BASE + 0x280))
 #define RAS_CLK_ENB		((unsigned int *)(MISC_BASE + 0x284))
+	/* RAS_CLK_ENB register masks */
+	#define ACLK_CLK_ENB		0
+	#define PCLK_CLK_ENB		1
+	#define OSC1_CLK_ENB		2
+	#define OSC2_CLK_ENB		3
+	#define OSC3_CLK_ENB		4
+	#define C48_CLK_ENB		5
+	#define C30_CLK_ENB		6
+	#define C125_CLK_ENB		7
+	#define PLL2_CLK_ENB		8
+	#define PLL3_CLK_ENB		9
+	#define PCLK0_CLK_ENB		10
+	#define PCLK1_CLK_ENB		11
+	#define PCLK2_CLK_ENB		12
+	#define PCLK3_CLK_ENB		13
+	#define SYN0_CLK_ENB		14
+	#define SYN1_CLK_ENB		15
+	#define SYN2_CLK_ENB		16
+	#define SYN3_CLK_ENB		17
 #define RAS_SW_RST		((unsigned int *)(MISC_BASE + 0x288))
 #define PLL1_SYNT		((unsigned int *)(MISC_BASE + 0x28c))
 #define I2S_CLK_CFG		((unsigned int *)(MISC_BASE + 0x290))
diff --git a/arch/arm/mach-spear3xx/clock.c b/arch/arm/mach-spear3xx/clock.c
index 64d9cdc..814966a 100644
--- a/arch/arm/mach-spear3xx/clock.c
+++ b/arch/arm/mach-spear3xx/clock.c
@@ -713,7 +713,7 @@ static struct clk pwm_clk = {
 
 /* array of all spear 3xx clock lookups */
 static struct clk_lookup spear_clk_lookups[] = {
-	{ .con_id = "apb_pclk",	.clk = &dummy_apb_pclk},
+	{ .con_id = "apb_pclk",		.clk = &dummy_apb_pclk},
 	/* root clks */
 	{ .con_id = "osc_32k_clk",	.clk = &osc_32k_clk},
 	{ .con_id = "osc_24m_clk",	.clk = &osc_24m_clk},
@@ -738,8 +738,8 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{ .dev_id = "gpt1",		.clk = &gpt1_clk},
 	{ .dev_id = "gpt2",		.clk = &gpt2_clk},
 	/* clock derived from pll3 clk */
+	{ .dev_id = "designware_udc",   .clk = &usbd_clk},
 	{ .con_id = "usbh_clk",		.clk = &usbh_clk},
-	{ .dev_id = "usbd",		.clk = &usbd_clk},
 	/* clock derived from ahb clk */
 	{ .con_id = "ahbmult2_clk",	.clk = &ahbmult2_clk},
 	{ .con_id = "ddr_clk",		.clk = &ddr_clk},
@@ -755,7 +755,7 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{ .dev_id = "ssp-pl022.0",	.clk = &ssp0_clk},
 	{ .dev_id = "gpio",		.clk = &gpio_clk},
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
-	{ .dev_id = "physmap-flash",	.clk = &emi_clk},
+	{ .dev_id = "emi",		.clk = &emi_clk},
 #endif
 #if defined(CONFIG_MACH_SPEAR300) || defined(CONFIG_MACH_SPEAR310) || \
 	defined(CONFIG_MACH_SPEAR320)
diff --git a/arch/arm/mach-spear6xx/clock.c b/arch/arm/mach-spear6xx/clock.c
index f1429f5..63aab69 100644
--- a/arch/arm/mach-spear6xx/clock.c
+++ b/arch/arm/mach-spear6xx/clock.c
@@ -685,7 +685,7 @@ static struct clk dummy_apb_pclk;
 
 /* array of all spear 6xx clock lookups */
 static struct clk_lookup spear_clk_lookups[] = {
-	{ .con_id = "apb_pclk",	.clk = &dummy_apb_pclk},
+	{ .con_id = "apb_pclk",		.clk = &dummy_apb_pclk},
 	/* root clks */
 	{ .con_id = "osc_32k_clk",	.clk = &osc_32k_clk},
 	{ .con_id = "osc_30m_clk",	.clk = &osc_30m_clk},
@@ -714,9 +714,9 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{ .dev_id = "gpt2",		.clk = &gpt2_clk},
 	{ .dev_id = "gpt3",		.clk = &gpt3_clk},
 	/* clock derived from pll3 clk */
+	{ .dev_id = "designware_udc",	.clk = &usbd_clk},
 	{ .con_id = "usbh.0_clk",	.clk = &usbh0_clk},
 	{ .con_id = "usbh.1_clk",	.clk = &usbh1_clk},
-	{ .dev_id = "usbd",		.clk = &usbd_clk},
 	/* clock derived from ahb clk */
 	{ .con_id = "ahbmult2_clk",	.clk = &ahbmult2_clk},
 	{ .con_id = "ddr_clk",		.clk = &ddr_clk},
-- 
1.7.2.2

