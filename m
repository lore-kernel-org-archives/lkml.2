Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1ASU0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:26:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1ASU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:26:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70910661"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 11/11] msm: Support for the MSM8960 RUMI3 target
Date: Wed, 19 Jan 2011 12:25:47 -0800
Message-Id: <1295468747-22796-12-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Add the machine record, init code, and build support for
the MSM8960 RUMI3.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    8 +++++++-
 arch/arm/mach-msm/board-msm8960.c |   10 ++++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index adca96c..df9d74e 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -51,7 +51,7 @@ config ARCH_MSM8X60
 config ARCH_MSM8960
 	bool "MSM8960"
 	select ARCH_MSM_SCORPIONMP
-	select MACH_MSM8960_SIM
+	select MACH_MSM8960_SIM if (!MACH_MSM8960_RUMI3)
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
@@ -141,6 +141,12 @@ config MACH_MSM8960_SIM
 	help
 	  Support for the Qualcomm MSM8960 simulator.
 
+config MACH_MSM8960_RUMI3
+	depends on ARCH_MSM8960
+	bool "MSM8960 RUMI3"
+	help
+	  Support for the Qualcomm MSM8960 RUMI3 emulator.
+
 endmenu
 
 config IOMMU_PGTABLES_L2
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 90efd54..2b09573 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -41,6 +41,9 @@ static void __init msm8960_init_irq(void)
 	/* Edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
 	writel(0xFFFFD7FF, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
 
+	if (machine_is_msm8960_rumi3())
+		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
+
 	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
 	 * as they are configured as level, which does not play nice with
 	 * handle_percpu_irq.
@@ -56,3 +59,10 @@ MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
+	.map_io = msm8960_map_io,
+	.init_irq = msm8960_init_irq,
+	.timer = &msm_timer,
+MACHINE_END
+
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

