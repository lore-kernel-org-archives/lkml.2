Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0LQAyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:54:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0LQAuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160021"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 06/22] msm: clock-7x30: Update clock table
Date: Thu, 16 Dec 2010 16:49:50 -0800
Message-Id: <1292547006-19741-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark clocks with CLK_7X30 to indicate they have the potential to
be locally controllable. If it's determined at runtime that these
clocks are not locally owned, revert the clocks to proc_comm
control. Mark clocks with CLK_PCOM when we know that they can't
be locally controlled.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm7x30.c |  147 ++++++++++++++++++++---------------
 1 files changed, 85 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 2816be3..55382c4 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -58,78 +58,101 @@ struct platform_device msm_device_smd = {
 };
 
 struct clk msm_clocks_7x30[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
 	CLK_PCOM("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
-	CLK_PCOM("ce_clk",	CE_CLK,	NULL, 0),
 	CLK_PCOM("codec_ssbi_clk",	CODEC_SSBI_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
 	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
-	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("emdh_pclk",	EMDH_P_CLK,	NULL, OFF),
 	CLK_PCOM("gp_clk",	GP_CLK,		NULL, 0),
-	CLK_PCOM("grp_2d_clk",	GRP_2D_CLK,	NULL, 0),
-	CLK_PCOM("grp_2d_pclk",	GRP_2D_P_CLK,	NULL, 0),
-	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, 0),
-	CLK_PCOM("grp_pclk",	GRP_3D_P_CLK,	NULL, 0),
-	CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,	NULL, 0),
-	CLK_PCOM("hdmi_clk",	HDMI_CLK,	NULL, 0),
-	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("jpeg_clk",	JPEG_CLK,	NULL, OFF),
-	CLK_PCOM("jpeg_pclk",	JPEG_P_CLK,	NULL, OFF),
-	CLK_PCOM("lpa_codec_clk",	LPA_CODEC_CLK,		NULL, 0),
-	CLK_PCOM("lpa_core_clk",	LPA_CORE_CLK,		NULL, 0),
-	CLK_PCOM("lpa_pclk",		LPA_P_CLK,		NULL, 0),
-	CLK_PCOM("mdc_clk",	MDC_CLK,	NULL, 0),
-	CLK_PCOM("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("mddi_pclk",	PMDH_P_CLK,	NULL, 0),
-	CLK_PCOM("mdp_clk",	MDP_CLK,	NULL, OFF),
-	CLK_PCOM("mdp_pclk",	MDP_P_CLK,	NULL, 0),
-	CLK_PCOM("mdp_lcdc_pclk_clk", MDP_LCDC_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_lcdc_pad_pclk_clk", MDP_LCDC_PAD_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_vsync_clk",	MDP_VSYNC_CLK,  NULL, 0),
-	CLK_PCOM("mfc_clk",		MFC_CLK,		NULL, 0),
-	CLK_PCOM("mfc_div2_clk",	MFC_DIV2_CLK,		NULL, 0),
-	CLK_PCOM("mfc_pclk",		MFC_P_CLK,		NULL, 0),
-	CLK_PCOM("mi2s_m_clk",		MI2S_M_CLK,  		NULL, 0),
-	CLK_PCOM("mi2s_s_clk",		MI2S_S_CLK,  		NULL, 0),
-	CLK_PCOM("mi2s_codec_rx_m_clk",	MI2S_CODEC_RX_M_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_rx_s_clk",	MI2S_CODEC_RX_S_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_tx_m_clk",	MI2S_CODEC_TX_M_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_tx_s_clk",	MI2S_CODEC_TX_S_CLK,  NULL, 0),
-	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
-	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
-	CLK_PCOM("rotator_clk",	AXI_ROTATOR_CLK,		NULL, 0),
-	CLK_PCOM("rotator_imem_clk",	ROTATOR_IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("rotator_pclk",	ROTATOR_P_CLK,		NULL, OFF),
-	CLK_PCOM("sdac_clk",	SDAC_CLK,	NULL, OFF),
-	CLK_PCOM("spi_clk",	SPI_CLK,	NULL, 0),
-	CLK_PCOM("spi_pclk",	SPI_P_CLK,	NULL, 0),
-	CLK_7X30S("tv_src_clk",	TV_CLK, 	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
-	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART2_CLK,	&msm_device_uart2.dev, 0),
-	CLK_PCOM("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_core_clk",	USB_HS_CORE_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs2_clk",		USB_HS2_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs2_pclk",	USB_HS2_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs2_core_clk",	USB_HS2_CORE_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs3_clk",		USB_HS3_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs3_pclk",	USB_HS3_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs3_core_clk",	USB_HS3_CORE_CLK,	NULL, OFF),
+	CLK_PCOM("uart_clk",	UART3_CLK,	NULL, OFF),
+	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
-	CLK_PCOM("vfe_camif_clk",	VFE_CAMIF_CLK, 	NULL, 0),
-	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, 0),
-	CLK_PCOM("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, 0),
-	CLK_PCOM("vfe_pclk",	VFE_P_CLK,	NULL, OFF),
-	CLK_PCOM("vpe_clk",	VPE_CLK,	NULL, 0),
+	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
+
+	CLK_7X30("adm_clk",	ADM_CLK,	NULL, 0),
+	CLK_7X30L("adm_pclk",   ADM_P_CLK,       NULL, 0),
+	CLK_7X30("cam_m_clk",	CAM_M_CLK,	NULL, 0),
+	CLK_7X30("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
+	CLK_7X30("ce_clk",	CE_CLK,		NULL, 0),
+	CLK_7X30("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
+	CLK_7X30("emdh_pclk",	EMDH_P_CLK,	NULL, OFF),
+	CLK_7X30("grp_2d_clk",	GRP_2D_CLK,	NULL, 0),
+	CLK_7X30("grp_2d_pclk",	GRP_2D_P_CLK,	NULL, 0),
+	CLK_7X30("grp_clk",	GRP_3D_CLK,	NULL, 0),
+	CLK_7X30("grp_pclk",	GRP_3D_P_CLK,	NULL, 0),
+	CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,	NULL, 0),
+	CLK_7X30("hdmi_clk",	HDMI_CLK,	NULL, 0),
+	CLK_7X30("i2c_clk",	I2C_CLK,	NULL, 0),
+	CLK_7X30("i2c_clk",	I2C_2_CLK,	NULL, 0),
+	CLK_7X30("imem_clk",	IMEM_CLK,	NULL, OFF),
+	CLK_7X30("jpeg_clk",	JPEG_CLK,	NULL, OFF),
+	CLK_7X30("jpeg_pclk",	JPEG_P_CLK,	NULL, OFF),
+	CLK_7X30("lpa_codec_clk",	LPA_CODEC_CLK,		NULL, 0),
+	CLK_7X30("lpa_core_clk",	LPA_CORE_CLK,		NULL, 0),
+	CLK_7X30("lpa_pclk",		LPA_P_CLK,		NULL, 0),
+	CLK_7X30("mdc_clk",	MDC_CLK,	NULL, 0),
+	CLK_7X30("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
+	CLK_7X30("mddi_pclk",	PMDH_P_CLK,	NULL, 0),
+	CLK_7X30("mdp_clk",	MDP_CLK,	NULL, OFF),
+	CLK_7X30("mdp_pclk",	MDP_P_CLK,	NULL, 0),
+	CLK_7X30("mdp_lcdc_pclk_clk", MDP_LCDC_PCLK_CLK, NULL, 0),
+	CLK_7X30("mdp_lcdc_pad_pclk_clk", MDP_LCDC_PAD_PCLK_CLK, NULL, 0),
+	CLK_7X30("mdp_vsync_clk",	MDP_VSYNC_CLK,  NULL, OFF),
+	CLK_7X30("mfc_clk",		MFC_CLK,		NULL, 0),
+	CLK_7X30("mfc_div2_clk",	MFC_DIV2_CLK,		NULL, 0),
+	CLK_7X30("mfc_pclk",		MFC_P_CLK,		NULL, 0),
+	CLK_7X30("mi2s_codec_rx_m_clk",	MI2S_CODEC_RX_M_CLK,  NULL, 0),
+	CLK_7X30("mi2s_codec_rx_s_clk",	MI2S_CODEC_RX_S_CLK,  NULL, 0),
+	CLK_7X30("mi2s_codec_tx_m_clk",	MI2S_CODEC_TX_M_CLK,  NULL, 0),
+	CLK_7X30("mi2s_codec_tx_s_clk",	MI2S_CODEC_TX_S_CLK,  NULL, 0),
+	CLK_7X30("mi2s_m_clk",		MI2S_M_CLK,		NULL, 0),
+	CLK_7X30("mi2s_s_clk",		MI2S_S_CLK,		NULL, 0),
+	CLK_7X30("qup_clk",	QUP_I2C_CLK,	NULL, 0),
+	CLK_7X30("rotator_clk",	AXI_ROTATOR_CLK,		NULL, 0),
+	CLK_7X30("rotator_imem_clk",	ROTATOR_IMEM_CLK,	NULL, OFF),
+	CLK_7X30("rotator_pclk",	ROTATOR_P_CLK,		NULL, OFF),
+	CLK_7X30("sdac_clk",	SDAC_CLK,	NULL, OFF),
+	CLK_7X30("sdc_clk",	SDC1_CLK,	NULL, OFF),
+	CLK_7X30("sdc_pclk",	SDC1_P_CLK,	NULL, OFF),
+	CLK_7X30("sdc_clk",	SDC2_CLK,	NULL, OFF),
+	CLK_7X30("sdc_pclk",	SDC2_P_CLK,	NULL, OFF),
+	CLK_7X30("sdc_clk",	SDC3_CLK,	NULL, OFF),
+	CLK_7X30("sdc_pclk",	SDC3_P_CLK,	NULL, OFF),
+	CLK_7X30("sdc_clk",	SDC4_CLK,	NULL, OFF),
+	CLK_7X30("sdc_pclk",	SDC4_P_CLK,	NULL, OFF),
+	CLK_7X30("spi_clk",	SPI_CLK,	NULL, 0),
+	CLK_7X30("spi_pclk",	SPI_P_CLK,	NULL, 0),
+	CLK_7X30("tsif_ref_clk", TSIF_REF_CLK,	NULL, 0),
+	CLK_7X30("tsif_pclk",	TSIF_P_CLK,	NULL, 0),
+	CLK_7X30("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
+	CLK_7X30("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
+	CLK_7X30S("tv_src_clk",	TV_CLK,		TV_ENC_CLK,	NULL, 0),
+	CLK_7X30("uart_clk",	UART1_CLK,	NULL, OFF),
+	CLK_7X30("uart_clk",	UART2_CLK,	&msm_device_uart2.dev, 0),
+	CLK_7X30("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
+	CLK_7X30L("uartdm_pclk", UART1DM_P_CLK,	NULL, 0),
+	CLK_7X30("uartdm_clk",	UART2DM_CLK,	NULL, 0),
+	CLK_7X30L("uartdm_pclk", UART2DM_P_CLK,	NULL, 0),
+	CLK_7X30("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs_core_clk",	USB_HS_CORE_CLK,	NULL, OFF),
+	CLK_7X30("usb_hs2_clk",		USB_HS2_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs2_pclk",	USB_HS2_P_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs2_core_clk",	USB_HS2_CORE_CLK,	NULL, OFF),
+	CLK_7X30("usb_hs3_clk",		USB_HS3_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs3_pclk",	USB_HS3_P_CLK,		NULL, OFF),
+	CLK_7X30("usb_hs3_core_clk",	USB_HS3_CORE_CLK,	NULL, OFF),
+	CLK_7X30("vfe_camif_clk",	VFE_CAMIF_CLK, NULL, 0),
+	CLK_7X30("vfe_clk",	VFE_CLK,	NULL, 0),
+	CLK_7X30("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, 0),
+	CLK_7X30("vfe_pclk",	VFE_P_CLK,	NULL, OFF),
+	CLK_7X30("vpe_clk",	VPE_CLK,	NULL, 0),
 
 	/* 7x30 v2 hardware only. */
-	CLK_PCOM("csi_clk",	CSI0_CLK,	NULL, 0),
-	CLK_PCOM("csi_pclk",	CSI0_P_CLK,	NULL, 0),
-	CLK_PCOM("csi_vfe_clk",	CSI0_VFE_CLK,	NULL, 0),
+	CLK_7X30("csi_clk",	CSI0_CLK,	NULL, 0),
+	CLK_7X30("csi_pclk",	CSI0_P_CLK,	NULL, 0),
+	CLK_7X30("csi_vfe_clk",	CSI0_VFE_CLK,	NULL, 0),
 };
 
 unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

