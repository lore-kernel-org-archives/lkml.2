Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1FFVvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:51:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab1FFVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95967499"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 2/8] msm: Remove chip-ifdefs for GPIO io mappings
Date: Mon,  6 Jun 2011 14:51:09 -0700
Message-Id: <1307397075-11733-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two GPIO controllers are always mapped to the same virtual address
across all MSM devices.  Instead of selecting this at compile time,
determine the physical address at runtime, eliminating yet something
else preventing multiple MSM targets from being compiled into the same
kernel.

Signed-off-by: David Brown <davidb@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 ++
 arch/arm/mach-msm/io.c                          |   12 ++++++------
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 8f99d97..94fe9fe 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -55,13 +55,11 @@
 #define MSM_DMOV_PHYS         0xA9700000
 #define MSM_DMOV_SIZE         SZ_4K
 
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
index 4d84be1..3769444 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -46,13 +46,11 @@
 #define MSM_DMOV_PHYS         0xAC400000
 #define MSM_DMOV_SIZE         SZ_4K
 
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
index d414320..d67cd73 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -46,13 +46,11 @@
 #define MSM_DMOV_PHYS         0xA9700000
 #define MSM_DMOV_SIZE         SZ_4K
 
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
index 2f494b6..4ded152 100644
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
index cec6ed1..140ddbb 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -43,8 +43,8 @@ static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X00),
 	MSM_DEVICE(DMOV),
-	MSM_DEVICE(GPIO1),
-	MSM_DEVICE(GPIO2),
+	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
+	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
 	MSM_DEVICE(CLK_CTL),
 #ifdef CONFIG_MSM_DEBUG_UART
 	MSM_DEVICE(DEBUG_UART),
@@ -76,8 +76,8 @@ static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, QSD8X50),
 	MSM_DEVICE(DMOV),
-	MSM_DEVICE(GPIO1),
-	MSM_DEVICE(GPIO2),
+	MSM_CHIP_DEVICE(GPIO1, QSD8X50),
+	MSM_CHIP_DEVICE(GPIO2, QSD8X50),
 	MSM_DEVICE(CLK_CTL),
 	MSM_DEVICE(SIRC),
 	MSM_DEVICE(SCPLL),
@@ -135,8 +135,8 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X30),
 	MSM_DEVICE(DMOV),
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

