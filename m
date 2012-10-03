Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab2JCPTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:19:44 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36937 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab2JCPNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:54 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 11:13:53 EDT
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/25] sh: convert boards to use the OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:18 +0200
Message-Id: <1349276601-8371-24-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/sh/kernel/cpu/sh3/setup-sh7720.c  |    6 +++++-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    6 +++++-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c |    6 +++++-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    6 +++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh3/setup-sh7720.c b/arch/sh/kernel/cpu/sh3/setup-sh7720.c
index 0c2f1b2..42d991f 100644
--- a/arch/sh/kernel/cpu/sh3/setup-sh7720.c
+++ b/arch/sh/kernel/cpu/sh3/setup-sh7720.c
@@ -20,6 +20,7 @@
 #include <linux/serial_sci.h>
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
+#include <linux/usb/ohci_pdriver.h>
 #include <asm/rtc.h>
 #include <cpu/serial.h>
 
@@ -103,12 +104,15 @@ static struct resource usb_ohci_resources[] = {
 
 static u64 usb_ohci_dma_mask = 0xffffffffUL;
 
+static struct usb_ohci_pdata usb_ohci_pdata;
+
 static struct platform_device usb_ohci_device = {
-	.name		= "sh_ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &usb_ohci_dma_mask,
 		.coherent_dma_mask	= 0xffffffff,
+		.platform_data		= &usb_ohci_pdata,
 	},
 	.num_resources	= ARRAY_SIZE(usb_ohci_resources),
 	.resource	= usb_ohci_resources,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
index 4a2f357..9079a0f 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -19,6 +19,7 @@
 #include <linux/sh_timer.h>
 #include <linux/sh_dma.h>
 #include <linux/sh_intc.h>
+#include <linux/usb/ohci_pdriver.h>
 #include <cpu/dma-register.h>
 #include <cpu/sh7757.h>
 
@@ -750,12 +751,15 @@ static struct resource usb_ohci_resources[] = {
 	},
 };
 
+static struct usb_ohci_pdata usb_ohci_pdata;
+
 static struct platform_device usb_ohci_device = {
-	.name		= "sh_ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
 	.dev = {
 		.dma_mask = &usb_ohci_device.dev.coherent_dma_mask,
 		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.platform_data	= &usb_ohci_pdata,
 	},
 	.num_resources	= ARRAY_SIZE(usb_ohci_resources),
 	.resource	= usb_ohci_resources,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7763.c b/arch/sh/kernel/cpu/sh4a/setup-sh7763.c
index bd0a8fb..1686aca 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7763.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7763.c
@@ -16,6 +16,7 @@
 #include <linux/sh_intc.h>
 #include <linux/io.h>
 #include <linux/serial_sci.h>
+#include <linux/usb/ohci_pdriver.h>
 
 static struct plat_sci_port scif0_platform_data = {
 	.mapbase	= 0xffe00000,
@@ -106,12 +107,15 @@ static struct resource usb_ohci_resources[] = {
 
 static u64 usb_ohci_dma_mask = 0xffffffffUL;
 
+static struct usb_ohci_pdata usb_ohci_pdata;
+
 static struct platform_device usb_ohci_device = {
-	.name		= "sh_ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &usb_ohci_dma_mask,
 		.coherent_dma_mask	= 0xffffffff,
+		.platform_data		= &usb_ohci_pdata,
 	},
 	.num_resources	= ARRAY_SIZE(usb_ohci_resources),
 	.resource	= usb_ohci_resources,
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
index 2e6952f..ab52d4d 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -23,6 +23,7 @@
 #include <linux/sh_timer.h>
 #include <linux/sh_dma.h>
 #include <linux/sh_intc.h>
+#include <linux/usb/ohci_pdriver.h>
 #include <cpu/dma-register.h>
 #include <asm/mmzone.h>
 
@@ -583,12 +584,15 @@ static struct resource usb_ohci_resources[] = {
 	},
 };
 
+static struct usb_ohci_pdata usb_ohci_pdata;
+
 static struct platform_device usb_ohci_device = {
-	.name		= "sh_ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &usb_ohci_device.dev.coherent_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &usb_ohci_pdata,
 	},
 	.num_resources	= ARRAY_SIZE(usb_ohci_resources),
 	.resource	= usb_ohci_resources,
-- 
1.7.9.5

