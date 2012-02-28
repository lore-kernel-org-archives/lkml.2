Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab2B1Hb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:31:26 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:40496 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932259Ab2B1H2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:34 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 05/13] mmp2:register dma devices for mmp2 platform
Date: Tue, 28 Feb 2012 15:27:37 +0800
Message-Id: <1330414065-2949-6-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:13.0345 (UTC) FILETIME=[879FC910:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.register dma devices for mmp2 platform

Change-Id: I19a5bd38fbd65f2e465faec0aa9550cae7d5c592
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/mach-mmp/mmp2.c |  122 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index a0e083f..d816b47 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -1152,6 +1152,122 @@ static struct clk_lookup mmp2_clkregs[] = {
 	INIT_CLKREG(&clk_ccic2_gate, NULL, "CCIC2GATECLK"),
 };
 
+static struct resource mmp2_mdma_resource[] = {
+	[0] = {
+		.name   = "reg_phys",
+		.start  = 0xd42a0a00,
+		.end    = 0xd42a0a00 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.name   = "mdma_irq",
+		.start  = IRQ_MMP2_DMA_SECONDARY(16),
+		.end    = IRQ_MMP2_DMA_SECONDARY(17),
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct mmp_tdma_chan_info mdma_chan_info[] = {
+	[0] = {
+		.type     = MDMA1_CH0,
+		.reg_base = 0xd42a0a00,
+	},
+	[1] = {
+		.type     = MDMA1_CH1,
+		.reg_base = 0xd42a0a04,
+	},
+};
+
+struct mmp_tdma_platform_data mdma_platform_data = {
+	.nr_ch = 2,
+	.info  = mdma_chan_info,
+};
+
+static struct platform_device mmp2_device_mdma = {
+	.name           = "mmp-mdma",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(mmp2_mdma_resource),
+	.resource       = mmp2_mdma_resource,
+	.dev            = {
+		.platform_data = &mdma_platform_data,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
+	},
+};
+
+static struct resource mmp2_adma_resource[] = {
+	[0] = {
+		.name   = "reg_phys",
+		.start  = 0xd42a0800,
+		.end    = 0xd42a0800 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.name   = "adma_irq",
+		.start  = IRQ_MMP2_DMA_SECONDARY(18),
+		.end    = IRQ_MMP2_DMA_SECONDARY(21),
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct mmp_tdma_chan_info amda_chan_info[] = {
+	[0] = {
+		.type	  = ADMA1_CH0,
+		.reg_base = 0xd42a0800,
+	},
+	[1] = {
+		.type	  = ADMA1_CH1,
+		.reg_base = 0xd42a0804,
+	},
+	[2] = {
+		.type	  = ADMA2_CH0,
+		.reg_base = 0xd42a0900,
+	},
+	[3] = {
+		.type	  = ADMA2_CH1,
+		.reg_base = 0xd42a0904,
+	},
+};
+
+struct mmp_tdma_platform_data amda_platform_data = {
+	.nr_ch = 4,
+	.info  = amda_chan_info,
+};
+
+static struct platform_device mmp2_device_adma = {
+	.name		= "mmp-adma",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(mmp2_adma_resource),
+	.resource       = mmp2_adma_resource,
+	.dev		= {
+		.platform_data = &amda_platform_data,
+	},
+};
+
+static struct resource mmp2_dmac_resource[] = {
+	[0] = {
+		.name   = "reg_phys",
+		.start  = 0xd4000000,
+		.end    = 0xd4000000 + SZ_1K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+struct pxa_dmac_platform_data dmac_platform_data = {
+	.irq_base = IRQ_MMP2_DMA_BASE,
+	.nr_ch = 16,
+};
+
+static struct platform_device mmp2_device_dmac = {
+	.name           = "pxa-dmac",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(mmp2_dmac_resource),
+	.resource       = mmp2_dmac_resource,
+	.dev            = {
+		.platform_data = &dmac_platform_data,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
+	},
+};
+
 #define MCB_SLFST_SEL		0xD0000570
 #define MCB_SLFST_CTRL2		0xD00005A0
 void __init mmp2_init_mcb(void)
@@ -1178,11 +1294,13 @@ static int __init mmp2_init(void)
 #endif
 		mfp_init_base(MFPR_VIRT_BASE);
 		mfp_init_addr(mmp2_addr_map);
-		pxa_init_dma(IRQ_MMP2_DMA_RIQ, 16);
-		mmp_init_dma(IRQ_MMP2_DMA_RIQ);
 		mmp2_init_mcb();
 		clkdev_add_table(ARRAY_AND_SIZE(mmp2_clkregs));
 		register_syscore_ops(&pxa_audio_syscore_ops);
+
+		platform_device_register(&mmp2_device_dmac);
+		platform_device_register(&mmp2_device_adma);
+		platform_device_register(&mmp2_device_mdma);
 	}
 
 	return 0;
-- 
1.7.0.4

