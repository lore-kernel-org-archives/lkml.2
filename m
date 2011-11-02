Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1KBSiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:38:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553Ab1KBShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707012"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 29/34] msm: clock: Expand CLK_MIN, CLK_MAX and CLK_MINMAX macros
Date: Wed,  2 Nov 2011 11:36:26 -0700
Message-Id: <1320258991-22325-30-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

These were just defined to be the same as CLKFLAG_MIN,
CLKFLAG_MAX and (CLKFLAG_MIN | CLKFLAG_MAX). Expand them
to avoid the unnecessary level of redirection.

Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c        |    4 ++--
 arch/arm/mach-msm/clock-debug.c       |    6 +++---
 arch/arm/mach-msm/clock-pcom-lookup.c |   10 +++++-----
 arch/arm/mach-msm/clock.h             |    7 ++-----
 arch/arm/mach-msm/devices-msm7x00.c   |    2 +-
 arch/arm/mach-msm/devices-qsd8x50.c   |   12 +++++++-----
 6 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index ce0e73c..d917942 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -2265,11 +2265,11 @@ static struct branch_clk lpa_core_clk = {
 
 static DEFINE_CLK_PCOM(adsp_clk, ADSP_CLK, CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(codec_ssbi_clk,	CODEC_SSBI_CLK, CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(ebi1_clk, EBI1_CLK, CLK_MIN);
+static DEFINE_CLK_PCOM(ebi1_clk, EBI1_CLK, CLKFLAG_SKIP_AUTO_OFF | CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(ecodec_clk, ECODEC_CLK, CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(gp_clk, GP_CLK, CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(uart3_clk, UART3_CLK, 0);
-static DEFINE_CLK_PCOM(usb_phy_clk, USB_PHY_CLK, CLK_MIN);
+static DEFINE_CLK_PCOM(usb_phy_clk, USB_PHY_CLK, CLKFLAG_MIN);
 
 static DEFINE_CLK_PCOM(p_grp_2d_clk, GRP_2D_CLK, CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(p_grp_2d_p_clk, GRP_2D_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 1a08a9a..d5d4091 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -28,15 +28,15 @@ static int clock_debug_rate_set(void *data, u64 val)
 
 	/* Only increases to max rate will succeed, but that's actually good
 	 * for debugging purposes so we don't check for error. */
-	if (clock->flags & CLK_MAX)
+	if (clock->flags & CLKFLAG_MAX)
 		clk_set_max_rate(clock, val);
-	if (clock->flags & CLK_MIN)
+	if (clock->flags & CLKFLAG_MIN)
 		ret = clk_set_min_rate(clock, val);
 	else
 		ret = clk_set_rate(clock, val);
 	if (ret != 0)
 		printk(KERN_ERR "clk_set%s_rate failed (%d)\n",
-			(clock->flags & CLK_MIN) ? "_min" : "", ret);
+			(clock->flags & CLKFLAG_MIN) ? "_min" : "", ret);
 	return ret;
 }
 
diff --git a/arch/arm/mach-msm/clock-pcom-lookup.c b/arch/arm/mach-msm/clock-pcom-lookup.c
index 22f8145..9d83cba 100644
--- a/arch/arm/mach-msm/clock-pcom-lookup.c
+++ b/arch/arm/mach-msm/clock-pcom-lookup.c
@@ -66,10 +66,10 @@ static struct pcom_clk dsi_pixel_clk = {
 
 static DEFINE_CLK_PCOM(dsi_ref_clk,	DSI_REF_CLK,	0);
 static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,
-		CLKFLAG_SKIP_AUTO_OFF | CLK_MIN);
+		CLKFLAG_SKIP_AUTO_OFF | CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,   CLKFLAG_MIN | CLKFLAG_MAX);
 static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(grp_2d_clk,	GRP_2D_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(grp_2d_p_clk,	GRP_2D_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
@@ -95,9 +95,9 @@ static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk, MDP_LCDC_PCLK_CLK,
 static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	0);
 static DEFINE_CLK_PCOM(mdp_dsi_p_clk,	MDP_DSI_P_CLK,	0);
 static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,
-		CLKFLAG_SKIP_AUTO_OFF | CLK_MIN);
+		CLKFLAG_SKIP_AUTO_OFF | CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,   CLKFLAG_MIN | CLKFLAG_MAX);
 static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
 static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
 static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	0);
@@ -127,7 +127,7 @@ static DEFINE_CLK_PCOM(usb_hs_core_clk,	USB_HS_CORE_CLK, 0);
 static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	0);
 static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	0);
 static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	0);
 static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	0);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 09afadd..a873a19 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -68,11 +68,8 @@ struct clk {
 	.children = LIST_HEAD_INIT((name).children), \
 	.siblings = LIST_HEAD_INIT((name).siblings)
 
-#define CLK_MIN CLKFLAG_MIN
-#define CLK_MAX CLKFLAG_MAX
-#define CLK_MINMAX (CLK_MIN | CLK_MAX)
-
-#if defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)
+#if defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || \
+defined(CONFIG_ARCH_MSM8960)
 void __init msm_clk_soc_init(void);
 #else
 static inline void __init msm_clk_soc_init(void) { }
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index a7764bd..b4658e2 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -410,7 +410,7 @@ static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	0);
 static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK, CLKFLAG_MIN | CLKFLAG_MAX);
 static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
 static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
 static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	0);
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index f4e65f0..ab15e69 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -294,10 +294,11 @@ int __init msm_add_sdcc(unsigned int controller,
 
 static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,		CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	CLKFLAG_MIN |
+							CLKFLAG_MAX);
 static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	CLKFLAG_SKIP_AUTO_OFF);
@@ -305,14 +306,15 @@ static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	0);
 static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLKFLAG_MIN |
+							CLKFLAG_MAX);
 static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	0);
 static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk,	MDP_LCDC_PCLK_CLK,
 		CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk,	MDP_LCDC_PAD_PCLK_CLK,
 		CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
 static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
@@ -336,7 +338,7 @@ static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	0);
 static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	0);
 static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	CLKFLAG_SKIP_AUTO_OFF);
-static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLKFLAG_MIN);
 static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	0);
 static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	0);
 static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	0);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

