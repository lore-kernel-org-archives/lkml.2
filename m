Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2FKA7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:36 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40544 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2FKA6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:31 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 09/14] sta2x11-mfd : add apb-soc-regs debugfs register set
Date: Mon, 11 Jun 2012 02:57:54 +0200
Message-Id: <1339376279-16753-10-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |   72 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 16d340c..110404f 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -156,11 +156,83 @@ static struct debugfs_regset32 apbreg_regset = {
 	.nregs = ARRAY_SIZE(sta2x11_apbreg_regs),
 };
 
+#define REG(regname) {.name = #regname, .offset = regname}
+static struct debugfs_reg32 sta2x11_apb_soc_regs_regs[] = {
+	REG(PCIE_EP1_FUNC3_0_INTR_REG), REG(PCIE_EP1_FUNC7_4_INTR_REG),
+	REG(PCIE_EP2_FUNC3_0_INTR_REG), REG(PCIE_EP2_FUNC7_4_INTR_REG),
+	REG(PCIE_EP3_FUNC3_0_INTR_REG), REG(PCIE_EP3_FUNC7_4_INTR_REG),
+	REG(PCIE_EP4_FUNC3_0_INTR_REG), REG(PCIE_EP4_FUNC7_4_INTR_REG),
+	REG(PCIE_INTR_ENABLE0_REG), REG(PCIE_INTR_ENABLE1_REG),
+	REG(PCIE_EP1_FUNC_TC_REG), REG(PCIE_EP2_FUNC_TC_REG),
+	REG(PCIE_EP3_FUNC_TC_REG), REG(PCIE_EP4_FUNC_TC_REG),
+	REG(PCIE_EP1_FUNC_F_REG), REG(PCIE_EP2_FUNC_F_REG),
+	REG(PCIE_EP3_FUNC_F_REG), REG(PCIE_EP4_FUNC_F_REG),
+	REG(PCIE_PAB_AMBA_SW_RST_REG), REG(PCIE_PM_STATUS_0_PORT_0_4),
+	REG(PCIE_PM_STATUS_7_0_EP1), REG(PCIE_PM_STATUS_7_0_EP2),
+	REG(PCIE_PM_STATUS_7_0_EP3), REG(PCIE_PM_STATUS_7_0_EP4),
+	REG(PCIE_DEV_ID_0_EP1_REG), REG(PCIE_CC_REV_ID_0_EP1_REG),
+	REG(PCIE_DEV_ID_1_EP1_REG), REG(PCIE_CC_REV_ID_1_EP1_REG),
+	REG(PCIE_DEV_ID_2_EP1_REG), REG(PCIE_CC_REV_ID_2_EP1_REG),
+	REG(PCIE_DEV_ID_3_EP1_REG), REG(PCIE_CC_REV_ID_3_EP1_REG),
+	REG(PCIE_DEV_ID_4_EP1_REG), REG(PCIE_CC_REV_ID_4_EP1_REG),
+	REG(PCIE_DEV_ID_5_EP1_REG), REG(PCIE_CC_REV_ID_5_EP1_REG),
+	REG(PCIE_DEV_ID_6_EP1_REG), REG(PCIE_CC_REV_ID_6_EP1_REG),
+	REG(PCIE_DEV_ID_7_EP1_REG), REG(PCIE_CC_REV_ID_7_EP1_REG),
+	REG(PCIE_DEV_ID_0_EP2_REG), REG(PCIE_CC_REV_ID_0_EP2_REG),
+	REG(PCIE_DEV_ID_1_EP2_REG), REG(PCIE_CC_REV_ID_1_EP2_REG),
+	REG(PCIE_DEV_ID_2_EP2_REG), REG(PCIE_CC_REV_ID_2_EP2_REG),
+	REG(PCIE_DEV_ID_3_EP2_REG), REG(PCIE_CC_REV_ID_3_EP2_REG),
+	REG(PCIE_DEV_ID_4_EP2_REG), REG(PCIE_CC_REV_ID_4_EP2_REG),
+	REG(PCIE_DEV_ID_5_EP2_REG), REG(PCIE_CC_REV_ID_5_EP2_REG),
+	REG(PCIE_DEV_ID_6_EP2_REG), REG(PCIE_CC_REV_ID_6_EP2_REG),
+	REG(PCIE_DEV_ID_7_EP2_REG), REG(PCIE_CC_REV_ID_7_EP2_REG),
+	REG(PCIE_DEV_ID_0_EP3_REG), REG(PCIE_CC_REV_ID_0_EP3_REG),
+	REG(PCIE_DEV_ID_1_EP3_REG), REG(PCIE_CC_REV_ID_1_EP3_REG),
+	REG(PCIE_DEV_ID_2_EP3_REG), REG(PCIE_CC_REV_ID_2_EP3_REG),
+	REG(PCIE_DEV_ID_3_EP3_REG), REG(PCIE_CC_REV_ID_3_EP3_REG),
+	REG(PCIE_DEV_ID_4_EP3_REG), REG(PCIE_CC_REV_ID_4_EP3_REG),
+	REG(PCIE_DEV_ID_5_EP3_REG), REG(PCIE_CC_REV_ID_5_EP3_REG),
+	REG(PCIE_DEV_ID_6_EP3_REG), REG(PCIE_CC_REV_ID_6_EP3_REG),
+	REG(PCIE_DEV_ID_7_EP3_REG), REG(PCIE_CC_REV_ID_7_EP3_REG),
+	REG(PCIE_DEV_ID_0_EP4_REG), REG(PCIE_CC_REV_ID_0_EP4_REG),
+	REG(PCIE_DEV_ID_1_EP4_REG), REG(PCIE_CC_REV_ID_1_EP4_REG),
+	REG(PCIE_DEV_ID_2_EP4_REG), REG(PCIE_CC_REV_ID_2_EP4_REG),
+	REG(PCIE_DEV_ID_3_EP4_REG), REG(PCIE_CC_REV_ID_3_EP4_REG),
+	REG(PCIE_DEV_ID_4_EP4_REG), REG(PCIE_CC_REV_ID_4_EP4_REG),
+	REG(PCIE_DEV_ID_5_EP4_REG), REG(PCIE_CC_REV_ID_5_EP4_REG),
+	REG(PCIE_DEV_ID_6_EP4_REG), REG(PCIE_CC_REV_ID_6_EP4_REG),
+	REG(PCIE_DEV_ID_7_EP4_REG), REG(PCIE_CC_REV_ID_7_EP4_REG),
+	REG(PCIE_SUBSYS_VEN_ID_REG), REG(PCIE_COMMON_CLOCK_CONFIG_0_4_0),
+	REG(PCIE_MIPHYP_SSC_EN_REG), REG(PCIE_MIPHYP_ADDR_REG),
+	REG(PCIE_L1_ASPM_READY_REG), REG(PCIE_EXT_CFG_RDY_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS0_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS1_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS2_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS3_REG),
+	REG(DMA_IP_CTRL_REG), REG(DISP_BRIDGE_PU_PD_CTRL_REG),
+	REG(VIP_PU_PD_CTRL_REG), REG(USB_MLB_PU_PD_CTRL_REG),
+	REG(SDIO_PU_PD_MISCFUNC_CTRL_REG1), REG(SDIO_PU_PD_MISCFUNC_CTRL_REG2),
+	REG(UART_PU_PD_CTRL_REG), REG(ARM_Lock), REG(SYS_IO_CHAR_REG1),
+	REG(SYS_IO_CHAR_REG2), REG(SATA_CORE_ID_REG), REG(SATA_CTRL_REG),
+	REG(I2C_HSFIX_MISC_REG), REG(SPARE2_RESERVED), REG(SPARE3_RESERVED),
+	REG(MASTER_LOCK_REG), REG(SYSTEM_CONFIG_STATUS_REG),
+	REG(MSP_CLK_CTRL_REG), REG(COMPENSATION_REG1), REG(COMPENSATION_REG2),
+	REG(COMPENSATION_REG3), REG(TEST_CTL_REG),
+};
+#undef REG
+
+static struct debugfs_regset32 apb_soc_regs_regset = {
+	.regs = sta2x11_apb_soc_regs_regs,
+	.nregs = ARRAY_SIZE(sta2x11_apb_soc_regs_regs),
+};
+
+
 static struct dentry *sta2x11_mfd_debugfs[sta2x11_n_mfd_plat_devs];
 
 static struct debugfs_regset32 *sta2x11_mfd_regset[sta2x11_n_mfd_plat_devs] = {
 	[sta2x11_sctl] = &sctl_regset,
 	[sta2x11_apbreg] = &apbreg_regset,
+	[sta2x11_apb_soc_regs] = &apb_soc_regs_regset,
 };
 
 static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
-- 
1.7.9.1

