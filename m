Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab1BKU2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:28:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab1BKU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:28:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74105720"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/3] msm: iommu: Create a Kconfig item for the IOMMU driver
Date: Fri, 11 Feb 2011 12:28:16 -0800
Message-Id: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break the IOMMU driver out as a Kconfig item. Initially it
was decided to always build this in for 8x60, but this
driver is not strictly necessary and should be optionally
selectable.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig  |   13 ++++++++++++-
 arch/arm/mach-msm/Makefile |    3 ++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index df9d74e..32b9d1f 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -45,7 +45,6 @@ config ARCH_MSM8X60
 	select CPU_V7
 	select MSM_V2_TLMM
 	select MSM_GPIOMUX
-	select IOMMU_API
 	select MSM_SCM if SMP

 config ARCH_MSM8960
@@ -149,6 +148,18 @@ config MACH_MSM8960_RUMI3

 endmenu

+config MSM_IOMMU
+	bool "MSM IOMMU Support"
+	depends on ARCH_MSM8X60
+	select IOMMU_API
+	default n
+	help
+	  Support for the IOMMUs found on certain Qualcomm SOCs.
+	  These IOMMUs allow virtualization of the address space used by most
+	  cores within the multimedia subsystem.
+
+	  If unsure, say N here.
+
 config IOMMU_PGTABLES_L2
 	def_bool y
 	depends on ARCH_MSM8X60 && MMU && SMP && CPU_DCACHE_DISABLE=n
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index ea8c74f..81f4811 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -4,11 +4,12 @@ obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 endif

 obj-$(CONFIG_MSM_VIC) += irq-vic.o
+obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o

 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
-obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o iommu.o iommu_dev.o devices-msm8x60-iommu.o
+obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o devices-msm8x60-iommu.o
 obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o

 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

