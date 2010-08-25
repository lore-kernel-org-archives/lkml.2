Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0HYE7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17533 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0HYE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012272"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366150"
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
Subject: [PATCH 20/24] msm: MSM8X60 simulator board support
Date: Tue, 24 Aug 2010 21:57:49 -0700
Message-Id: <1282712273-344-21-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

Board configuration for MSM8X60 simulation.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    7 +++++++
 arch/arm/mach-msm/Makefile        |    1 +
 arch/arm/mach-msm/board-msm8x60.c |   10 +++++++++-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 3017e12..d2610a3 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -105,6 +105,13 @@ config MACH_MSM8X60_SURF
 	help
 	  Support for the Qualcomm MSM8x60 SURF eval board.
 
+config MACH_MSM8X60_SIM
+	depends on ARCH_MSM8X60
+	default n
+	bool "MSM8x60 Simulator"
+	help
+	  Support for the Qualcomm MSM8x60 simulator.
+
 endmenu
 
 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 1d62025..9fb73ab 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o
 obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
 obj-$(CONFIG_MACH_MSM8X60_RUMI3) += board-msm8x60.o
 obj-$(CONFIG_MACH_MSM8X60_SURF) += board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_SIM) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index fd953c2..7a2ed7f 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -56,7 +56,8 @@ static void __init msm8x60_init_irq(void)
 	/* RUMI does not adhere to GIC spec by enabling STIs by default.
 	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
 	 */
-	writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
+	if (!machine_is_msm8x60_sim())
+		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
 
 	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
 	 * as they are configured as level, which does not play nice with
@@ -85,3 +86,10 @@ MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
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
