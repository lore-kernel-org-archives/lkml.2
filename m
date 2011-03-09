Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1CIAQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:16:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5816 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab1CIAQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:16:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6279"; a="78609740"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH FYI] msm: Dummy 8960 clock driver
Date: Tue,  8 Mar 2011 16:16:04 -0800
Message-Id: <1299629764-25579-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.2.3
To: linux-arm-msm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock driver for 8960 is still under development.  Current
hardware has all clocks enabled by default.  To allow other driver
development to continue, we have been using this dummy clock driver as
a placeholder.

Since I've noticed a few RFC drivers sent out that mentioned this
dummy driver in context, I thought it best to send it out.

This is not intended to be merged, but is merely a placeholder for
other drivers to be able to make clock calls.  This patch will be
replaced with the real 8960 clock driver when that is ready.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Makefile          |    1 +
 arch/arm/mach-msm/board-msm8960.c   |    2 +
 arch/arm/mach-msm/clock-dummy.c     |   90 +++++++++++++++++++
 arch/arm/mach-msm/clock-dummy.h     |   26 ++++++
 arch/arm/mach-msm/devices-msm8960.c |  168 ++++++++++++++++++++++++++++++++++-
 arch/arm/mach-msm/devices.h         |    3 +
 6 files changed, 289 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-dummy.c
 create mode 100644 arch/arm/mach-msm/clock-dummy.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..86acfa3 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
+obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 1993721..052cb35 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -67,11 +67,13 @@ static struct platform_device *rumi3_devices[] __initdata = {
 
 static void __init msm8960_sim_init(void)
 {
+	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
 	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
 }
 
 static void __init msm8960_rumi3_init(void)
 {
+	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
 	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
 }
 
diff --git a/arch/arm/mach-msm/clock-dummy.c b/arch/arm/mach-msm/clock-dummy.c
new file mode 100644
index 0000000..72208fa
--- /dev/null
+++ b/arch/arm/mach-msm/clock-dummy.c
@@ -0,0 +1,90 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+
+#include "clock.h"
+#include "clock-dummy.h"
+
+static int dummy_clk_enable(unsigned id)
+{
+	return 0;
+}
+
+static void dummy_clk_disable(unsigned id)
+{
+}
+
+static void dummy_clk_auto_off(unsigned id)
+{
+}
+
+static int dummy_clk_reset(unsigned id, enum clk_reset_action action)
+{
+	return 0;
+}
+
+static int dummy_clk_set_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_min_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_max_rate(unsigned id, unsigned rate)
+{
+	return 0;
+}
+
+static int dummy_clk_set_flags(unsigned id, unsigned flags)
+{
+	return 0;
+}
+
+static unsigned dummy_clk_get_rate(unsigned id)
+{
+	return 0;
+}
+
+static unsigned dummy_clk_is_enabled(unsigned id)
+{
+	return 0;
+}
+
+static long dummy_clk_round_rate(unsigned id, unsigned rate)
+{
+	return rate;
+}
+
+static bool dummy_clk_is_local(unsigned id)
+{
+	return true;
+}
+
+struct clk_ops clk_ops_dummy = {
+	.enable = dummy_clk_enable,
+	.disable = dummy_clk_disable,
+	.auto_off = dummy_clk_auto_off,
+	.reset = dummy_clk_reset,
+	.set_rate = dummy_clk_set_rate,
+	.set_min_rate = dummy_clk_set_min_rate,
+	.set_max_rate = dummy_clk_set_max_rate,
+	.set_flags = dummy_clk_set_flags,
+	.get_rate = dummy_clk_get_rate,
+	.is_enabled = dummy_clk_is_enabled,
+	.round_rate = dummy_clk_round_rate,
+	.is_local = dummy_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock-dummy.h b/arch/arm/mach-msm/clock-dummy.h
new file mode 100644
index 0000000..109495f
--- /dev/null
+++ b/arch/arm/mach-msm/clock-dummy.h
@@ -0,0 +1,26 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_CLOCK_DUMMY_H
+#define __ARCH_ARM_MACH_MSM_CLOCK_DUMMY_H
+
+extern struct clk_ops clk_ops_dummy;
+#define CLK_DUMMY(clk_name, clk_id, clk_dev, clk_flags) {	\
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.dbg_name = #clk_id, \
+		.flags = clk_flags, \
+		.ops = &clk_ops_dummy, \
+	}, \
+	}
+#endif
diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
index d9e1f26..894ff98 100644
--- a/arch/arm/mach-msm/devices-msm8960.c
+++ b/arch/arm/mach-msm/devices-msm8960.c
@@ -17,12 +17,17 @@
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-
+#include <linux/list.h>
 #include <linux/dma-mapping.h>
+
+#include <asm/clkdev.h>
+
 #include <mach/irqs-8960.h>
 #include <mach/board.h>
 
 #include "devices.h"
+#include "clock.h"
+#include "clock-dummy.h"
 
 #define MSM_GSBI2_PHYS		0x16100000
 #define MSM_UART2DM_PHYS	(MSM_GSBI2_PHYS + 0x40000)
@@ -83,3 +88,164 @@ struct platform_device msm8960_device_uart_gsbi5 = {
 	.num_resources	= ARRAY_SIZE(resources_uart_gsbi5),
 	.resource	= resources_uart_gsbi5,
 };
+
+struct clk_lookup msm_clocks_8960[] = {
+	CLK_DUMMY("ce_clk",		CE2_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI2_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI3_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI4_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI5_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("uartdm_clk",		GSBI6_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI7_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI8_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI9_UART_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI10_UART_CLK,	NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI11_UART_CLK,	NULL, OFF),
+	CLK_DUMMY("gsbi_uart_clk",	GSBI12_UART_CLK,	NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI1_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI2_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI3_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI4_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI5_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI6_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI7_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI8_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI9_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI10_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI11_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_qup_clk",	GSBI12_QUP_CLK,		NULL, OFF),
+	CLK_DUMMY("pdm_clk",		PDM_CLK,		NULL, OFF),
+	CLK_DUMMY("pmem_clk",		PMEM_CLK,		NULL, OFF),
+	CLK_DUMMY("prng_clk",		PRNG_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_clk",		SDC1_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_clk",		SDC2_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_clk",		SDC3_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_clk",		SDC4_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_clk",		SDC5_CLK,		NULL, OFF),
+	CLK_DUMMY("tsif_ref_clk",	TSIF_REF_CLK,		NULL, OFF),
+	CLK_DUMMY("tssc_clk",		TSSC_CLK,		NULL, OFF),
+	CLK_DUMMY("usb_hs_clk",		USB_HS1_XCVR_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_phy_clk",	USB_PHY0_CLK,		NULL, OFF),
+	CLK_DUMMY("usb_fs_src_clk",	USB_FS1_SRC_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_fs_clk",		USB_FS1_XCVR_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_fs_sys_clk",	USB_FS1_SYS_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_fs_src_clk",	USB_FS2_SRC_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_fs_clk",		USB_FS2_XCVR_CLK,	NULL, OFF),
+	CLK_DUMMY("usb_fs_sys_clk",	USB_FS2_SYS_CLK,	NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI1_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI2_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI3_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI4_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI5_P_CLK,		NULL, OFF),
+	CLK_DUMMY("uartdm_pclk",	GSBI6_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI7_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI8_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI9_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI10_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI11_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI12_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gsbi_pclk",		GSBI12_P_CLK,		NULL, OFF),
+	CLK_DUMMY("ppss_pclk",		PPSS_P_CLK,		NULL, OFF),
+	CLK_DUMMY("tsif_pclk",		TSIF_P_CLK,		NULL, OFF),
+	CLK_DUMMY("usb_fs_pclk",	USB_FS1_P_CLK,		NULL, OFF),
+	CLK_DUMMY("usb_fs_pclk",	USB_FS2_P_CLK,		NULL, OFF),
+	CLK_DUMMY("usb_hs_pclk",	USB_HS1_P_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_pclk",		SDC1_P_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_pclk",		SDC2_P_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_pclk",		SDC3_P_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_pclk",		SDC4_P_CLK,		NULL, OFF),
+	CLK_DUMMY("sdc_pclk",		SDC5_P_CLK,		NULL, OFF),
+	CLK_DUMMY("adm_clk",		ADM0_CLK,		NULL, OFF),
+	CLK_DUMMY("adm_pclk",		ADM0_P_CLK,		NULL, OFF),
+	CLK_DUMMY("pmic_arb_pclk",	PMIC_ARB0_P_CLK,	NULL, OFF),
+	CLK_DUMMY("pmic_arb_pclk",	PMIC_ARB1_P_CLK,	NULL, OFF),
+	CLK_DUMMY("pmic_ssbi2",		PMIC_SSBI2_CLK,		NULL, OFF),
+	CLK_DUMMY("rpm_msg_ram_pclk",	RPM_MSG_RAM_P_CLK,	NULL, OFF),
+	CLK_DUMMY("amp_clk",		AMP_CLK,		NULL, OFF),
+	CLK_DUMMY("cam_clk",		CAM0_CLK,		NULL, OFF),
+	CLK_DUMMY("cam_clk",		CAM1_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_src_clk",	CSI0_SRC_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_src_clk",	CSI1_SRC_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_clk",		CSI0_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_clk",		CSI1_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_pix_clk",	CSI_PIX_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_rdi_clk",	CSI_RDI_CLK,		NULL, OFF),
+	CLK_DUMMY("csiphy0_timer_clk",	CSIPHY0_TIMER_CLK,	NULL, OFF),
+	CLK_DUMMY("csiphy1_timer_clk",	CSIPHY1_TIMER_CLK,	NULL, OFF),
+	CLK_DUMMY("dsi_byte_div_clk",	DSI1_BYTE_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_byte_div_clk",	DSI2_BYTE_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_esc_clk",	DSI1_ESC_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_esc_clk",	DSI2_ESC_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx2d0_clk",		GFX2D0_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx2d1_clk",		GFX2D1_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx3d_clk",		GFX3D_CLK,		NULL, OFF),
+	CLK_DUMMY("ijpeg_clk",		IJPEG_CLK,		NULL, OFF),
+	CLK_DUMMY("imem_clk",		IMEM_CLK,		NULL, OFF),
+	CLK_DUMMY("jpegd_clk",		JPEGD_CLK,		NULL, OFF),
+	CLK_DUMMY("mdp_clk",		MDP_CLK,		NULL, OFF),
+	CLK_DUMMY("mdp_vsync_clk",	MDP_VSYNC_CLK,		NULL, OFF),
+	CLK_DUMMY("lut_mdp",		LUT_MDP_CLK,		NULL, OFF),
+	CLK_DUMMY("rot_clk",		ROT_CLK,		NULL, OFF),
+	CLK_DUMMY("tv_src_clk",		TV_SRC_CLK,		NULL, OFF),
+	CLK_DUMMY("tv_enc_clk",		TV_ENC_CLK,		NULL, OFF),
+	CLK_DUMMY("tv_dac_clk",		TV_DAC_CLK,		NULL, OFF),
+	CLK_DUMMY("vcodec_clk",		VCODEC_CLK,		NULL, OFF),
+	CLK_DUMMY("mdp_tv_clk",		MDP_TV_CLK,		NULL, OFF),
+	CLK_DUMMY("hdmi_clk",		HDMI_TV_CLK,		NULL, OFF),
+	CLK_DUMMY("hdmi_app_clk",	HDMI_APP_CLK,		NULL, OFF),
+	CLK_DUMMY("vpe_clk",		VPE_CLK,		NULL, OFF),
+	CLK_DUMMY("vfe_clk",		VFE_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_vfe_clk",	CSI0_VFE_CLK,		NULL, OFF),
+	CLK_DUMMY("smmu_jpegd_clk",	JPEGD_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("smmu_vfe_clk",	VFE_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("vfe_axi_clk",	VFE_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("ijpeg_axi_clk",	IJPEG_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("mdp_axi_clk",	MDP_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("rot_axi_clk",	ROT_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("vcodec_axi_clk",	VCODEC_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("vcodec_axi_a_clk",	VCODEC_AXI_A_CLK,	NULL, OFF),
+	CLK_DUMMY("vcodec_axi_b_clk",	VCODEC_AXI_A_CLK,	NULL, OFF),
+	CLK_DUMMY("vpe_axi_clk",	VPE_AXI_CLK,		NULL, OFF),
+	CLK_DUMMY("amp_pclk",		AMP_P_CLK,		NULL, OFF),
+	CLK_DUMMY("csi_pclk",		CSI0_P_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_m_pclk",		DSI1_M_P_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_s_pclk",		DSI1_S_P_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_m_pclk",		DSI2_M_P_CLK,		NULL, OFF),
+	CLK_DUMMY("dsi_s_pclk",		DSI2_S_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx2d0_pclk",	GFX2D0_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx2d1_pclk",	GFX2D1_P_CLK,		NULL, OFF),
+	CLK_DUMMY("gfx3d_pclk",		GFX3D_P_CLK,		NULL, OFF),
+	CLK_DUMMY("hdmi_m_pclk",	HDMI_M_P_CLK,		NULL, OFF),
+	CLK_DUMMY("hdmi_s_pclk",	HDMI_S_P_CLK,		NULL, OFF),
+	CLK_DUMMY("ijpeg_pclk",		IJPEG_P_CLK,		NULL, OFF),
+	CLK_DUMMY("jpegd_pclk",		JPEGD_P_CLK,		NULL, OFF),
+	CLK_DUMMY("imem_pclk",		IMEM_P_CLK,		NULL, OFF),
+	CLK_DUMMY("mdp_pclk",		MDP_P_CLK,		NULL, OFF),
+	CLK_DUMMY("smmu_pclk",		SMMU_P_CLK,		NULL, OFF),
+	CLK_DUMMY("rotator_pclk",	ROT_P_CLK,		NULL, OFF),
+	CLK_DUMMY("tv_enc_pclk",	TV_ENC_P_CLK,		NULL, OFF),
+	CLK_DUMMY("vcodec_pclk",	VCODEC_P_CLK,		NULL, OFF),
+	CLK_DUMMY("vfe_pclk",		VFE_P_CLK,		NULL, OFF),
+	CLK_DUMMY("vpe_pclk",		VPE_P_CLK,		NULL, OFF),
+	CLK_DUMMY("mi2s_osr_clk",	MI2S_OSR_CLK,		NULL, OFF),
+	CLK_DUMMY("mi2s_bit_clk",	MI2S_BIT_CLK,		NULL, OFF),
+	CLK_DUMMY("i2s_mic_osr_clk",	CODEC_I2S_MIC_OSR_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_mic_bit_clk",	CODEC_I2S_MIC_BIT_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_mic_osr_clk",	SPARE_I2S_MIC_OSR_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_mic_bit_clk",	SPARE_I2S_MIC_BIT_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_spkr_osr_clk",	CODEC_I2S_SPKR_OSR_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_spkr_bit_clk",	CODEC_I2S_SPKR_BIT_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_spkr_osr_clk",	SPARE_I2S_SPKR_OSR_CLK,	NULL, OFF),
+	CLK_DUMMY("i2s_spkr_bit_clk",	SPARE_I2S_SPKR_BIT_CLK,	NULL, OFF),
+	CLK_DUMMY("pcm_clk",		PCM_CLK,		NULL, OFF),
+	CLK_DUMMY("iommu_clk",		JPEGD_AXI_CLK,		NULL, 0),
+	CLK_DUMMY("iommu_clk",		VFE_AXI_CLK,		NULL, 0),
+	CLK_DUMMY("iommu_clk",		VCODEC_AXI_CLK,	NULL, 0),
+	CLK_DUMMY("iommu_clk",		VCODEC_AXI_CLK,	NULL, 0),
+	CLK_DUMMY("iommu_clk",		GFX3D_CLK,	NULL, 0),
+	CLK_DUMMY("iommu_clk",		GFX2D0_CLK,	NULL, 0),
+	CLK_DUMMY("iommu_clk",		GFX2D1_CLK,	NULL, 0),
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
1.7.2.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
