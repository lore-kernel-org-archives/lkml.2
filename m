Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2DDBe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:34:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55928 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2DDBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:34:14 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 1/5] ARM: remove ixp23xx and ixp2000 platforms
Date: Tue,  3 Apr 2012 20:33:59 -0500
Message-Id: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

ixp2xxx platforms have had no real changes since ~2006 and the maintainer
has said on irc that they can be removed:

13:05 < nico> do you still care about ixp2000?
13:22 < lennert> not really, no
13:58 < nico> do you think we could remove it from the kernel tree?
14:01 < lennert> go for it, and remove ixp23xx too while you're at it

Removing will help simplify ARM consolidation in general and PCI re-work
specifically.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/arm/00-INDEX                        |    2 -
 Documentation/arm/IXP2000                         |   69 ---
 MAINTAINERS                                       |   17 -
 arch/arm/Kconfig                                  |   26 -
 arch/arm/Makefile                                 |    2 -
 arch/arm/boot/compressed/head-xscale.S            |    7 -
 arch/arm/common/Makefile                          |    2 -
 arch/arm/common/uengine.c                         |  507 --------------------
 arch/arm/configs/ixp2000_defconfig                |   99 ----
 arch/arm/configs/ixp23xx_defconfig                |  105 -----
 arch/arm/include/asm/hardware/uengine.h           |   62 ---
 arch/arm/mach-ixp2000/Kconfig                     |   72 ---
 arch/arm/mach-ixp2000/Makefile                    |   14 -
 arch/arm/mach-ixp2000/Makefile.boot               |    3 -
 arch/arm/mach-ixp2000/core.c                      |  520 ---------------------
 arch/arm/mach-ixp2000/enp2611.c                   |  265 -----------
 arch/arm/mach-ixp2000/include/mach/debug-macro.S  |   25 -
 arch/arm/mach-ixp2000/include/mach/enp2611.h      |   46 --
 arch/arm/mach-ixp2000/include/mach/entry-macro.S  |   54 ---
 arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h |   48 --
 arch/arm/mach-ixp2000/include/mach/hardware.h     |   36 --
 arch/arm/mach-ixp2000/include/mach/io.h           |  133 ------
 arch/arm/mach-ixp2000/include/mach/irqs.h         |  207 --------
 arch/arm/mach-ixp2000/include/mach/ixdp2x00.h     |   92 ----
 arch/arm/mach-ixp2000/include/mach/ixdp2x01.h     |   57 ---
 arch/arm/mach-ixp2000/include/mach/ixp2000-regs.h |  451 ------------------
 arch/arm/mach-ixp2000/include/mach/memory.h       |   31 --
 arch/arm/mach-ixp2000/include/mach/platform.h     |  153 ------
 arch/arm/mach-ixp2000/include/mach/timex.h        |   13 -
 arch/arm/mach-ixp2000/include/mach/uncompress.h   |   47 --
 arch/arm/mach-ixp2000/ixdp2400.c                  |  180 -------
 arch/arm/mach-ixp2000/ixdp2800.c                  |  295 ------------
 arch/arm/mach-ixp2000/ixdp2x00.c                  |  306 ------------
 arch/arm/mach-ixp2000/ixdp2x01.c                  |  483 -------------------
 arch/arm/mach-ixp2000/pci.c                       |  252 ----------
 arch/arm/mach-ixp23xx/Kconfig                     |   25 -
 arch/arm/mach-ixp23xx/Makefile                    |   11 -
 arch/arm/mach-ixp23xx/Makefile.boot               |    2 -
 arch/arm/mach-ixp23xx/core.c                      |  455 ------------------
 arch/arm/mach-ixp23xx/espresso.c                  |   93 ----
 arch/arm/mach-ixp23xx/include/mach/debug-macro.S  |   25 -
 arch/arm/mach-ixp23xx/include/mach/entry-macro.S  |   31 --
 arch/arm/mach-ixp23xx/include/mach/hardware.h     |   32 --
 arch/arm/mach-ixp23xx/include/mach/io.h           |   22 -
 arch/arm/mach-ixp23xx/include/mach/irqs.h         |  223 ---------
 arch/arm/mach-ixp23xx/include/mach/ixdp2351.h     |   89 ----
 arch/arm/mach-ixp23xx/include/mach/ixp23xx.h      |  298 ------------
 arch/arm/mach-ixp23xx/include/mach/memory.h       |   34 --
 arch/arm/mach-ixp23xx/include/mach/platform.h     |   58 ---
 arch/arm/mach-ixp23xx/include/mach/time.h         |    3 -
 arch/arm/mach-ixp23xx/include/mach/timex.h        |    7 -
 arch/arm/mach-ixp23xx/include/mach/uncompress.h   |   40 --
 arch/arm/mach-ixp23xx/ixdp2351.c                  |  347 --------------
 arch/arm/mach-ixp23xx/pci.c                       |  294 ------------
 arch/arm/mach-ixp23xx/roadrunner.c                |  180 -------
 55 files changed, 0 insertions(+), 6950 deletions(-)
 delete mode 100644 Documentation/arm/IXP2000
 delete mode 100644 arch/arm/common/uengine.c
 delete mode 100644 arch/arm/configs/ixp2000_defconfig
 delete mode 100644 arch/arm/configs/ixp23xx_defconfig
 delete mode 100644 arch/arm/include/asm/hardware/uengine.h
 delete mode 100644 arch/arm/mach-ixp2000/Kconfig
 delete mode 100644 arch/arm/mach-ixp2000/Makefile
 delete mode 100644 arch/arm/mach-ixp2000/Makefile.boot
 delete mode 100644 arch/arm/mach-ixp2000/core.c
 delete mode 100644 arch/arm/mach-ixp2000/enp2611.c
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/enp2611.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/io.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixdp2x00.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixdp2x01.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixp2000-regs.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/platform.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2400.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2800.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2x00.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2x01.c
 delete mode 100644 arch/arm/mach-ixp2000/pci.c
 delete mode 100644 arch/arm/mach-ixp23xx/Kconfig
 delete mode 100644 arch/arm/mach-ixp23xx/Makefile
 delete mode 100644 arch/arm/mach-ixp23xx/Makefile.boot
 delete mode 100644 arch/arm/mach-ixp23xx/core.c
 delete mode 100644 arch/arm/mach-ixp23xx/espresso.c
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/ixdp2351.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/ixp23xx.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/platform.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/time.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ixp23xx/ixdp2351.c
 delete mode 100644 arch/arm/mach-ixp23xx/pci.c
 delete mode 100644 arch/arm/mach-ixp23xx/roadrunner.c

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index 91c24a1..36420e1 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -4,8 +4,6 @@ Booting
 	- requirements for booting
 Interrupts
 	- ARM Interrupt subsystem documentation
-IXP2000
-	- Release Notes for Linux on Intel's IXP2000 Network Processor
 msm
 	- MSM specific documentation
 Netwinder
diff --git a/Documentation/arm/IXP2000 b/Documentation/arm/IXP2000
deleted file mode 100644
index 68d21d9..0000000
--- a/Documentation/arm/IXP2000
+++ /dev/null
@@ -1,69 +0,0 @@
-
--------------------------------------------------------------------------
-Release Notes for Linux on Intel's IXP2000 Network Processor
-
-Maintained by Deepak Saxena <dsaxena@plexity.net>
--------------------------------------------------------------------------
-
-1. Overview
-
-Intel's IXP2000 family of NPUs (IXP2400, IXP2800, IXP2850) is designed
-for high-performance network applications such high-availability
-telecom systems. In addition to an XScale core, it contains up to 8
-"MicroEngines" that run special code, several high-end networking 
-interfaces (UTOPIA, SPI, etc), a PCI host bridge, one serial port,
-flash interface, and some other odds and ends. For more information, see:
-
-http://developer.intel.com
-
-2. Linux Support
-
-Linux currently supports the following features on the IXP2000 NPUs:
-
-- On-chip serial
-- PCI
-- Flash (MTD/JFFS2)
-- I2C through GPIO
-- Timers (watchdog, OS)
-
-That is about all we can support under Linux ATM b/c the core networking
-components of the chip are accessed via Intel's closed source SDK. 
-Please contact Intel directly on issues with using those. There is
-also a mailing list run by some folks at Princeton University that might
-be of help:  https://lists.cs.princeton.edu/mailman/listinfo/ixp2xxx
-
-WHATEVER YOU DO, DO NOT POST EMAIL TO THE LINUX-ARM OR LINUX-ARM-KERNEL
-MAILING LISTS REGARDING THE INTEL SDK.
-
-3. Supported Platforms
-
-- Intel IXDP2400 Reference Platform
-- Intel IXDP2800 Reference Platform
-- Intel IXDP2401 Reference Platform
-- Intel IXDP2801 Reference Platform
-- RadiSys ENP-2611
-
-4. Usage Notes
-
-- The IXP2000 platforms usually have rather complex PCI bus topologies
-  with large memory space requirements. In addition, b/c of the way the
-  Intel SDK is designed, devices are enumerated in a very specific
-  way. B/c of this this, we use "pci=firmware" option in the kernel
-  command line so that we do not re-enumerate the bus.
-
-- IXDP2x01 systems have variable clock tick rates that we cannot determine 
-  via HW registers. The "ixdp2x01_clk=XXX" cmd line options allow you
-  to pass the clock rate to the board port.
-
-5. Thanks
-
-The IXP2000 work has been funded by Intel Corp. and MontaVista Software, Inc.
-
-The following people have contributed patches/comments/etc:
-
-Naeem F. Afzal
-Lennert Buytenhek
-Jeffrey Daly
-
--------------------------------------------------------------------------
-Last Update: 8/09/2004
diff --git a/MAINTAINERS b/MAINTAINERS
index eecf344..defc06a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -640,13 +640,6 @@ S:	Maintained
 F:	drivers/amba/
 F:	include/linux/amba/bus.h
 
-ARM/ADI ROADRUNNER MACHINE SUPPORT
-M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-ixp23xx/
-F:	arch/arm/mach-ixp23xx/include/mach/
-
 ARM/ADS SPHERE MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -859,21 +852,11 @@ M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
-ARM/INTEL IXP2000 ARM ARCHITECTURE
-M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
-ARM/INTEL IXP23XX ARM ARCHITECTURE
-M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-
 ARM/INTEL IXP4XX ARM ARCHITECTURE
 M:	Imre Kaloz <kaloz@openwrt.org>
 M:	Krzysztof Halasa <khc@pm.waw.pl>
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9318084..6b242f4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -527,28 +527,6 @@ config ARCH_IOP33X
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
-config ARCH_IXP23XX
- 	bool "IXP23XX-based"
-	depends on MMU
-	select CPU_XSC3
- 	select PCI
-	select ARCH_USES_GETTIMEOFFSET
-	select NEED_MACH_IO_H
-	select NEED_MACH_MEMORY_H
-	help
-	  Support for Intel's IXP23xx (XScale) family of processors.
-
-config ARCH_IXP2000
-	bool "IXP2400/2800-based"
-	depends on MMU
-	select CPU_XSCALE
-	select PCI
-	select ARCH_USES_GETTIMEOFFSET
-	select NEED_MACH_IO_H
-	select NEED_MACH_MEMORY_H
-	help
-	  Support for Intel's IXP2400/2800 (XScale) family of processors.
-
 config ARCH_IXP4XX
 	bool "IXP4xx-based"
 	depends on MMU
@@ -1045,10 +1023,6 @@ source "arch/arm/mach-iop13xx/Kconfig"
 
 source "arch/arm/mach-ixp4xx/Kconfig"
 
-source "arch/arm/mach-ixp2000/Kconfig"
-
-source "arch/arm/mach-ixp23xx/Kconfig"
-
 source "arch/arm/mach-kirkwood/Kconfig"
 
 source "arch/arm/mach-ks8695/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 047a207..a0c40a0 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -149,8 +149,6 @@ machine-$(CONFIG_ARCH_INTEGRATOR)	:= integrator
 machine-$(CONFIG_ARCH_IOP13XX)		:= iop13xx
 machine-$(CONFIG_ARCH_IOP32X)		:= iop32x
 machine-$(CONFIG_ARCH_IOP33X)		:= iop33x
-machine-$(CONFIG_ARCH_IXP2000)		:= ixp2000
-machine-$(CONFIG_ARCH_IXP23XX)		:= ixp23xx
 machine-$(CONFIG_ARCH_IXP4XX)		:= ixp4xx
 machine-$(CONFIG_ARCH_KIRKWOOD)		:= kirkwood
 machine-$(CONFIG_ARCH_KS8695)		:= ks8695
diff --git a/arch/arm/boot/compressed/head-xscale.S b/arch/arm/boot/compressed/head-xscale.S
index aa5ee49..6ab0599 100644
--- a/arch/arm/boot/compressed/head-xscale.S
+++ b/arch/arm/boot/compressed/head-xscale.S
@@ -32,10 +32,3 @@ __XScale_start:
 		bic	r0, r0, #0x1000		@ clear Icache
 		mcr	p15, 0, r0, c1, c0, 0
 
-#ifdef CONFIG_ARCH_IXP2000
-		mov	r1, #-1
-		mov	r0, #0xd6000000
-		str	r1, [r0, #0x14]
-		str	r1, [r0, #0x18]
-#endif
-
diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index 215816f..e8a4e58 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -11,7 +11,5 @@ obj-$(CONFIG_DMABOUNCE)		+= dmabounce.o
 obj-$(CONFIG_SHARP_LOCOMO)	+= locomo.o
 obj-$(CONFIG_SHARP_PARAM)	+= sharpsl_param.o
 obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
-obj-$(CONFIG_ARCH_IXP2000)	+= uengine.o
-obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o

[snip]

The rest of the patch is just deleted files and too big to get thru the
lists, so I cut it out.

Rob
