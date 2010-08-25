Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0HYE7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0HYE6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012228"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366131"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 01/24] msm: create config option for proc-comm
Date: Tue, 24 Aug 2010 21:57:30 -0700
Message-Id: <1282712273-344-2-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

Some builds may not support the proc-comm interface with
the baseband processor.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig  |    7 +++++++
 arch/arm/mach-msm/Makefile |    6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 4e79580..08ed76c 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -10,6 +10,7 @@ config ARCH_MSM7X00A
 	select MSM_SMD
 	select MSM_SMD_PKG3
 	select CPU_V6
+	select MSM_PROC_COMM
 
 config ARCH_MSM7X30
 	bool "MSM7x30"
@@ -18,6 +19,7 @@ config ARCH_MSM7X30
 	select MSM_VIC
 	select CPU_V7
 	select MSM_REMOTE_SPINLOCK_DEKKERS
+	select MSM_PROC_COMM
 
 config ARCH_QSD8X50
 	bool "QSD8X50"
@@ -26,6 +28,8 @@ config ARCH_QSD8X50
 	select MSM_VIC
 	select CPU_V7
 	select MSM_REMOTE_SPINLOCK_LDREX
+	select MSM_PROC_COMM
+
 endchoice
 
 config MSM_SOC_REV_A
@@ -103,6 +107,9 @@ endchoice
 config MSM_SMD_PKG3
 	bool
 
+config MSM_PROC_COMM
+	bool
+
 config MSM_SMD
 	bool
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index faeb1f9..78fb536 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,8 +1,5 @@
-obj-y += proc_comm.o
 obj-y += io.o idle.o timer.o dma.o
-obj-y += vreg.o
 obj-y += acpuclock-arm11.o
-obj-y += clock.o clock-pcom.o
 
 ifdef CONFIG_MSM_VIC
 obj-y += irq-vic.o
@@ -10,10 +7,11 @@ else
 obj-y += irq.o
 endif
 
+obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
+obj-$(CONFIG_MSM_PROC_COMM) += clock.o gpio.o
 obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
-
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
