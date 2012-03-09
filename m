Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030913Ab2CITsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030892Ab2CITsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:41 -0500
Message-Id: <20120309190206.940776414@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ambroz Bizjak <ambrop7@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Nicolas Pitre <nico@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [ 57/95] ARM: orion: Fix USB phy for orion5x.
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 72053353583230952c4b187e110e9da00dfc3afb upstream.

The patch "ARM: orion: Consolidate USB platform setup code.", commit
4fcd3f374a928081d391cd9a570afe3b2c692fdc broke USB on TS-7800 and
other orion5x boards, because the wrong type of PHY was being passed
to the EHCI driver in the platform data. Orion5x needs EHCI_PHY_ORION
and all the others want EHCI_PHY_NA.

Allow the mach- code to tell the generic plat-orion code which USB PHY
enum to place into the platform data.

Version 2: Rebase to v3.3-rc2.

Reported-by: Ambroz Bizjak <ambrop7@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Ambroz Bizjak <ambrop7@gmail.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/mach-dove/common.c               |    3 ++-
 arch/arm/mach-kirkwood/common.c           |    3 ++-
 arch/arm/mach-mv78xx0/common.c            |    3 ++-
 arch/arm/mach-orion5x/common.c            |    4 +++-
 arch/arm/plat-orion/common.c              |    9 ++++-----
 arch/arm/plat-orion/include/plat/common.h |    3 ++-
 6 files changed, 15 insertions(+), 10 deletions(-)

--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -29,6 +29,7 @@
 #include <asm/mach/arch.h>
 #include <linux/irq.h>
 #include <plat/time.h>
+#include <plat/ehci-orion.h>
 #include <plat/common.h>
 #include "common.h"
 
@@ -72,7 +73,7 @@ void __init dove_map_io(void)
 void __init dove_ehci0_init(void)
 {
 	orion_ehci_init(&dove_mbus_dram_info,
-			DOVE_USB0_PHYS_BASE, IRQ_DOVE_USB0);
+			DOVE_USB0_PHYS_BASE, IRQ_DOVE_USB0, EHCI_PHY_NA);
 }
 
 /*****************************************************************************
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -28,6 +28,7 @@
 #include <plat/cache-feroceon-l2.h>
 #include <plat/mvsdio.h>
 #include <plat/orion_nand.h>
+#include <plat/ehci-orion.h>
 #include <plat/common.h>
 #include <plat/time.h>
 #include "common.h"
@@ -74,7 +75,7 @@ void __init kirkwood_ehci_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_USB0;
 	orion_ehci_init(&kirkwood_mbus_dram_info,
-			USB_PHYS_BASE, IRQ_KIRKWOOD_USB);
+			USB_PHYS_BASE, IRQ_KIRKWOOD_USB, EHCI_PHY_NA);
 }
 
 
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -20,6 +20,7 @@
 #include <mach/mv78xx0.h>
 #include <mach/bridge-regs.h>
 #include <plat/cache-feroceon-l2.h>
+#include <plat/ehci-orion.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
 #include <plat/common.h>
@@ -170,7 +171,7 @@ void __init mv78xx0_map_io(void)
 void __init mv78xx0_ehci0_init(void)
 {
 	orion_ehci_init(&mv78xx0_mbus_dram_info,
-			USB0_PHYS_BASE, IRQ_MV78XX0_USB_0);
+			USB0_PHYS_BASE, IRQ_MV78XX0_USB_0, EHCI_PHY_NA);
 }
 
 
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -29,6 +29,7 @@
 #include <mach/hardware.h>
 #include <mach/orion5x.h>
 #include <plat/orion_nand.h>
+#include <plat/ehci-orion.h>
 #include <plat/time.h>
 #include <plat/common.h>
 #include "common.h"
@@ -72,7 +73,8 @@ void __init orion5x_map_io(void)
 void __init orion5x_ehci0_init(void)
 {
 	orion_ehci_init(&orion5x_mbus_dram_info,
-			ORION5X_USB0_PHYS_BASE, IRQ_ORION5X_USB0_CTRL);
+			ORION5X_USB0_PHYS_BASE, IRQ_ORION5X_USB0_CTRL,
+			EHCI_PHY_ORION);
 }
 
 
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -806,10 +806,7 @@ void __init orion_xor1_init(unsigned lon
 /*****************************************************************************
  * EHCI
  ****************************************************************************/
-static struct orion_ehci_data orion_ehci_data = {
-	.phy_version	= EHCI_PHY_NA,
-};
-
+static struct orion_ehci_data orion_ehci_data;
 static u64 ehci_dmamask = DMA_BIT_MASK(32);
 
 
@@ -830,9 +827,11 @@ static struct platform_device orion_ehci
 
 void __init orion_ehci_init(struct mbus_dram_target_info *mbus_dram_info,
 			    unsigned long mapbase,
-			    unsigned long irq)
+			    unsigned long irq,
+			    enum orion_ehci_phy_ver phy_version)
 {
 	orion_ehci_data.dram = mbus_dram_info;
+	orion_ehci_data.phy_version = phy_version;
 	fill_resources(&orion_ehci, orion_ehci_resources, mapbase, SZ_4K - 1,
 		       irq);
 
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -95,7 +95,8 @@ void __init orion_xor1_init(unsigned lon
 
 void __init orion_ehci_init(struct mbus_dram_target_info *mbus_dram_info,
 			    unsigned long mapbase,
-			    unsigned long irq);
+			    unsigned long irq,
+			    enum orion_ehci_phy_ver phy_version);
 
 void __init orion_ehci_1_init(struct mbus_dram_target_info *mbus_dram_info,
 			      unsigned long mapbase,


