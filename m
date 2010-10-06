Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0JFHng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49200 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0JFHnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56772949"
X-IronPort-AV: E=Sophos;i="4.57,288,1283756400"; 
   d="scan'208";a="20252799"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 16/20 v2] msm: MSM8X60 simulator board support
Date: Wed,  6 Oct 2010 00:42:55 -0700
Message-Id: <1286350979-19328-17-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

Board configuration for MSM8X60 simulation.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    8 +++++++-
 arch/arm/mach-msm/board-msm8x60.c |   10 +++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 910db2e..d5076eb 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -38,7 +38,7 @@ config ARCH_MSM8X60
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
-	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3)
+	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM)
 
 endchoice
 
@@ -103,6 +103,12 @@ config MACH_MSM8X60_SURF
 	help
 	  Support for the Qualcomm MSM8x60 SURF eval board.
 
+config MACH_MSM8X60_SIM
+	depends on ARCH_MSM8X60
+	bool "MSM8x60 Simulator"
+	help
+	  Support for the Qualcomm MSM8x60 simulator.
+
 endmenu
 
 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index a8a4d8d..95b0e36 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -54,7 +54,8 @@ static void __init msm8x60_init_irq(void)
 	/* RUMI does not adhere to GIC spec by enabling STIs by default.
 	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
 	 */
-	writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
+	if (!machine_is_msm8x60_sim())
+		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
 
 	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
 	 * as they are configured as level, which does not play nice with
@@ -83,3 +84,10 @@ MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
+	.map_io = msm8x60_map_io,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_init,
+	.timer = &msm_timer,
+MACHINE_END
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
