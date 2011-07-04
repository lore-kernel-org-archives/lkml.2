Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1GDCOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:14:47 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35561 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1GDCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:14:27 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kwanghyun La <nala.la@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/6] ARM: EXYNOS4: SYSMMU: Enhancement on device definition
Date: Mon,  4 Jul 2011 10:41:44 +0900
Message-Id: <1309743708-1505-4-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a bit enhancement of Marek and Andrzej's patch
that includes the suggestion of System MMU's resource management.
https://patchwork.kernel.org/patch/714601/

Resource and platform device definitions of all system MMUs are very
similar, the definitions are simplified with a macro definition.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos4/dev-sysmmu.c |  216 ++++++++++--------------------------
 1 files changed, 59 insertions(+), 157 deletions(-)

diff --git a/arch/arm/mach-exynos4/dev-sysmmu.c b/arch/arm/mach-exynos4/dev-sysmmu.c
index af1110e..5da8a4c 100644
--- a/arch/arm/mach-exynos4/dev-sysmmu.c
+++ b/arch/arm/mach-exynos4/dev-sysmmu.c
@@ -37,166 +37,68 @@ const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
 	"SYSMMU_MFC_R"	,
 };
 
-static struct resource exynos4_sysmmu_resource[] = {
-	[0] = {
-		.start	= EXYNOS4_PA_SYSMMU_SSS,
-		.end	= EXYNOS4_PA_SYSMMU_SSS + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_SYSMMU_SSS_0,
-		.end	= IRQ_SYSMMU_SSS_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = {
-		.start	= IRQ_SYSMMU_FIMC0_0,
-		.end	= IRQ_SYSMMU_FIMC0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[4] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[5] = {
-		.start	= IRQ_SYSMMU_FIMC1_0,
-		.end	= IRQ_SYSMMU_FIMC1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[6] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC2,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[7] = {
-		.start	= IRQ_SYSMMU_FIMC2_0,
-		.end	= IRQ_SYSMMU_FIMC2_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[8] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC3,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC3 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[9] = {
-		.start	= IRQ_SYSMMU_FIMC3_0,
-		.end	= IRQ_SYSMMU_FIMC3_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[10] = {
-		.start	= EXYNOS4_PA_SYSMMU_JPEG,
-		.end	= EXYNOS4_PA_SYSMMU_JPEG + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[11] = {
-		.start	= IRQ_SYSMMU_JPEG_0,
-		.end	= IRQ_SYSMMU_JPEG_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[12] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[13] = {
-		.start	= IRQ_SYSMMU_LCD0_M0_0,
-		.end	= IRQ_SYSMMU_LCD0_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[14] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[15] = {
-		.start	= IRQ_SYSMMU_LCD1_M1_0,
-		.end	= IRQ_SYSMMU_LCD1_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[16] = {
-		.start	= EXYNOS4_PA_SYSMMU_PCIe,
-		.end	= EXYNOS4_PA_SYSMMU_PCIe + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[17] = {
-		.start	= IRQ_SYSMMU_PCIE_0,
-		.end	= IRQ_SYSMMU_PCIE_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[18] = {
-		.start	= EXYNOS4_PA_SYSMMU_G2D,
-		.end	= EXYNOS4_PA_SYSMMU_G2D + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[19] = {
-		.start	= IRQ_SYSMMU_2D_0,
-		.end	= IRQ_SYSMMU_2D_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[20] = {
-		.start	= EXYNOS4_PA_SYSMMU_ROTATOR,
-		.end	= EXYNOS4_PA_SYSMMU_ROTATOR + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[21] = {
-		.start	= IRQ_SYSMMU_ROTATOR_0,
-		.end	= IRQ_SYSMMU_ROTATOR_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[22] = {
-		.start	= EXYNOS4_PA_SYSMMU_MDMA2,
-		.end	= EXYNOS4_PA_SYSMMU_MDMA2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[23] = {
-		.start	= IRQ_SYSMMU_MDMA1_0,
-		.end	= IRQ_SYSMMU_MDMA1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[24] = {
-		.start	= EXYNOS4_PA_SYSMMU_TV,
-		.end	= EXYNOS4_PA_SYSMMU_TV + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[25] = {
-		.start	= IRQ_SYSMMU_TV_M0_0,
-		.end	= IRQ_SYSMMU_TV_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[26] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_L,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_L + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[27] = {
-		.start	= IRQ_SYSMMU_MFC_M0_0,
-		.end	= IRQ_SYSMMU_MFC_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[28] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_R,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_R + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[29] = {
-		.start	= IRQ_SYSMMU_MFC_M1_0,
-		.end	= IRQ_SYSMMU_MFC_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
+#define SYSMMU_RESOURCE(name, irq) [SYSMMU_##name] = {\
+		[0] = {\
+			.start	= EXYNOS4_PA_SYSMMU_##name,\
+			.end	= EXYNOS4_PA_SYSMMU_##name + SZ_4K - 1,\
+			.flags	= IORESOURCE_MEM,\
+		},\
+		[1] = {\
+			.start	= IRQ_SYSMMU_##irq##_0,\
+			.end	= IRQ_SYSMMU_##irq##_0,\
+			.flags	= IORESOURCE_IRQ,\
+		},\
+	}
+
+static u64 exynos4_sysmmu_dma_mask = DMA_BIT_MASK(32);
+
+#define SYSMMU_PLATFORM_DEVICE(ips) [SYSMMU_##ips] = {\
+	.name		= "s5p-sysmmu",\
+	.id		= SYSMMU_##ips,\
+	.num_resources	= ARRAY_SIZE(\
+				exynos4_sysmmu_resource[SYSMMU_##ips]),\
+	.resource	= exynos4_sysmmu_resource[SYSMMU_##ips],\
+	.dev		= {\
+		.dma_mask		= &exynos4_sysmmu_dma_mask,\
+		.coherent_dma_mask	= DMA_BIT_MASK(32),\
+	},\
+}
+
+static struct resource exynos4_sysmmu_resource[S5P_SYSMMU_TOTAL_IPNUM][2] = {
+	SYSMMU_RESOURCE(SSS, SSS),
+	SYSMMU_RESOURCE(FIMC0, FIMC0),
+	SYSMMU_RESOURCE(FIMC1, FIMC1),
+	SYSMMU_RESOURCE(FIMC2, FIMC2),
+	SYSMMU_RESOURCE(FIMC3, FIMC3),
+	SYSMMU_RESOURCE(JPEG, JPEG),
+	SYSMMU_RESOURCE(FIMD0, LCD0_M0),
+	SYSMMU_RESOURCE(FIMD1, LCD1_M1),
+	SYSMMU_RESOURCE(PCIe, PCIE),
+	SYSMMU_RESOURCE(G2D, 2D),
+	SYSMMU_RESOURCE(ROTATOR, ROTATOR),
+	SYSMMU_RESOURCE(MDMA, MDMA1),
+	SYSMMU_RESOURCE(TV, TV_M0),
+	SYSMMU_RESOURCE(MFC_L, MFC_M0),
+	SYSMMU_RESOURCE(MFC_R, MFC_M1),
 };
 
-struct platform_device exynos4_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 30,
-	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
-	.resource	= exynos4_sysmmu_resource,
+struct platform_device exynos4_device_sysmmu[S5P_SYSMMU_TOTAL_IPNUM] = {
+	SYSMMU_PLATFORM_DEVICE(SSS),
+	SYSMMU_PLATFORM_DEVICE(FIMC0),
+	SYSMMU_PLATFORM_DEVICE(FIMC1),
+	SYSMMU_PLATFORM_DEVICE(FIMC2),
+	SYSMMU_PLATFORM_DEVICE(FIMC3),
+	SYSMMU_PLATFORM_DEVICE(JPEG),
+	SYSMMU_PLATFORM_DEVICE(FIMD0),
+	SYSMMU_PLATFORM_DEVICE(FIMD1),
+	SYSMMU_PLATFORM_DEVICE(PCIe),
+	SYSMMU_PLATFORM_DEVICE(G2D),
+	SYSMMU_PLATFORM_DEVICE(ROTATOR),
+	SYSMMU_PLATFORM_DEVICE(MDMA),
+	SYSMMU_PLATFORM_DEVICE(TV),
+	SYSMMU_PLATFORM_DEVICE(MFC_L),
+	SYSMMU_PLATFORM_DEVICE(MFC_R),
 };
-EXPORT_SYMBOL(exynos4_device_sysmmu);
 
 static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
 void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
-- 
1.7.1

