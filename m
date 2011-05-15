Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab1EOLdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:33:40 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59418 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758441Ab1EOLdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:33:39 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 01/15] [Orion] Rename some constants to macros to make code more identical
Date: Sun, 15 May 2011 13:32:40 +0200
Message-Id: <1305459174-25517-2-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing eg 0xffffffff to DMA_BIT_MASK(32) etc allows easier
side by side comparision of identical code which can be consolidated.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c     |    7 ++++---
 arch/arm/mach-kirkwood/common.c |   28 ++++++++++++++--------------
 arch/arm/mach-loki/common.c     |   15 ++++++++-------
 arch/arm/mach-mv78xx0/common.c  |   38 +++++++++++++++++++-------------------
 arch/arm/mach-orion5x/common.c  |   38 +++++++++++++++++++-------------------
 5 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index e06a88f..30c9518 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -19,6 +19,7 @@
 #include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
+#include <linux/serial_8250.h>
 #include <linux/spi/orion_spi.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
@@ -281,7 +282,7 @@ static struct resource dove_uart0_resources[] = {
 
 static struct platform_device dove_uart0 = {
 	.name			= "serial8250",
-	.id			= 0,
+	.id			= PLAT8250_DEV_PLATFORM,
 	.dev			= {
 		.platform_data	= dove_uart0_data,
 	},
@@ -324,7 +325,7 @@ static struct resource dove_uart1_resources[] = {
 
 static struct platform_device dove_uart1 = {
 	.name			= "serial8250",
-	.id			= 1,
+	.id			= PLAT8250_DEV_PLATFORM1,
 	.dev			= {
 		.platform_data	= dove_uart1_data,
 	},
@@ -367,7 +368,7 @@ static struct resource dove_uart2_resources[] = {
 
 static struct platform_device dove_uart2 = {
 	.name			= "serial8250",
-	.id			= 2,
+	.id			= PLAT8250_DEV_PLATFORM2,
 	.dev			= {
 		.platform_data	= dove_uart2_data,
 	},
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 20e71df..4b89eed2 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -79,7 +79,7 @@ static struct orion_ehci_data kirkwood_ehci_data = {
 	.phy_version	= EHCI_PHY_NA,
 };
 
-static u64 ehci_dmamask = 0xffffffffUL;
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
 
 
 /*****************************************************************************
@@ -88,7 +88,7 @@ static u64 ehci_dmamask = 0xffffffffUL;
 static struct resource kirkwood_ehci_resources[] = {
 	{
 		.start	= USB_PHYS_BASE,
-		.end	= USB_PHYS_BASE + 0x0fff,
+		.end	= USB_PHYS_BASE + SZ_4K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.start	= IRQ_KIRKWOOD_USB,
@@ -102,7 +102,7 @@ static struct platform_device kirkwood_ehci = {
 	.id		= 0,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &kirkwood_ehci_data,
 	},
 	.resource	= kirkwood_ehci_resources,
@@ -127,7 +127,7 @@ static struct resource kirkwood_ge00_shared_resources[] = {
 	{
 		.name	= "ge00 base",
 		.start	= GE00_PHYS_BASE + 0x2000,
-		.end	= GE00_PHYS_BASE + 0x3fff,
+		.end	= GE00_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.name	= "ge00 err irq",
@@ -162,7 +162,7 @@ static struct platform_device kirkwood_ge00 = {
 	.num_resources	= 1,
 	.resource	= kirkwood_ge00_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -189,7 +189,7 @@ static struct resource kirkwood_ge01_shared_resources[] = {
 	{
 		.name	= "ge01 base",
 		.start	= GE01_PHYS_BASE + 0x2000,
-		.end	= GE01_PHYS_BASE + 0x3fff,
+		.end	= GE01_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.name	= "ge01 err irq",
@@ -224,7 +224,7 @@ static struct platform_device kirkwood_ge01 = {
 	.num_resources	= 1,
 	.resource	= kirkwood_ge01_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -358,7 +358,7 @@ static struct platform_device kirkwood_sata = {
 	.name		= "sata_mv",
 	.id		= 0,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(kirkwood_sata_resources),
 	.resource	= kirkwood_sata_resources,
@@ -391,14 +391,14 @@ static struct resource mvsdio_resources[] = {
 	},
 };
 
-static u64 mvsdio_dmamask = 0xffffffffUL;
+static u64 mvsdio_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device kirkwood_sdio = {
 	.name		= "mvsdio",
 	.id		= -1,
 	.dev		= {
 		.dma_mask = &mvsdio_dmamask,
-		.coherent_dma_mask = 0xffffffff,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(mvsdio_resources),
 	.resource	= mvsdio_resources,
@@ -518,7 +518,7 @@ static struct resource kirkwood_uart0_resources[] = {
 
 static struct platform_device kirkwood_uart0 = {
 	.name			= "serial8250",
-	.id			= 0,
+	.id			= PLAT8250_DEV_PLATFORM,
 	.dev			= {
 		.platform_data	= kirkwood_uart0_data,
 	},
@@ -562,7 +562,7 @@ static struct resource kirkwood_uart1_resources[] = {
 
 static struct platform_device kirkwood_uart1 = {
 	.name			= "serial8250",
-	.id			= 1,
+	.id			= PLAT8250_DEV_PLATFORM1,
 	.dev			= {
 		.platform_data	= kirkwood_uart1_data,
 	},
@@ -620,8 +620,6 @@ static struct mv_xor_platform_shared_data kirkwood_xor_shared_data = {
 	.dram		= &kirkwood_mbus_dram_info,
 };
 
-static u64 kirkwood_xor_dmamask = DMA_BIT_MASK(32);
-
 
 /*****************************************************************************
  * XOR0
@@ -650,6 +648,8 @@ static struct platform_device kirkwood_xor0_shared = {
 	.resource	= kirkwood_xor0_shared_resources,
 };
 
+static u64 kirkwood_xor_dmamask = DMA_BIT_MASK(32);
+
 static struct resource kirkwood_xor00_resources[] = {
 	[0] = {
 		.start	= IRQ_KIRKWOOD_XOR_00,
diff --git a/arch/arm/mach-loki/common.c b/arch/arm/mach-loki/common.c
index e41e909..4ff4c62 100644
--- a/arch/arm/mach-loki/common.c
+++ b/arch/arm/mach-loki/common.c
@@ -14,6 +14,7 @@
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
 #include <linux/mv643xx_eth.h>
+#include <linux/dma-mapping.h>
 #include <asm/page.h>
 #include <asm/timex.h>
 #include <asm/mach/map.h>
@@ -54,7 +55,7 @@ static struct resource loki_ge0_shared_resources[] = {
 	{
 		.name	= "ge0 base",
 		.start	= GE0_PHYS_BASE + 0x2000,
-		.end	= GE0_PHYS_BASE + 0x3fff,
+		.end	= GE0_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -84,7 +85,7 @@ static struct platform_device loki_ge0 = {
 	.num_resources	= 1,
 	.resource	= loki_ge0_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -111,7 +112,7 @@ static struct resource loki_ge1_shared_resources[] = {
 	{
 		.name	= "ge1 base",
 		.start	= GE1_PHYS_BASE + 0x2000,
-		.end	= GE1_PHYS_BASE + 0x3fff,
+		.end	= GE1_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -141,7 +142,7 @@ static struct platform_device loki_ge1 = {
 	.num_resources	= 1,
 	.resource	= loki_ge1_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -187,7 +188,7 @@ static struct platform_device loki_sas = {
 	.name		= "mvsas",
 	.id		= 0,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(loki_sas_resources),
 	.resource	= loki_sas_resources,
@@ -230,7 +231,7 @@ static struct resource loki_uart0_resources[] = {
 
 static struct platform_device loki_uart0 = {
 	.name			= "serial8250",
-	.id			= 0,
+	.id			= PLAT8250_DEV_PLATFORM,
 	.dev			= {
 		.platform_data	= loki_uart0_data,
 	},
@@ -274,7 +275,7 @@ static struct resource loki_uart1_resources[] = {
 
 static struct platform_device loki_uart1 = {
 	.name			= "serial8250",
-	.id			= 1,
+	.id			= PLAT8250_DEV_PLATFORM1,
 	.dev			= {
 		.platform_data	= loki_uart1_data,
 	},
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index 44fb4e5..c38250d 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -173,7 +173,7 @@ static struct orion_ehci_data mv78xx0_ehci_data = {
 	.phy_version	= EHCI_PHY_NA,
 };
 
-static u64 ehci_dmamask = 0xffffffffUL;
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
 
 
 /*****************************************************************************
@@ -182,7 +182,7 @@ static u64 ehci_dmamask = 0xffffffffUL;
 static struct resource mv78xx0_ehci0_resources[] = {
 	{
 		.start	= USB0_PHYS_BASE,
-		.end	= USB0_PHYS_BASE + 0x0fff,
+		.end	= USB0_PHYS_BASE + SZ_4K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.start	= IRQ_MV78XX0_USB_0,
@@ -196,7 +196,7 @@ static struct platform_device mv78xx0_ehci0 = {
 	.id		= 0,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &mv78xx0_ehci_data,
 	},
 	.resource	= mv78xx0_ehci0_resources,
@@ -215,7 +215,7 @@ void __init mv78xx0_ehci0_init(void)
 static struct resource mv78xx0_ehci1_resources[] = {
 	{
 		.start	= USB1_PHYS_BASE,
-		.end	= USB1_PHYS_BASE + 0x0fff,
+		.end	= USB1_PHYS_BASE + SZ_4K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.start	= IRQ_MV78XX0_USB_1,
@@ -229,7 +229,7 @@ static struct platform_device mv78xx0_ehci1 = {
 	.id		= 1,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &mv78xx0_ehci_data,
 	},
 	.resource	= mv78xx0_ehci1_resources,
@@ -248,7 +248,7 @@ void __init mv78xx0_ehci1_init(void)
 static struct resource mv78xx0_ehci2_resources[] = {
 	{
 		.start	= USB2_PHYS_BASE,
-		.end	= USB2_PHYS_BASE + 0x0fff,
+		.end	= USB2_PHYS_BASE + SZ_4K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.start	= IRQ_MV78XX0_USB_2,
@@ -262,7 +262,7 @@ static struct platform_device mv78xx0_ehci2 = {
 	.id		= 2,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &mv78xx0_ehci_data,
 	},
 	.resource	= mv78xx0_ehci2_resources,
@@ -287,7 +287,7 @@ static struct resource mv78xx0_ge00_shared_resources[] = {
 	{
 		.name	= "ge00 base",
 		.start	= GE00_PHYS_BASE + 0x2000,
-		.end	= GE00_PHYS_BASE + 0x3fff,
+		.end	= GE00_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.name	= "ge err irq",
@@ -322,7 +322,7 @@ static struct platform_device mv78xx0_ge00 = {
 	.num_resources	= 1,
 	.resource	= mv78xx0_ge00_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -349,7 +349,7 @@ static struct resource mv78xx0_ge01_shared_resources[] = {
 	{
 		.name	= "ge01 base",
 		.start	= GE01_PHYS_BASE + 0x2000,
-		.end	= GE01_PHYS_BASE + 0x3fff,
+		.end	= GE01_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -379,7 +379,7 @@ static struct platform_device mv78xx0_ge01 = {
 	.num_resources	= 1,
 	.resource	= mv78xx0_ge01_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -406,7 +406,7 @@ static struct resource mv78xx0_ge10_shared_resources[] = {
 	{
 		.name	= "ge10 base",
 		.start	= GE10_PHYS_BASE + 0x2000,
-		.end	= GE10_PHYS_BASE + 0x3fff,
+		.end	= GE10_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -436,7 +436,7 @@ static struct platform_device mv78xx0_ge10 = {
 	.num_resources	= 1,
 	.resource	= mv78xx0_ge10_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -476,7 +476,7 @@ static struct resource mv78xx0_ge11_shared_resources[] = {
 	{
 		.name	= "ge11 base",
 		.start	= GE11_PHYS_BASE + 0x2000,
-		.end	= GE11_PHYS_BASE + 0x3fff,
+		.end	= GE11_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -506,7 +506,7 @@ static struct platform_device mv78xx0_ge11 = {
 	.num_resources	= 1,
 	.resource	= mv78xx0_ge11_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
@@ -625,7 +625,7 @@ static struct platform_device mv78xx0_sata = {
 	.name		= "sata_mv",
 	.id		= 0,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(mv78xx0_sata_resources),
 	.resource	= mv78xx0_sata_resources,
@@ -669,7 +669,7 @@ static struct resource mv78xx0_uart0_resources[] = {
 
 static struct platform_device mv78xx0_uart0 = {
 	.name			= "serial8250",
-	.id			= 0,
+	.id			= PLAT8250_DEV_PLATFORM,
 	.dev			= {
 		.platform_data	= mv78xx0_uart0_data,
 	},
@@ -713,7 +713,7 @@ static struct resource mv78xx0_uart1_resources[] = {
 
 static struct platform_device mv78xx0_uart1 = {
 	.name			= "serial8250",
-	.id			= 1,
+	.id			= PLAT8250_DEV_PLATFORM1,
 	.dev			= {
 		.platform_data	= mv78xx0_uart1_data,
 	},
@@ -757,7 +757,7 @@ static struct resource mv78xx0_uart2_resources[] = {
 
 static struct platform_device mv78xx0_uart2 = {
 	.name			= "serial8250",
-	.id			= 2,
+	.id			= PLAT8250_DEV_PLATFORM2,
 	.dev			= {
 		.platform_data	= mv78xx0_uart2_data,
 	},
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 986c3bf..d281b19 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -77,7 +77,7 @@ static struct orion_ehci_data orion5x_ehci_data = {
 	.phy_version	= EHCI_PHY_ORION,
 };
 
-static u64 ehci_dmamask = 0xffffffffUL;
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
 
 
 /*****************************************************************************
@@ -100,7 +100,7 @@ static struct platform_device orion5x_ehci0 = {
 	.id		= 0,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &orion5x_ehci_data,
 	},
 	.resource	= orion5x_ehci0_resources,
@@ -133,7 +133,7 @@ static struct platform_device orion5x_ehci1 = {
 	.id		= 1,
 	.dev		= {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &orion5x_ehci_data,
 	},
 	.resource	= orion5x_ehci1_resources,
@@ -147,16 +147,16 @@ void __init orion5x_ehci1_init(void)
 
 
 /*****************************************************************************
- * GigE
+ * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data orion5x_eth_shared_data = {
+struct mv643xx_eth_shared_platform_data orion5x_ge00_shared_data = {
 	.dram		= &orion5x_mbus_dram_info,
 };
 
-static struct resource orion5x_eth_shared_resources[] = {
+static struct resource orion5x_ge00_shared_resources[] = {
 	{
 		.start	= ORION5X_ETH_PHYS_BASE + 0x2000,
-		.end	= ORION5X_ETH_PHYS_BASE + 0x3fff,
+		.end	= ORION5X_ETH_PHYS_BASE + SZ_16K - 1,
 		.flags	= IORESOURCE_MEM,
 	}, {
 		.start	= IRQ_ORION5X_ETH_ERR,
@@ -165,17 +165,17 @@ static struct resource orion5x_eth_shared_resources[] = {
 	},
 };
 
-static struct platform_device orion5x_eth_shared = {
+static struct platform_device orion5x_ge00_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
 	.id		= 0,
 	.dev		= {
-		.platform_data	= &orion5x_eth_shared_data,
+		.platform_data	= &orion5x_ge00_shared_data,
 	},
-	.num_resources	= ARRAY_SIZE(orion5x_eth_shared_resources),
-	.resource	= orion5x_eth_shared_resources,
+	.num_resources	= ARRAY_SIZE(orion5x_ge00_shared_resources),
+	.resource	= orion5x_ge00_shared_resources,
 };
 
-static struct resource orion5x_eth_resources[] = {
+static struct resource orion5x_ge00_resources[] = {
 	{
 		.name	= "eth irq",
 		.start	= IRQ_ORION5X_ETH_SUM,
@@ -188,18 +188,18 @@ static struct platform_device orion5x_eth = {
 	.name		= MV643XX_ETH_NAME,
 	.id		= 0,
 	.num_resources	= 1,
-	.resource	= orion5x_eth_resources,
+	.resource	= orion5x_ge00_resources,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
 void __init orion5x_eth_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &orion5x_eth_shared;
+	eth_data->shared = &orion5x_ge00_shared;
 	orion5x_eth.dev.platform_data = eth_data;
 
-	platform_device_register(&orion5x_eth_shared);
+	platform_device_register(&orion5x_ge00_shared);
 	platform_device_register(&orion5x_eth);
 }
 
@@ -234,7 +234,7 @@ void __init orion5x_eth_switch_init(struct dsa_platform_data *d, int irq)
 
 	d->netdev = &orion5x_eth.dev;
 	for (i = 0; i < d->nr_chips; i++)
-		d->chip[i].mii_bus = &orion5x_eth_shared.dev;
+		d->chip[i].mii_bus = &orion5x_ge00_shared.dev;
 	orion5x_switch_device.dev.platform_data = d;
 
 	platform_device_register(&orion5x_switch_device);
@@ -299,7 +299,7 @@ static struct platform_device orion5x_sata = {
 	.name		= "sata_mv",
 	.id		= 0,
 	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(orion5x_sata_resources),
 	.resource	= orion5x_sata_resources,
@@ -685,7 +685,7 @@ void __init orion5x_init(void)
 	orion5x_id(&dev, &rev, &dev_name);
 	printk(KERN_INFO "Orion ID: %s. TCLK=%d.\n", dev_name, orion5x_tclk);
 
-	orion5x_eth_shared_data.t_clk = orion5x_tclk;
+	orion5x_ge00_shared_data.t_clk = orion5x_tclk;
 	orion5x_spi_plat_data.tclk = orion5x_tclk;
 	orion5x_uart0_data[0].uartclk = orion5x_tclk;
 	orion5x_uart1_data[0].uartclk = orion5x_tclk;
-- 
1.7.4.4

