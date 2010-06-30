Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0F3P5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:57:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39745 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab0F3P5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:57:48 -0400
Date: Wed, 30 Jun 2010 17:57:45 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 12/33] Removing dead OMAP_STI
Message-ID: <35d3c6a25b5cc05a5eee3037075ccede85b1917f.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_STI doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/devices.c |   35 -------------------------
 arch/arm/mach-omap2/devices.c |   57 -----------------------------------------
 2 files changed, 0 insertions(+), 92 deletions(-)

diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index c00d602..aa07256 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -193,42 +193,7 @@ static inline void omap_init_spi100k(void)
 
 /*-------------------------------------------------------------------------*/
 
-#if defined(CONFIG_OMAP_STI)
-
-#define OMAP1_STI_BASE		0xfffea000
-#define OMAP1_STI_CHANNEL_BASE	(OMAP1_STI_BASE + 0x400)
-
-static struct resource sti_resources[] = {
-	{
-		.start		= OMAP1_STI_BASE,
-		.end		= OMAP1_STI_BASE + SZ_1K - 1,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP1_STI_CHANNEL_BASE,
-		.end		= OMAP1_STI_CHANNEL_BASE + SZ_1K - 1,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= INT_1610_STI,
-		.flags		= IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device sti_device = {
-	.name		= "sti",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(sti_resources),
-	.resource	= sti_resources,
-};
-
-static inline void omap_init_sti(void)
-{
-	platform_device_register(&sti_device);
-}
-#else
 static inline void omap_init_sti(void) {}
-#endif
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 03e6c9e..b9c1f98 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -230,64 +230,7 @@ static inline void omap_init_mbox(void)
 static inline void omap_init_mbox(void) { }
 #endif /* CONFIG_OMAP_MBOX_FWK */
 
-#if defined(CONFIG_OMAP_STI)
-
-#if defined(CONFIG_ARCH_OMAP2)
-
-#define OMAP2_STI_BASE		0x48068000
-#define OMAP2_STI_CHANNEL_BASE	0x54000000
-#define OMAP2_STI_IRQ		4
-
-static struct resource sti_resources[] = {
-	{
-		.start		= OMAP2_STI_BASE,
-		.end		= OMAP2_STI_BASE + 0x7ff,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP2_STI_CHANNEL_BASE,
-		.end		= OMAP2_STI_CHANNEL_BASE + SZ_64K - 1,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP2_STI_IRQ,
-		.flags		= IORESOURCE_IRQ,
-	}
-};
-#elif defined(CONFIG_ARCH_OMAP3)
-
-#define OMAP3_SDTI_BASE		0x54500000
-#define OMAP3_SDTI_CHANNEL_BASE	0x54600000
-
-static struct resource sti_resources[] = {
-	{
-		.start		= OMAP3_SDTI_BASE,
-		.end		= OMAP3_SDTI_BASE + 0xFFF,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3_SDTI_CHANNEL_BASE,
-		.end		= OMAP3_SDTI_CHANNEL_BASE + SZ_1M - 1,
-		.flags		= IORESOURCE_MEM,
-	}
-};
-
-#endif
-
-static struct platform_device sti_device = {
-	.name		= "sti",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(sti_resources),
-	.resource	= sti_resources,
-};
-
-static inline void omap_init_sti(void)
-{
-	platform_device_register(&sti_device);
-}
-#else
 static inline void omap_init_sti(void) {}
-#endif
 
 #if defined(CONFIG_SPI_OMAP24XX) || defined(CONFIG_SPI_OMAP24XX_MODULE)
 
-- 
1.7.0.4

