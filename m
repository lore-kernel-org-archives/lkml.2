Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab0JFHnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab0JFHnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56772950"
X-IronPort-AV: E=Sophos;i="4.57,288,1283756400"; 
   d="scan'208";a="20252801"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 17/20 v2] msm: add MSM8x60 FFA support
Date: Wed,  6 Oct 2010 00:42:56 -0700
Message-Id: <1286350979-19328-18-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Bean <gbean@codeaurora.org>

The MSM8X60 FFA contains different components than the MSM8X60 SURF,
and therefore requires a different ARCH type and machine ID.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    9 ++++++++-
 arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index d5076eb..e469217 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -38,7 +38,8 @@ config ARCH_MSM8X60
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
-	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM)
+	select MACH_MSM8X60_SURF if (!MACH_MSM8X60_RUMI3 && !MACH_MSM8X60_SIM \
+				  && !MACH_MSM8X60_FFA)
 
 endchoice
 
@@ -109,6 +110,12 @@ config MACH_MSM8X60_SIM
 	help
 	  Support for the Qualcomm MSM8x60 simulator.
 
+config MACH_MSM8X60_FFA
+	depends on ARCH_MSM8X60
+	bool "MSM8x60 FFA"
+	help
+	  Support for the Qualcomm MSM8x60 FFA eval board.
+
 endmenu
 
 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 95b0e36..7486a68 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -91,3 +91,10 @@ MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
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
