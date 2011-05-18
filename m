Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1ERVvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:51:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42702 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1ERVvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:51:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="91952500"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/7] msm: Remove chip-ifdefs for GPIO io mappings
Date: Wed, 18 May 2011 14:50:48 -0700
Message-Id: <1305755453-31112-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two GPIO controllers are always mapped to the same virtual address
across all MSM devices.  Instead of selecting this at compile time,
determine the physical address at runtime, eliminating yet something
else preventing multiple MSM targets from being compiled into the same
kernel.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 ++
 arch/arm/mach-msm/io.c                          |   12 ++++++------
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index d6540e1..04bca83 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -54,13 +54,11 @@
 #define MSM7X00_DMOV_PHYS     0xA9700000
 #define MSM7X00_DMOV_SIZE     SZ_4K
 
-#define MSM_GPIO1_BASE        IOMEM(0xE0003000)
-#define MSM_GPIO1_PHYS        0xA9200000
-#define MSM_GPIO1_SIZE        SZ_4K
+#define MSM7X00_GPIO1_PHYS        0xA9200000
+#define MSM7X00_GPIO1_SIZE        SZ_4K
 
-#define MSM_GPIO2_BASE        IOMEM(0xE0004000)
-#define MSM_GPIO2_PHYS        0xA9300000
-#define MSM_GPIO2_SIZE        SZ_4K
+#define MSM7X00_GPIO2_PHYS        0xA9300000
+#define MSM7X00_GPIO2_SIZE        SZ_4K
 
 #define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
 #define MSM_CLK_CTL_PHYS      0xA8600000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 23912e5..7357ed6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -45,13 +45,11 @@
 #define MSM7X30_DMOV_PHYS     0xAC400000
 #define MSM7X30_DMOV_SIZE     SZ_4K
 
-#define MSM_GPIO1_BASE        IOMEM(0xE0003000)
-#define MSM_GPIO1_PHYS        0xAC001000
-#define MSM_GPIO1_SIZE        SZ_4K
+#define MSM7X30_GPIO1_PHYS        0xAC001000
+#define MSM7X30_GPIO1_SIZE        SZ_4K
 
-#define MSM_GPIO2_BASE        IOMEM(0xE0004000)
-#define MSM_GPIO2_PHYS        0xAC101000
-#define MSM_GPIO2_SIZE        SZ_4K
+#define MSM7X30_GPIO2_PHYS        0xAC101000
+#define MSM7X30_GPIO2_SIZE        SZ_4K
 
 #define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
 #define MSM_CLK_CTL_PHYS      0xAB800000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index fc36b82..38f37ed 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -45,13 +45,11 @@
 #define QSD8X50_DMOV_PHYS     0xA9700000
 #define QSD8X50_DMOV_SIZE     SZ_4K
 
-#define MSM_GPIO1_BASE        IOMEM(0xE0003000)
-#define MSM_GPIO1_PHYS        0xA9000000
-#define MSM_GPIO1_SIZE        SZ_4K
+#define QSD8X50_GPIO1_PHYS        0xA9000000
+#define QSD8X50_GPIO1_SIZE        SZ_4K
 
-#define MSM_GPIO2_BASE        IOMEM(0xE0004000)
-#define MSM_GPIO2_PHYS        0xA9100000
-#define MSM_GPIO2_SIZE        SZ_4K
+#define QSD8X50_GPIO2_PHYS        0xA9100000
+#define QSD8X50_GPIO2_SIZE        SZ_4K
 
 #define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
 #define MSM_CLK_CTL_PHYS      0xA8600000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c98c759..3c4ef35 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -61,5 +61,7 @@
 #define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
+#define MSM_GPIO1_BASE		IOMEM(0xE0003000)
+#define MSM_GPIO2_BASE		IOMEM(0xE0004000)
 
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 1c86cda..067653a 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -42,8 +42,8 @@
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(GPIO1),
-	MSM_DEVICE(GPIO2),
+	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
+	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
 	MSM_DEVICE(CLK_CTL),
 #ifdef CONFIG_MSM_DEBUG_UART
 	MSM_DEVICE(DEBUG_UART),
@@ -74,8 +74,8 @@ void __init msm_map_common_io(void)
 static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, QSD8X50),
-	MSM_DEVICE(GPIO1),
-	MSM_DEVICE(GPIO2),
+	MSM_CHIP_DEVICE(GPIO1, QSD8X50),
+	MSM_CHIP_DEVICE(GPIO2, QSD8X50),
 	MSM_DEVICE(CLK_CTL),
 	MSM_DEVICE(SIRC),
 	MSM_DEVICE(SCPLL),
@@ -132,8 +132,8 @@ void __init msm_map_msm8960_io(void)
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X30),
-	MSM_DEVICE(GPIO1),
-	MSM_DEVICE(GPIO2),
+	MSM_CHIP_DEVICE(GPIO1, MSM7X30),
+	MSM_CHIP_DEVICE(GPIO2, MSM7X30),
 	MSM_DEVICE(CLK_CTL),
 	MSM_DEVICE(CLK_CTL_SH2),
 	MSM_DEVICE(AD5),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
