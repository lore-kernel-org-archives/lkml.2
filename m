Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0HYE7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17533 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0HYE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012273"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366151"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 21/24] msm: add MSM8x60 FFA support
Date: Tue, 24 Aug 2010 21:57:50 -0700
Message-Id: <1282712273-344-22-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Bean <gbean@codeaurora.org>

The MSM8X60 FFA contains different components than the MSM8X60 SURF,
and therefore requires a different ARCH type and machine ID.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    7 +++++++
 arch/arm/mach-msm/Makefile        |    1 +
 arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index d2610a3..d6b83de 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -112,6 +112,13 @@ config MACH_MSM8X60_SIM
 	help
 	  Support for the Qualcomm MSM8x60 simulator.
 
+config MACH_MSM8X60_FFA
+	depends on ARCH_MSM8X60
+	default n
+	bool "MSM8x60 FFA"
+	help
+	  Support for the Qualcomm MSM8x60 FFA eval board.
+
 endmenu
 
 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9fb73ab..c984f4d 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
 obj-$(CONFIG_MACH_MSM8X60_RUMI3) += board-msm8x60.o
 obj-$(CONFIG_MACH_MSM8X60_SURF) += board-msm8x60.o
 obj-$(CONFIG_MACH_MSM8X60_SIM) += board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_FFA) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 7a2ed7f..02d22ea 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -93,3 +93,10 @@ MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
+	.map_io = msm8x60_map_io,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_init,
+	.timer = &msm_timer,
+MACHINE_END
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
