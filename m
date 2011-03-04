Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1CDWJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:09:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38740 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1CDWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:09:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6275"; a="77917771"
From: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: will.deacon@arm.com, dwalker@fifo99.com, bryanh@codeaurora.org,
        davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>
Subject: [PATCH 1/3] msm: Add support for Scorpion and ScorpionMP PMU
Date: Fri,  4 Mar 2011 17:09:43 -0500
Message-Id: <1299276583-12542-1-git-send-email-sheetals@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for Qualcomm Scorpion and ScorpionMP
PMU. It also updates the IRQs corresponding to various Scorpion
and ScorpionMP based targets.

Signed-off-by: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                 |    2 +
 arch/arm/mach-msm/include/mach/irqs-7x30.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8960.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8x50.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8x60.h |    2 +-
 arch/arm/mach-msm/pmu.c                    |   36 ++++++++++++++++++++++++++++
 6 files changed, 42 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-msm/pmu.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 86acfa3..ee8f7ce 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -30,6 +30,8 @@ obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
+obj-$(CONFIG_ARCH_MSM_SCORPION) += pmu.o
+obj-$(CONFIG_ARCH_MSM_SCORPIONMP) += pmu.o
 ifdef CONFIG_MSM_V2_TLMM
 ifndef CONFIG_ARCH_MSM8960
 # TODO: TLMM Mapping issues need to be resolved
diff --git a/arch/arm/mach-msm/include/mach/irqs-7x30.h b/arch/arm/mach-msm/include/mach/irqs-7x30.h
index 1f15902..6b15c1e 100644
--- a/arch/arm/mach-msm/include/mach/irqs-7x30.h
+++ b/arch/arm/mach-msm/include/mach/irqs-7x30.h
@@ -24,7 +24,7 @@
 #define INT_AVS_SVIC_SW_DONE	6
 #define INT_SC_DBG_RX_FULL	7
 #define INT_SC_DBG_TX_EMPTY	8
-#define INT_ARM11_PM		9
+#define INT_ARMQC_PERFMON	9
 #define INT_AVS_REQ_DOWN	10
 #define INT_AVS_REQ_UP		11
 #define INT_SC_ACG		12
diff --git a/arch/arm/mach-msm/include/mach/irqs-8960.h b/arch/arm/mach-msm/include/mach/irqs-8960.h
index 81ab2a6..c723577 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8960.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8960.h
@@ -32,7 +32,7 @@
 #define AVS_SVICINTSWDONE			(GIC_PPI_START + 7)
 #define CPU_DBGCPUXCOMMRXFULL			(GIC_PPI_START + 8)
 #define CPU_DBGCPUXCOMMTXEMPTY			(GIC_PPI_START + 9)
-#define CPU_SICCPUXPERFMONIRPTREQ		(GIC_PPI_START + 10)
+#define INT_ARMQC_PERFMON			(GIC_PPI_START + 10)
 #define SC_AVSCPUXDOWN				(GIC_PPI_START + 11)
 #define SC_AVSCPUXUP				(GIC_PPI_START + 12)
 #define SC_SICCPUXACGIRPTREQ			(GIC_PPI_START + 13)
diff --git a/arch/arm/mach-msm/include/mach/irqs-8x50.h b/arch/arm/mach-msm/include/mach/irqs-8x50.h
index 26adbe0..385dd0a 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8x50.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8x50.h
@@ -57,7 +57,7 @@
 #define INT_TCSR_MPRPH_SC2   (32 + 6)
 #define INT_OP_PEN           (32 + 7)
 #define INT_AD_HSSD          (32 + 8)
-#define INT_ARM11_PM         (32 + 9)
+#define INT_ARMQC_PERFMON    (32 + 9)
 #define INT_SDMA_NON_SECURE  (32 + 10)
 #define INT_TSIF_IRQ         (32 + 11)
 #define INT_UART1DM_IRQ      (32 + 12)
diff --git a/arch/arm/mach-msm/include/mach/irqs-8x60.h b/arch/arm/mach-msm/include/mach/irqs-8x60.h
index f65841c..443162d 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8x60.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8x60.h
@@ -33,7 +33,7 @@
 #define AVS_SVICINTSWDONE			(GIC_PPI_START + 6)
 #define CPU_DBGCPUXCOMMRXFULL			(GIC_PPI_START + 7)
 #define CPU_DBGCPUXCOMMTXEMPTY			(GIC_PPI_START + 8)
-#define CPU_SICCPUXPERFMONIRPTREQ		(GIC_PPI_START + 9)
+#define INT_ARMQC_PERFMON			(GIC_PPI_START + 9)
 #define SC_AVSCPUXDOWN				(GIC_PPI_START + 10)
 #define SC_AVSCPUXUP				(GIC_PPI_START + 11)
 #define SC_SICCPUXACGIRPTREQ			(GIC_PPI_START + 12)
diff --git a/arch/arm/mach-msm/pmu.c b/arch/arm/mach-msm/pmu.c
new file mode 100644
index 0000000..62fad56
--- /dev/null
+++ b/arch/arm/mach-msm/pmu.c
@@ -0,0 +1,36 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 and
+* only version 2 as published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/platform_device.h>
+#include <asm/pmu.h>
+#include <mach/irqs.h>
+
+static struct resource pmu_resource = {
+	.start = INT_ARMQC_PERFMON,
+	.end = INT_ARMQC_PERFMON,
+	.flags	= IORESOURCE_IRQ,
+};
+
+static struct platform_device pmu_device = {
+	.name		= "arm-pmu",
+	.id		= ARM_PMU_DEVICE_CPU,
+	.resource	= &pmu_resource,
+	.num_resources	= 1,
+};
+
+static int __init scorpion_pmu_init(void)
+{
+	platform_device_register(&pmu_device);
+	return 0;
+}
+
+arch_initcall(scorpion_pmu_init);
-- 
1.7.4.1

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum

