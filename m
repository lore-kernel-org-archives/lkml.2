Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1DDTxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:53:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1DDTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:53:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6306"; a="83922237"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: Makefile: Separate machines from arches
Date: Mon,  4 Apr 2011 12:53:07 -0700
Message-Id: <1301946787-7826-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc0.116.g44bc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any reason to build the board files for machines that
aren't actually defined. But we always want to build in the
devices file since they are common to each ARCH. Split the two so
that boards are only built when the machines they support are
selected.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index c72cb8e..31cdcfd 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -21,13 +21,11 @@ obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 
-obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
-obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
-obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
-obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
-obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
-obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o devices-msm8x60.o
-obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
+obj-$(CONFIG_ARCH_MSM7X00A) += devices-msm7x00.o
+obj-$(CONFIG_ARCH_MSM7X30) += devices-msm7x30.o
+obj-$(CONFIG_ARCH_MSM8X60) += devices-msm8x60.o
+obj-$(CONFIG_ARCH_MSM8960) += devices-msm8960.o
+obj-$(CONFIG_ARCH_QSD8X50) += devices-qsd8x50.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
@@ -40,3 +38,20 @@ endif
 else
 obj-y	+= gpio.o
 endif
+
+obj-$(CONFIG_MACH_TROUT) += board-trout-gpio.o board-trout-mmc.o board-trout-panel.o
+
+# Board Support
+obj-$(CONFIG_MACH_HALIBUT)		+= board-halibut.o
+obj-$(CONFIG_MACH_MSM7X30_FFA)		+= board-msm7x30.o
+obj-$(CONFIG_MACH_MSM7X30_FLUID)	+= board-msm7x30.o
+obj-$(CONFIG_MACH_MSM7X30_SURF)		+= board-msm7x30.o
+obj-$(CONFIG_MACH_MSM8960_RUMI3)	+= board-msm8960.o
+obj-$(CONFIG_MACH_MSM8960_SIM)		+= board-msm8960.o
+obj-$(CONFIG_MACH_MSM8X60_FFA)		+= board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_RUMI3)	+= board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_SIM)		+= board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_SURF)		+= board-msm8x60.o
+obj-$(CONFIG_MACH_QSD8X50A_ST1_5)	+= board-qsd8x50.o
+obj-$(CONFIG_MACH_QSD8X50_SURF)		+= board-qsd8x50.o
+obj-$(CONFIG_MACH_TROUT)		+= board-trout.o
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

