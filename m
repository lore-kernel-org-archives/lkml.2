Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2BDMQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:16:42 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53447 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2BDMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:16:40 -0500
From: Aneesh V <aneesh@ti.com>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [RFC PATCH 1/8] OMAP4: hwmod: add EMIF hw mod data
Date: Sat,  4 Feb 2012 17:46:04 +0530
Message-Id: <1328357771-31644-2-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328357771-31644-1-git-send-email-aneesh@ti.com>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  110 ++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index f9f1510..2b107c7 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -5480,6 +5480,111 @@ static struct omap_hwmod omap44xx_usb_tll_hs_hwmod = {
 	.slaves_cnt	= ARRAY_SIZE(omap44xx_usb_tll_hs_slaves),
 };
 
+/*
+ * 'emif' class
+ * external memory interface no1
+ */
+
+static struct omap_hwmod_class omap44xx_emif_hwmod_class = {
+	.name	= "emif",
+};
+
+/* emif1 */
+static struct omap_hwmod omap44xx_emif1_hwmod;
+static struct omap_hwmod_irq_info omap44xx_emif1_irqs[] = {
+	{ .irq = 110 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap44xx_emif1_addrs[] = {
+	{
+		.pa_start	= 0x4c000000,
+		.pa_end		= 0x4c0000ff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* emif_fw -> emif1 */
+static struct omap_hwmod_ocp_if omap44xx_emif_fw__emif1 = {
+	.master		= &omap44xx_emif_fw_hwmod,
+	.slave		= &omap44xx_emif1_hwmod,
+	.clk		= "l3_div_ck",
+	.addr		= omap44xx_emif1_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* emif1 slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_emif1_slaves[] = {
+	&omap44xx_emif_fw__emif1,
+};
+
+static struct omap_hwmod omap44xx_emif1_hwmod = {
+	.name		= "emif1",
+	.class		= &omap44xx_emif_hwmod_class,
+	.flags		= HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET,
+	.mpu_irqs	= omap44xx_emif1_irqs,
+	.main_clk	= "emif1_fck",
+	.clkdm_name	= "l3_emif_clkdm",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_MEMIF_EMIF_1_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_MEMIF_EMIF_1_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+	.slaves		= omap44xx_emif1_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_emif1_slaves),
+};
+
+/* emif2 */
+static struct omap_hwmod omap44xx_emif2_hwmod;
+static struct omap_hwmod_irq_info omap44xx_emif2_irqs[] = {
+	{ .irq = 111 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap44xx_emif2_addrs[] = {
+	{
+		.pa_start	= 0x4d000000,
+		.pa_end		= 0x4d0000ff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* emif_fw -> emif2 */
+static struct omap_hwmod_ocp_if omap44xx_emif_fw__emif2 = {
+	.master		= &omap44xx_emif_fw_hwmod,
+	.slave		= &omap44xx_emif2_hwmod,
+	.clk		= "l3_div_ck",
+	.addr		= omap44xx_emif2_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* emif2 slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_emif2_slaves[] = {
+	&omap44xx_emif_fw__emif2,
+};
+
+static struct omap_hwmod omap44xx_emif2_hwmod = {
+	.name		= "emif2",
+	.class		= &omap44xx_emif_hwmod_class,
+	.flags		= HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET,
+	.mpu_irqs	= omap44xx_emif2_irqs,
+	.main_clk	= "emif2_fck",
+	.clkdm_name	= "l3_emif_clkdm",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_MEMIF_EMIF_1_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_MEMIF_EMIF_1_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		}
+	},
+	.slaves		= omap44xx_emif2_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_emif2_slaves),
+};
+
 static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 
 	/* dmm class */
@@ -5629,6 +5734,11 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	/* wd_timer class */
 	&omap44xx_wd_timer2_hwmod,
 	&omap44xx_wd_timer3_hwmod,
+
+	/* emif class */
+	&omap44xx_emif1_hwmod,
+	&omap44xx_emif2_hwmod,
+
 	NULL,
 };
 
-- 
1.7.1

