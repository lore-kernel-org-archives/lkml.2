Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab1KBSk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:40:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab1KBShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707002"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 23/34] msm: Unify iomap for clock regions
Date: Wed,  2 Nov 2011 11:36:20 -0700
Message-Id: <1320258991-22325-24-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

8960 requires the iomap to be unified across all versions of the
MSM. Unify the io regions to avoid build errors.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |    5 ++---
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    5 ++---
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |    5 ++---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   15 ++++++---------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    3 +++
 arch/arm/mach-msm/io.c                          |   12 ++++++------
 6 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 94fe9fe..70dde27 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -61,9 +61,8 @@
 #define MSM7X00_GPIO2_PHYS        0xA9300000
 #define MSM7X00_GPIO2_SIZE        SZ_4K
 
-#define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
-#define MSM_CLK_CTL_PHYS      0xA8600000
-#define MSM_CLK_CTL_SIZE      SZ_4K
+#define MSM7X00_CLK_CTL_PHYS      0xA8600000
+#define MSM7X00_CLK_CTL_SIZE      SZ_4K
 
 #define MSM_SHARED_RAM_BASE   IOMEM(0xE0100000)
 #define MSM_SHARED_RAM_PHYS   0x01F00000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 3769444..e89264b 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -52,9 +52,8 @@
 #define MSM7X30_GPIO2_PHYS        0xAC101000
 #define MSM7X30_GPIO2_SIZE        SZ_4K
 
-#define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
-#define MSM_CLK_CTL_PHYS      0xAB800000
-#define MSM_CLK_CTL_SIZE      SZ_4K
+#define MSM7X30_CLK_CTL_PHYS      0xAB800000
+#define MSM7X30_CLK_CTL_SIZE      SZ_4K
 
 #define MSM_CLK_CTL_SH2_BASE  IOMEM(0xE0006000)
 #define MSM_CLK_CTL_SH2_PHYS  0xABA01000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index d67cd73..e8a209c 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -52,9 +52,8 @@
 #define QSD8X50_GPIO2_PHYS        0xA9100000
 #define QSD8X50_GPIO2_SIZE        SZ_4K
 
-#define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
-#define MSM_CLK_CTL_PHYS      0xA8600000
-#define MSM_CLK_CTL_SIZE      SZ_4K
+#define QSD8X50_CLK_CTL_PHYS      0xA8600000
+#define QSD8X50_CLK_CTL_SIZE      SZ_4K
 
 #define MSM_SIRC_BASE         IOMEM(0xE1006000)
 #define MSM_SIRC_PHYS         0xAC200000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 5b9718f..25b044e 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -53,17 +53,14 @@
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
 
-#define MSM_CLK_CTL_BASE	IOMEM(0xFA010000)
-#define MSM_CLK_CTL_PHYS	0x00900000
-#define MSM_CLK_CTL_SIZE	SZ_16K
+#define MSM8X60_CLK_CTL_PHYS	0x00900000
+#define MSM8X60_CLK_CTL_SIZE	SZ_16K
 
-#define MSM_MMSS_CLK_CTL_BASE	IOMEM(0xFA014000)
-#define MSM_MMSS_CLK_CTL_PHYS	0x04000000
-#define MSM_MMSS_CLK_CTL_SIZE	SZ_4K
+#define MSM8X60_MMSS_CLK_CTL_PHYS	0x04000000
+#define MSM8X60_MMSS_CLK_CTL_SIZE	SZ_4K
 
-#define MSM_LPASS_CLK_CTL_BASE	IOMEM(0xFA015000)
-#define MSM_LPASS_CLK_CTL_PHYS	0x28000000
-#define MSM_LPASS_CLK_CTL_SIZE	SZ_4K
+#define MSM8X60_LPASS_CLK_CTL_PHYS	0x28000000
+#define MSM8X60_LPASS_CLK_CTL_SIZE	SZ_4K
 
 #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 4ded152..20fcb41 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -63,5 +63,8 @@
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
 #define MSM_GPIO1_BASE		IOMEM(0xE0003000)
 #define MSM_GPIO2_BASE		IOMEM(0xE0004000)
+#define MSM_CLK_CTL_BASE	IOMEM(0xF0202000)
+#define MSM_MMSS_CLK_CTL_BASE	IOMEM(0xF0206000)
+#define MSM_LPASS_CLK_CTL_BASE	IOMEM(0xF0207000)
 
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index ff41964..8a6600c 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -45,7 +45,7 @@ static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
 	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
-	MSM_DEVICE(CLK_CTL),
+	MSM_CHIP_DEVICE(CLK_CTL, MSM7X00),
 #ifdef CONFIG_MSM_DEBUG_UART
 	MSM_DEVICE(DEBUG_UART),
 #endif
@@ -78,7 +78,7 @@ static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, QSD8X50),
 	MSM_CHIP_DEVICE(GPIO2, QSD8X50),
-	MSM_DEVICE(CLK_CTL),
+	MSM_CHIP_DEVICE(CLK_CTL, QSD8X50),
 	MSM_DEVICE(SIRC),
 	MSM_DEVICE(SCPLL),
 	MSM_DEVICE(AD5),
@@ -108,9 +108,9 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
-	MSM_DEVICE(CLK_CTL),
-	MSM_DEVICE(MMSS_CLK_CTL),
-	MSM_DEVICE(LPASS_CLK_CTL),
+	MSM_CHIP_DEVICE(CLK_CTL, MSM8X60),
+	MSM_CHIP_DEVICE(MMSS_CLK_CTL, MSM8X60),
+	MSM_CHIP_DEVICE(LPASS_CLK_CTL, MSM8X60),
 };
 
 void __init msm_map_msm8x60_io(void)
@@ -140,7 +140,7 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(DMOV),
 	MSM_CHIP_DEVICE(GPIO1, MSM7X30),
 	MSM_CHIP_DEVICE(GPIO2, MSM7X30),
-	MSM_DEVICE(CLK_CTL),
+	MSM_CHIP_DEVICE(CLK_CTL, MSM7X30),
 	MSM_DEVICE(CLK_CTL_SH2),
 	MSM_DEVICE(AD5),
 	MSM_DEVICE(MDC),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

