Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab0LODtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:49:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30954 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab0LODt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872373"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 7/7] msm: Build support for the MSM8960 target
Date: Tue, 14 Dec 2010 19:49:21 -0800
Message-Id: <1292384961-8851-8-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Kconfig options and Makefile options needed to
build for the MSM8960 target. Only the simulator is
supported at this time.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig  |   16 ++++++++++++++++
 arch/arm/mach-msm/Makefile |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 8c57425..ba5c955 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -47,6 +47,16 @@ config ARCH_MSM8X60
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP

+config ARCH_MSM8960
+	bool "MSM8960"
+	select ARCH_MSM_SCORPIONMP
+	select MACH_MSM8960_SIM
+	select ARM_GIC
+	select CPU_V7
+	select MSM_V2_TLMM
+	select MSM_GPIOMUX
+	select MSM_SCM if SMP
+
 endchoice

 config MSM_SOC_REV_A
@@ -124,6 +134,12 @@ config MACH_MSM8X60_FFA
 	help
 	  Support for the Qualcomm MSM8x60 FFA eval board.

+config MACH_MSM8960_SIM
+	depends on ARCH_MSM8960
+	bool "MSM8960 Simulator"
+	help
+	  Support for the Qualcomm MSM8960 simulator.
+
 endmenu

 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 8cd0b5b..9e5717b 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
 obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o iommu.o iommu_dev.o devices-msm8x60-iommu.o
+obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o iommu.o iommu_dev.o

 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 obj-$(CONFIG_MSM_PROC_COMM) += clock.o
@@ -22,6 +23,7 @@ obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
+obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o

 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

