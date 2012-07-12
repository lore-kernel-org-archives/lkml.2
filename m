Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161812Ab2GLXeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:34:03 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50446 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161790Ab2GLWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>
Subject: [ 083/187] ARM: Orion: Fix Virtual/Physical mixup with watchdog
Date: Thu, 12 Jul 2012 15:33:59 -0700
Message-Id: <20120712191530.107447221@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 0fa1f0609a0c1fe8b2be3c0089a2cb48f7fda521 upstream.

The orion watchdog is expecting to be passed the physcial address of
the hardware, and will ioremap() it to give a virtual address it will
use as the base address for the hardware. However, when creating the
platform resource record, a virtual address was being used.

Add the necassary #define's so we can pass the physical address as
expected.

Tested on Kirkwood and Orion5x.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h |    1 +
 arch/arm/mach-kirkwood/include/mach/kirkwood.h    |    1 +
 arch/arm/mach-orion5x/include/mach/bridge-regs.h  |    2 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h      |    1 +
 arch/arm/plat-orion/common.c                      |    2 +-
 5 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-kirkwood/include/mach/bridge-regs.h
+++ b/arch/arm/mach-kirkwood/include/mach/bridge-regs.h
@@ -38,6 +38,7 @@
 #define IRQ_MASK_HIGH_OFF	0x0014
 
 #define TIMER_VIRT_BASE		(BRIDGE_VIRT_BASE | 0x0300)
+#define TIMER_PHYS_BASE		(BRIDGE_PHYS_BASE | 0x0300)
 
 #define L2_CONFIG_REG		(BRIDGE_VIRT_BASE | 0x0128)
 #define L2_WRITETHROUGH		0x00000010
--- a/arch/arm/mach-kirkwood/include/mach/kirkwood.h
+++ b/arch/arm/mach-kirkwood/include/mach/kirkwood.h
@@ -80,6 +80,7 @@
 #define  UART1_VIRT_BASE	(DEV_BUS_VIRT_BASE | 0x2100)
 
 #define BRIDGE_VIRT_BASE	(KIRKWOOD_REGS_VIRT_BASE | 0x20000)
+#define BRIDGE_PHYS_BASE	(KIRKWOOD_REGS_PHYS_BASE | 0x20000)
 
 #define CRYPTO_PHYS_BASE	(KIRKWOOD_REGS_PHYS_BASE | 0x30000)
 
--- a/arch/arm/mach-orion5x/include/mach/bridge-regs.h
+++ b/arch/arm/mach-orion5x/include/mach/bridge-regs.h
@@ -35,5 +35,5 @@
 #define MAIN_IRQ_MASK		(ORION5X_BRIDGE_VIRT_BASE | 0x204)
 
 #define TIMER_VIRT_BASE		(ORION5X_BRIDGE_VIRT_BASE | 0x300)
-
+#define TIMER_PHYS_BASE		(ORION5X_BRIDGE_PHYS_BASE | 0x300)
 #endif
--- a/arch/arm/mach-orion5x/include/mach/orion5x.h
+++ b/arch/arm/mach-orion5x/include/mach/orion5x.h
@@ -82,6 +82,7 @@
 #define  UART1_VIRT_BASE		(ORION5X_DEV_BUS_VIRT_BASE | 0x2100)
 
 #define ORION5X_BRIDGE_VIRT_BASE	(ORION5X_REGS_VIRT_BASE | 0x20000)
+#define ORION5X_BRIDGE_PHYS_BASE	(ORION5X_REGS_PHYS_BASE | 0x20000)
 
 #define ORION5X_PCI_VIRT_BASE		(ORION5X_REGS_VIRT_BASE | 0x30000)
 
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -570,7 +570,7 @@ void __init orion_spi_1_init(unsigned lo
 static struct orion_wdt_platform_data orion_wdt_data;
 
 static struct resource orion_wdt_resource =
-		DEFINE_RES_MEM(TIMER_VIRT_BASE, 0x28);
+		DEFINE_RES_MEM(TIMER_PHYS_BASE, 0x28);
 
 static struct platform_device orion_wdt_device = {
 	.name		= "orion_wdt",


