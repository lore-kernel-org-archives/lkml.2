Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab1CXXfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:35:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab1CXXeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:34:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6295"; a="81727466"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 2/2] msm: 8960: Add dummy clocks for 8960
Date: Thu, 24 Mar 2011 16:34:46 -0700
Message-Id: <1301009686-4042-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.415.g5e839
In-Reply-To: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
References: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current 8960 devices have all clocks enabled by default. Add
dummy clk_lookup mappings for devices so that driver authors
can link up their devices to clocks.

Change-Id: I1260b667baa786551289c7c2fda3ddd8ee229a07
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c   |    7 ++
 arch/arm/mach-msm/devices-msm8960.c |  160 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/devices.h         |    3 +
 3 files changed, 170 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 1993721..4b27dd7 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -35,6 +35,11 @@ static void __init msm8960_map_io(void)
 	msm_map_msm8960_io();
 }
 
+static void __init msm8960_init_early(void)
+{
+	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+}
+
 static void __init msm8960_init_irq(void)
 {
 	unsigned int i;
@@ -77,6 +82,7 @@ static void __init msm8960_rumi3_init(void)
 
 MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 	.map_io = msm8960_map_io,
+	.init_early = msm8960_init_early,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
 	.init_machine = msm8960_sim_init,
@@ -84,6 +90,7 @@ MACHINE_END
 
 MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
 	.map_io = msm8960_map_io,
+	.init_early = msm8960_init_early,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
 	.init_machine = msm8960_rumi3_init,
diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
index d9e1f26..f9ef5ca 100644
--- a/arch/arm/mach-msm/devices-msm8960.c
+++ b/arch/arm/mach-msm/devices-msm8960.c
@@ -23,6 +23,7 @@
 #include <mach/board.h>
 
 #include "devices.h"
+#include "clock.h"
 
 #define MSM_GSBI2_PHYS		0x16100000
 #define MSM_UART2DM_PHYS	(MSM_GSBI2_PHYS + 0x40000)
@@ -83,3 +84,162 @@ struct platform_device msm8960_device_uart_gsbi5 = {
 	.num_resources	= ARRAY_SIZE(resources_uart_gsbi5),
 	.resource	= resources_uart_gsbi5,
 };
+
+struct clk_lookup msm_clocks_8960[] = {
+	CLK_DUMMY("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI2_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI3_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI4_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI5_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI6_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI7_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI8_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI9_UART_CLK,		NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI10_UART_CLK,	NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI11_UART_CLK,	NULL),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI12_UART_CLK,	NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI1_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI2_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI3_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI4_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI5_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI6_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI7_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI8_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI9_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI10_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI11_QUP_CLK,		NULL),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI12_QUP_CLK,		NULL),
+	CLK_DUMMY("pdm_clk",		PDM_CLK,		NULL),
+	CLK_DUMMY("pmem_clk",		PMEM_CLK,		NULL),
+	CLK_DUMMY("prng_clk",		PRNG_CLK,		NULL),
+	CLK_DUMMY("sdc_clk",		SDC1_CLK,		NULL),
+	CLK_DUMMY("sdc_clk",		SDC2_CLK,		NULL),
+	CLK_DUMMY("sdc_clk",		SDC3_CLK,		NULL),
+	CLK_DUMMY("sdc_clk",		SDC4_CLK,		NULL),
+	CLK_DUMMY("sdc_clk",		SDC5_CLK,		NULL),
+	CLK_DUMMY("tsif_ref_clk",	TSIF_REF_CLK,		NULL),
+	CLK_DUMMY("tssc_clk",		TSSC_CLK,		NULL),
+	CLK_DUMMY("usb_hs_clk",		USB_HS1_XCVR_CLK,	NULL),
+	CLK_DUMMY("usb_phy_clk",	USB_PHY0_CLK,		NULL),
+	CLK_DUMMY("usb_fs_src_clk",	USB_FS1_SRC_CLK,	NULL),
+	CLK_DUMMY("usb_fs_clk",		USB_FS1_XCVR_CLK,	NULL),
+	CLK_DUMMY("usb_fs_sys_clk",	USB_FS1_SYS_CLK,	NULL),
+	CLK_DUMMY("usb_fs_src_clk",	USB_FS2_SRC_CLK,	NULL),
+	CLK_DUMMY("usb_fs_clk",		USB_FS2_XCVR_CLK,	NULL),
+	CLK_DUMMY("usb_fs_sys_clk",	USB_FS2_SYS_CLK,	NULL),
+	CLK_DUMMY("ce_clk",		CE2_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI1_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI2_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI3_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI4_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI5_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI6_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI7_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI8_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI9_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI10_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI11_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI12_P_CLK,		NULL),
+	CLK_DUMMY("gsbi_pclk",		GSBI12_P_CLK,		NULL),
+	CLK_DUMMY("ppss_pclk",		PPSS_P_CLK,		NULL),
+	CLK_DUMMY("tsif_pclk",		TSIF_P_CLK,		NULL),
+	CLK_DUMMY("usb_fs_pclk",	USB_FS1_P_CLK,		NULL),
+	CLK_DUMMY("usb_fs_pclk",	USB_FS2_P_CLK,		NULL),
+	CLK_DUMMY("usb_hs_pclk",	USB_HS1_P_CLK,		NULL),
+	CLK_DUMMY("sdc_pclk",		SDC1_P_CLK,		NULL),
+	CLK_DUMMY("sdc_pclk",		SDC2_P_CLK,		NULL),
+	CLK_DUMMY("sdc_pclk",		SDC3_P_CLK,		NULL),
+	CLK_DUMMY("sdc_pclk",		SDC4_P_CLK,		NULL),
+	CLK_DUMMY("sdc_pclk",		SDC5_P_CLK,		NULL),
+	CLK_DUMMY("adm_clk",		ADM0_CLK,		NULL),
+	CLK_DUMMY("adm_pclk",		ADM0_P_CLK,		NULL),
+	CLK_DUMMY("pmic_arb_pclk",	PMIC_ARB0_P_CLK,	NULL),
+	CLK_DUMMY("pmic_arb_pclk",	PMIC_ARB1_P_CLK,	NULL),
+	CLK_DUMMY("pmic_ssbi2",		PMIC_SSBI2_CLK,		NULL),
+	CLK_DUMMY("rpm_msg_ram_pclk",	RPM_MSG_RAM_P_CLK,	NULL),
+	CLK_DUMMY("amp_clk",		AMP_CLK,		NULL),
+	CLK_DUMMY("cam_clk",		CAM0_CLK,		NULL),
+	CLK_DUMMY("cam_clk",		CAM1_CLK,		NULL),
+	CLK_DUMMY("csi_src_clk",	CSI0_SRC_CLK,		NULL),
+	CLK_DUMMY("csi_src_clk",	CSI1_SRC_CLK,		NULL),
+	CLK_DUMMY("csi_clk",		CSI0_CLK,		NULL),
+	CLK_DUMMY("csi_clk",		CSI1_CLK,		NULL),
+	CLK_DUMMY("csi_pix_clk",	CSI_PIX_CLK,		NULL),
+	CLK_DUMMY("csi_rdi_clk",	CSI_RDI_CLK,		NULL),
+	CLK_DUMMY("csiphy_timer_src_clk", CSIPHY_TIMER_SRC_CLK,	NULL),
+	CLK_DUMMY("csi0phy_timer_clk",	CSIPHY0_TIMER_CLK,	NULL),
+	CLK_DUMMY("csi1phy_timer_clk",	CSIPHY1_TIMER_CLK,	NULL),
+	CLK_DUMMY("dsi_byte_div_clk",	DSI1_BYTE_CLK,		NULL),
+	CLK_DUMMY("dsi_byte_div_clk",	DSI2_BYTE_CLK,		NULL),
+	CLK_DUMMY("dsi_esc_clk",	DSI1_ESC_CLK,		NULL),
+	CLK_DUMMY("dsi_esc_clk",	DSI2_ESC_CLK,		NULL),
+	CLK_DUMMY("gfx2d0_clk",		GFX2D0_CLK,		NULL),
+	CLK_DUMMY("gfx2d1_clk",		GFX2D1_CLK,		NULL),
+	CLK_DUMMY("gfx3d_clk",		GFX3D_CLK,		NULL),
+	CLK_DUMMY("ijpeg_axi_clk",	IJPEG_AXI_CLK,		NULL),
+	CLK_DUMMY("imem_axi_clk",	IMEM_AXI_CLK,		NULL),
+	CLK_DUMMY("jpegd_clk",		JPEGD_CLK,		NULL),
+	CLK_DUMMY("mdp_clk",		MDP_CLK,		NULL),
+	CLK_DUMMY("mdp_vsync_clk",	MDP_VSYNC_CLK,		NULL),
+	CLK_DUMMY("lut_mdp",		LUT_MDP_CLK,		NULL),
+	CLK_DUMMY("rot_clk",		ROT_CLK,		NULL),
+	CLK_DUMMY("tv_src_clk",		TV_SRC_CLK,		NULL),
+	CLK_DUMMY("tv_enc_clk",		TV_ENC_CLK,		NULL),
+	CLK_DUMMY("tv_dac_clk",		TV_DAC_CLK,		NULL),
+	CLK_DUMMY("vcodec_clk",		VCODEC_CLK,		NULL),
+	CLK_DUMMY("mdp_tv_clk",		MDP_TV_CLK,		NULL),
+	CLK_DUMMY("hdmi_clk",		HDMI_TV_CLK,		NULL),
+	CLK_DUMMY("hdmi_app_clk",	HDMI_APP_CLK,		NULL),
+	CLK_DUMMY("vpe_clk",		VPE_CLK,		NULL),
+	CLK_DUMMY("vfe_clk",		VFE_CLK,		NULL),
+	CLK_DUMMY("csi_vfe_clk",	CSI0_VFE_CLK,		NULL),
+	CLK_DUMMY("vfe_axi_clk",	VFE_AXI_CLK,		NULL),
+	CLK_DUMMY("ijpeg_axi_clk",	IJPEG_AXI_CLK,		NULL),
+	CLK_DUMMY("mdp_axi_clk",	MDP_AXI_CLK,		NULL),
+	CLK_DUMMY("rot_axi_clk",	ROT_AXI_CLK,		NULL),
+	CLK_DUMMY("vcodec_axi_clk",	VCODEC_AXI_CLK,		NULL),
+	CLK_DUMMY("vcodec_axi_a_clk",	VCODEC_AXI_A_CLK,	NULL),
+	CLK_DUMMY("vcodec_axi_b_clk",	VCODEC_AXI_B_CLK,	NULL),
+	CLK_DUMMY("vpe_axi_clk",	VPE_AXI_CLK,		NULL),
+	CLK_DUMMY("amp_pclk",		AMP_P_CLK,		NULL),
+	CLK_DUMMY("csi_pclk",		CSI0_P_CLK,		NULL),
+	CLK_DUMMY("dsi_m_pclk",		DSI1_M_P_CLK,		NULL),
+	CLK_DUMMY("dsi_s_pclk",		DSI1_S_P_CLK,		NULL),
+	CLK_DUMMY("dsi_m_pclk",		DSI2_M_P_CLK,		NULL),
+	CLK_DUMMY("dsi_s_pclk",		DSI2_S_P_CLK,		NULL),
+	CLK_DUMMY("gfx2d0_pclk",	GFX2D0_P_CLK,		NULL),
+	CLK_DUMMY("gfx2d1_pclk",	GFX2D1_P_CLK,		NULL),
+	CLK_DUMMY("gfx3d_pclk",		GFX3D_P_CLK,		NULL),
+	CLK_DUMMY("hdmi_m_pclk",	HDMI_M_P_CLK,		NULL),
+	CLK_DUMMY("hdmi_s_pclk",	HDMI_S_P_CLK,		NULL),
+	CLK_DUMMY("ijpeg_pclk",		IJPEG_P_CLK,		NULL),
+	CLK_DUMMY("jpegd_pclk",		JPEGD_P_CLK,		NULL),
+	CLK_DUMMY("imem_pclk",		IMEM_P_CLK,		NULL),
+	CLK_DUMMY("mdp_pclk",		MDP_P_CLK,		NULL),
+	CLK_DUMMY("smmu_pclk",		SMMU_P_CLK,		NULL),
+	CLK_DUMMY("rotator_pclk",	ROT_P_CLK,		NULL),
+	CLK_DUMMY("tv_enc_pclk",	TV_ENC_P_CLK,		NULL),
+	CLK_DUMMY("vcodec_pclk",	VCODEC_P_CLK,		NULL),
+	CLK_DUMMY("vfe_pclk",		VFE_P_CLK,		NULL),
+	CLK_DUMMY("vpe_pclk",		VPE_P_CLK,		NULL),
+	CLK_DUMMY("mi2s_osr_clk",	MI2S_OSR_CLK,		NULL),
+	CLK_DUMMY("mi2s_bit_clk",	MI2S_BIT_CLK,		NULL),
+	CLK_DUMMY("i2s_mic_osr_clk",	CODEC_I2S_MIC_OSR_CLK,	NULL),
+	CLK_DUMMY("i2s_mic_bit_clk",	CODEC_I2S_MIC_BIT_CLK,	NULL),
+	CLK_DUMMY("i2s_mic_osr_clk",	SPARE_I2S_MIC_OSR_CLK,	NULL),
+	CLK_DUMMY("i2s_mic_bit_clk",	SPARE_I2S_MIC_BIT_CLK,	NULL),
+	CLK_DUMMY("i2s_spkr_osr_clk",	CODEC_I2S_SPKR_OSR_CLK,	NULL),
+	CLK_DUMMY("i2s_spkr_bit_clk",	CODEC_I2S_SPKR_BIT_CLK,	NULL),
+	CLK_DUMMY("i2s_spkr_osr_clk",	SPARE_I2S_SPKR_OSR_CLK,	NULL),
+	CLK_DUMMY("i2s_spkr_bit_clk",	SPARE_I2S_SPKR_BIT_CLK,	NULL),
+	CLK_DUMMY("pcm_clk",		PCM_CLK,		NULL),
+	CLK_DUMMY("iommu_clk",		JPEGD_AXI_CLK,		NULL),
+	CLK_DUMMY("iommu_clk",		VFE_AXI_CLK,		NULL),
+	CLK_DUMMY("iommu_clk",		VCODEC_AXI_CLK,	NULL),
+	CLK_DUMMY("iommu_clk",		GFX3D_CLK,	NULL),
+	CLK_DUMMY("iommu_clk",		GFX2D0_CLK,	NULL),
+	CLK_DUMMY("iommu_clk",		GFX2D1_CLK,	NULL),
+};
+
+unsigned msm_num_clocks_8960 = ARRAY_SIZE(msm_clocks_8960);
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 9545c19..e7a0cb0 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -55,4 +55,7 @@ extern unsigned msm_num_clocks_7x30;
 extern struct clk_lookup msm_clocks_8x50[];
 extern unsigned msm_num_clocks_8x50;
 
+extern struct clk_lookup msm_clocks_8960[];
+extern unsigned msm_num_clocks_8960;
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

