Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1A0AVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:21:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62489 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1A0AU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:20:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71900284"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCHv2 5/5] msm: clock: Add support for more proc_comm clocks
Date: Wed, 26 Jan 2011 16:20:56 -0800
Message-Id: <1296087656-3693-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
References: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ce, codec_ssbi, uart clocks, and i2c clocks.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.h      |    4 +++-
 arch/arm/mach-msm/devices-msm7x30.c |    2 ++
 arch/arm/mach-msm/devices-qsd8x50.c |    6 ++++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 17d027b..2c813f1 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -132,8 +132,10 @@
 #define P_CSI1_P_CLK		97
 #define P_GSBI_CLK		98
 #define P_GSBI_P_CLK		99
+#define P_CE_CLK		100 /* Crypto engine */
+#define P_CODEC_SSBI_CLK	101
 
-#define P_NR_CLKS		100
+#define P_NR_CLKS		102
 
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index e430fdd..cd4343b 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -134,6 +134,8 @@ struct clk msm_clocks_7x30[] = {
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
 	CLK_PCOM("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
+	CLK_PCOM("ce_clk",	CE_CLK,	NULL, 0),
+	CLK_PCOM("codec_ssbi_clk",	CODEC_SSBI_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
 	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
 	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index c5dad8f..bd545f9 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -316,12 +316,14 @@ int __init msm_add_sdcc(unsigned int controller,
 
 struct clk msm_clocks_8x50[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
+	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
 	CLK_PCOM("ebi2_clk",	EBI2_CLK,	NULL, 0),
 	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
 	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
 	CLK_PCOM("gp_clk",	GP_CLK,		NULL, 0),
 	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, 0),
+	CLK_PCOM("i2c_clk",	I2C_CLK,	NULL, 0),
 	CLK_PCOM("icodec_rx_clk",	ICODEC_RX_CLK,	NULL, 0),
 	CLK_PCOM("icodec_tx_clk",	ICODEC_TX_CLK,	NULL, 0),
 	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
@@ -347,7 +349,11 @@ struct clk msm_clocks_8x50[] = {
 	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
+	CLK_PCOM("uart_clk",	UART1_CLK,	NULL, OFF),
+	CLK_PCOM("uart_clk",	UART2_CLK,	NULL, 0),
 	CLK_PCOM("uart_clk",	UART3_CLK,	&msm_device_uart3.dev, OFF),
+	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
+	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
 	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	NULL, OFF),
 	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

