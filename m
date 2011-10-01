Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1JATYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:24:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab1JATW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/11] ARM: limit CONFIG_HAVE_IDE to platforms that do
Date: Sat,  1 Oct 2011 21:21:56 +0200
Message-Id: <1317496920-7764-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zGhbVmmPSkN5o2dQpO4G1rCAMtWNlqaRA6he7TIbtuA
 EPXwDYCHuQ3Y6V12ak6pLnJodq6by4ms0YK5fX8J/P5o2Gv+6C
 hzmgUS6w7ZuywNRApZMLu8PRGzeorxHx6LY3HkjSYQjFAw9ojk
 eKahSaVSzF9VKRUIMN6N4+fkWDSaqvpqeyIrXIivH/hQdUqBle
 z6aFTXTi9P9JBXcsuw5NRhb/tIwxa6kGG+A+eoUFe05/aZtusY
 lBkF3fB22J4n1Di7avUa4lGOkVbCmD2v4IGSYYqDXhqLoVcoZV
 ia4U5798Txl2oThtJtqRBYkitfkmuUze5kbKQdwU2GMnWtZ4kv
 AjI4NJ9B99dLtZZEN/vokcVo+pIgpJFQdQEqfoIED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for IDE drivers should not be automatic, since most platforms
cannot actually support any IDE low-level drivers. This partly
reverts 2064c946e "ARM: always select HAVE_IDE" to set this symbol
only when either a PC-style bus (PCI, ISA, PCMCIA) is enabled or
a platform is used that is known to have an existing driver in
drivers/ide.

New platforms should not need this option and just use CONFIG_ATA
with drivers/ata/.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig           |    6 +++++-
 arch/arm/plat-omap/Kconfig |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3445f50..ed69fcd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -3,7 +3,7 @@ config ARM
 	default y
 	select HAVE_AOUT
 	select HAVE_DMA_API_DEBUG
-	select HAVE_IDE
+	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_MEMBLOCK
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
@@ -385,6 +385,7 @@ config ARCH_FOOTBRIDGE
 	select CPU_SA110
 	select FOOTBRIDGE
 	select GENERIC_CLOCKEVENTS
+	select HAVE_IDE
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -632,6 +633,7 @@ config ARCH_PXA
 	select AUTO_ZRELADDR
 	select MULTI_IRQ_HANDLER
 	select ARM_CPU_SUSPEND if PM
+	select HAVE_IDE
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
@@ -672,6 +674,7 @@ config ARCH_RPC
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
 	select ARCH_USES_GETTIMEOFFSET
+	select HAVE_IDE
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -690,6 +693,7 @@ config ARCH_SA1100
 	select HAVE_SCHED_CLOCK
 	select TICK_ONESHOT
 	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_IDE
 	help
 	  Support for StrongARM 11x0 based boards.
 
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index bb8f4a6..5b605a9 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -14,6 +14,7 @@ config ARCH_OMAP1
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select GENERIC_IRQ_CHIP
+	select HAVE_IDE
 	help
 	  "Systems based on omap7xx, omap15xx or omap16xx"
 
-- 
1.7.5.4

