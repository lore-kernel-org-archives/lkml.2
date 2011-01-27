Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1A0UNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:13:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37454 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0UNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:13:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72018201"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] msm: Clean up useless ifdefs
Date: Thu, 27 Jan 2011 12:13:22 -0800
Message-Id: <1296159202-13980-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ifdefs that do nothing, either from having the code
between them previously removed, or from having been
accidentally added to the wrong file.

Change-Id: I94aac2cb24e23ba7f8b4b158ce6653dc3b786989
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/board-halibut.c               |    2 --
 arch/arm/mach-msm/board-mahimahi.c              |    2 --
 arch/arm/mach-msm/board-msm7x27.c               |    8 --------
 arch/arm/mach-msm/board-msm7x30.c               |    6 ------
 arch/arm/mach-msm/board-qsd8x50.c               |    4 ----
 arch/arm/mach-msm/board-sapphire.c              |    2 --
 arch/arm/mach-msm/board-trout.c                 |    2 --
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |    6 ------
 8 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 75dabb1..18a3c97 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -93,8 +93,6 @@ static void __init halibut_map_io(void)
 }
 
 MACHINE_START(HALIBUT, "Halibut Board (QCT SURF7200A)")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= 0x10000100,
 	.fixup		= halibut_fixup,
 	.map_io		= halibut_map_io,
diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
index ef3ebf2..7a9a03e 100644
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ b/arch/arm/mach-msm/board-mahimahi.c
@@ -74,8 +74,6 @@ static void __init mahimahi_map_io(void)
 extern struct sys_timer msm_timer;
 
 MACHINE_START(MAHIMAHI, "mahimahi")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= 0x20000100,
 	.fixup		= mahimahi_fixup,
 	.map_io		= mahimahi_map_io,
diff --git a/arch/arm/mach-msm/board-msm7x27.c b/arch/arm/mach-msm/board-msm7x27.c
index e7a76ef..16d7580 100644
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ b/arch/arm/mach-msm/board-msm7x27.c
@@ -130,8 +130,6 @@ static void __init msm7x2x_map_io(void)
 }
 
 MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
@@ -140,8 +138,6 @@ MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
@@ -150,8 +146,6 @@ MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
 MACHINE_END
 
 MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
@@ -160,8 +154,6 @@ MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X25_FFA, "QCT MSM7x25 FFA")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= PHYS_OFFSET + 0x100,
 	.map_io		= msm7x2x_map_io,
 	.init_irq	= msm7x2x_init_irq,
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 0707cc0..dc9fac1 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -105,8 +105,6 @@ static void __init msm7x30_map_io(void)
 }
 
 MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params = PHYS_OFFSET + 0x100,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
@@ -115,8 +113,6 @@ MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
 MACHINE_END
 
 MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params = PHYS_OFFSET + 0x100,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
@@ -125,8 +121,6 @@ MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
 MACHINE_END
 
 MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params = PHYS_OFFSET + 0x100,
 	.map_io = msm7x30_map_io,
 	.init_irq = msm7x30_init_irq,
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 29ef683..b464d48 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -195,8 +195,6 @@ static void __init qsd8x50_init(void)
 }
 
 MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params = PHYS_OFFSET + 0x100,
 	.map_io = qsd8x50_map_io,
 	.init_irq = qsd8x50_init_irq,
@@ -205,8 +203,6 @@ MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
 MACHINE_END
 
 MACHINE_START(QSD8X50A_ST1_5, "QCT QSD8X50A ST1.5")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params = PHYS_OFFSET + 0x100,
 	.map_io = qsd8x50_map_io,
 	.init_irq = qsd8x50_init_irq,
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 8919ffb..6781ca8 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -105,8 +105,6 @@ static void __init sapphire_map_io(void)
 
 MACHINE_START(SAPPHIRE, "sapphire")
 /* Maintainer: Brian Swetland <swetland@google.com> */
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params    = PHYS_OFFSET + 0x100,
 	.fixup          = sapphire_fixup,
 	.map_io         = sapphire_map_io,
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 73f1460..8448687 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -92,8 +92,6 @@ static void __init trout_map_io(void)
 }
 
 MACHINE_START(TROUT, "HTC Dream")
-#ifdef CONFIG_MSM_DEBUG_UART
-#endif
 	.boot_params	= 0x10000100,
 	.fixup		= trout_fixup,
 	.map_io		= trout_map_io,
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 1e75ed7..8f99d97 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -126,10 +126,4 @@
 #define MSM_AD5_SIZE          (SZ_1M*13)
 
 
-#if defined(CONFIG_ARCH_MSM7X30)
-#define MSM_GCC_BASE          IOMEM(0xF8009000)
-#define MSM_GCC_PHYS          0xC0182000
-#define MSM_GCC_SIZE          SZ_4K
-#endif
-
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

