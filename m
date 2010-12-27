Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0L0SVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 13:21:54 -0500
Received: from mail.colab.de ([195.226.127.114]:41493 "EHLO mail.colab.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0L0SVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:21:53 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.835
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, jochen@scram.de
Subject: [PATCH] sa1100: Update platform device registration
Date: Mon, 27 Dec 2010 19:21:45 +0100
Message-Id: <1293474105-14300-1-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some magic numbers with constants and add interrupt definitions.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/arm/mach-sa1100/generic.c |   41 ++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 3c1fcd6..3555d61 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -163,10 +163,15 @@ static void sa11x0_register_device(struct platform_device *dev, void *data)
 
 static struct resource sa11x0udc_resources[] = {
 	[0] = {
-		.start	= 0x80000000,
-		.end	= 0x8000ffff,
+		.start	= __PREG(Ser0UDCCR),
+		.end	= __PREG(Ser0UDCCR) + 0xffff,
 		.flags	= IORESOURCE_MEM,
 	},
+	[1] = {
+		.start	= IRQ_Ser0UDC,
+		.end	= IRQ_Ser0UDC,
+		.flags	= IORESOURCE_IRQ,
+	},
 };
 
 static u64 sa11x0udc_dma_mask = 0xffffffffUL;
@@ -184,10 +189,15 @@ static struct platform_device sa11x0udc_device = {
 
 static struct resource sa11x0uart1_resources[] = {
 	[0] = {
-		.start	= 0x80010000,
-		.end	= 0x8001ffff,
+		.start	= __PREG(Ser1UTCR0),
+		.end	= __PREG(Ser1UTCR0) + 0xffff,
 		.flags	= IORESOURCE_MEM,
 	},
+	[1] = {
+		.start	= IRQ_Ser1UART,
+		.end	= IRQ_Ser1UART,
+		.flags	= IORESOURCE_IRQ,
+	},
 };
 
 static struct platform_device sa11x0uart1_device = {
@@ -199,10 +209,15 @@ static struct platform_device sa11x0uart1_device = {
 
 static struct resource sa11x0uart3_resources[] = {
 	[0] = {
-		.start	= 0x80050000,
-		.end	= 0x8005ffff,
+		.start	= __PREG(Ser3UTCR0),
+		.end	= __PREG(Ser3UTCR0) + 0xffff,
 		.flags	= IORESOURCE_MEM,
 	},
+	[1] = {
+		.start	= IRQ_Ser3UART,
+		.end	= IRQ_Ser3UART,
+		.flags	= IORESOURCE_IRQ,
+	},
 };
 
 static struct platform_device sa11x0uart3_device = {
@@ -214,10 +229,15 @@ static struct platform_device sa11x0uart3_device = {
 
 static struct resource sa11x0mcp_resources[] = {
 	[0] = {
-		.start	= 0x80060000,
-		.end	= 0x8006ffff,
+		.start	= __PREG(Ser4MCCR0),
+		.end	= __PREG(Ser4MCCR0) + 0xffff,
 		.flags	= IORESOURCE_MEM,
 	},
+	[1] = {
+		.start	= IRQ_Ser4MCP,
+		.end	= IRQ_Ser4MCP,
+		.flags	= IORESOURCE_IRQ,
+	},
 };
 
 static u64 sa11x0mcp_dma_mask = 0xffffffffUL;
@@ -244,6 +264,11 @@ static struct resource sa11x0ssp_resources[] = {
 		.end	= 0x8007ffff,
 		.flags	= IORESOURCE_MEM,
 	},
+	[1] = {
+		.start	= IRQ_Ser4SSP,
+		.end	= IRQ_Ser4SSP,
+		.flags	= IORESOURCE_IRQ,
+	},
 };
 
 static u64 sa11x0ssp_dma_mask = 0xffffffffUL;
-- 
1.7.2.3

