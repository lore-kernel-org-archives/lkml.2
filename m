Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1G1USV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:18:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41387 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1G1USU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:18:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6421"; a="106624115"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH 1/2] ARM: msm: Remove .boot_params from MSM boardfiles
Date: Thu, 28 Jul 2011 13:18:10 -0700
Message-Id: <1311884291-5409-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
References: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootloaders on MSM always pass the ATAGs address to the kernel in
r2.  It isn't necessary to set .boot_params in the machine
descriptors, and this unnecessarily hinders having a common kernel for
multiple targets, so remove them.

Signed-off-by: David Brown <davidb@codeaurora.org>

diff --git a/arch/arm/mach-msm/board-msm7x27.c b/arch/arm/mach-msm/board-msm7x27.c
index c03f269..f7acdc5 100644
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ b/arch/arm/mach-msm/board-msm7x27.c
@@ -130,7 +130,6 @@ static void __init msm7x2x_map_io(void)
 }
 
 MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
-	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
 	.init_machine	= msm7x2x_init,
@@ -138,7 +137,6 @@ MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
-	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
 	.init_machine	= msm7x2x_init,
@@ -146,7 +144,6 @@ MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
 MACHINE_END
 
 MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
-	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
 	.init_machine	= msm7x2x_init,
@@ -154,7 +151,6 @@ MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X25_FFA, "QCT MSM7x25 FFA")
-	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
 	.init_machine	= msm7x2x_init,
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index d1e4cc8..4d5065f 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -122,7 +122,6 @@ static void __init msm7x30_map_io(void)
 }
 
 MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
-	.boot_params = PLAT_PHYS_OFFSET + 0x100,
 	.fixup = msm7x30_fixup,
 	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
@@ -132,7 +131,6 @@ MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
-	.boot_params = PLAT_PHYS_OFFSET + 0x100,
 	.fixup = msm7x30_fixup,
 	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
@@ -142,7 +140,6 @@ MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
 MACHINE_END
 
 MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
-	.boot_params = PLAT_PHYS_OFFSET + 0x100,
 	.fixup = msm7x30_fixup,
 	.reserve = msm7x30_reserve,
 	.map_io = msm7x30_map_io,
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 6a96911..94cca95 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -193,7 +193,6 @@ static void __init qsd8x50_init(void)
 }
 
 MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
-	.boot_params = PLAT_PHYS_OFFSET + 0x100,
 	.map_io = qsd8x50_map_io,
 	.init_irq = qsd8x50_init_irq,
 	.init_machine = qsd8x50_init,
@@ -201,7 +200,6 @@ MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
 MACHINE_END
 
 MACHINE_START(QSD8X50A_ST1_5, "QCT QSD8X50A ST1.5")
-	.boot_params = PLAT_PHYS_OFFSET + 0x100,
 	.map_io = qsd8x50_map_io,
 	.init_irq = qsd8x50_init_irq,
 	.init_machine = qsd8x50_init,
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 68f930f..950a27e 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -105,7 +105,6 @@ static void __init sapphire_map_io(void)
 
 MACHINE_START(SAPPHIRE, "sapphire")
 /* Maintainer: Brian Swetland <swetland@google.com> */
-	.boot_params    = PLAT_PHYS_OFFSET + 0x100,
 	.fixup          = sapphire_fixup,
 	.map_io         = sapphire_map_io,
 	.init_irq       = sapphire_init_irq,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

