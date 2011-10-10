Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1JJQiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:38:12 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:48510 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1JJQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:38:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/4] ARM: at91/dma: remove platform data from DMA controller
Date: Mon, 10 Oct 2011 18:37:51 +0200
Message-Id: <2b6ff9c8a28c955849f13b90c5ef258ceea19eaa.1318264339.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
References: <1314075338.22120.3.camel@vkoul-udesk3>
 <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
In-Reply-To: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
References: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA controller can deduce its configuration data from
the platform. Remove the platform data and match device
types with the compatible ones.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    9 +--------
 arch/arm/mach-at91/at91sam9rl_devices.c  |    8 +-------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 600bffb..c9b897f 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -38,10 +38,6 @@
 #if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
 static u64 hdmac_dmamask = DMA_BIT_MASK(32);
 
-static struct at_dma_platform_data atdma_pdata = {
-	.nr_channels	= 8,
-};
-
 static struct resource hdmac_resources[] = {
 	[0] = {
 		.start	= AT91_BASE_SYS + AT91_DMA,
@@ -56,12 +52,11 @@ static struct resource hdmac_resources[] = {
 };
 
 static struct platform_device at_hdmac_device = {
-	.name		= "at_hdmac",
+	.name		= "at91sam9g45_dma",
 	.id		= -1,
 	.dev		= {
 				.dma_mask		= &hdmac_dmamask,
 				.coherent_dma_mask	= DMA_BIT_MASK(32),
-				.platform_data		= &atdma_pdata,
 	},
 	.resource	= hdmac_resources,
 	.num_resources	= ARRAY_SIZE(hdmac_resources),
@@ -69,8 +64,6 @@ static struct platform_device at_hdmac_device = {
 
 void __init at91_add_device_hdmac(void)
 {
-	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
-	dma_cap_set(DMA_SLAVE, atdma_pdata.cap_mask);
 	platform_device_register(&at_hdmac_device);
 }
 #else
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index aacb19d..81954f7 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -33,10 +33,6 @@
 #if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
 static u64 hdmac_dmamask = DMA_BIT_MASK(32);
 
-static struct at_dma_platform_data atdma_pdata = {
-	.nr_channels	= 2,
-};
-
 static struct resource hdmac_resources[] = {
 	[0] = {
 		.start	= AT91_BASE_SYS + AT91_DMA,
@@ -51,12 +47,11 @@ static struct resource hdmac_resources[] = {
 };
 
 static struct platform_device at_hdmac_device = {
-	.name		= "at_hdmac",
+	.name		= "at91sam9rl_dma",
 	.id		= -1,
 	.dev		= {
 				.dma_mask		= &hdmac_dmamask,
 				.coherent_dma_mask	= DMA_BIT_MASK(32),
-				.platform_data		= &atdma_pdata,
 	},
 	.resource	= hdmac_resources,
 	.num_resources	= ARRAY_SIZE(hdmac_resources),
@@ -64,7 +59,6 @@ static struct platform_device at_hdmac_device = {
 
 void __init at91_add_device_hdmac(void)
 {
-	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
 	platform_device_register(&at_hdmac_device);
 }
 #else
-- 
1.7.5.4

