Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1HZK0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:26:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34585 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1HZK0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:26:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] config: build on the MRST/MID config change
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:21:53 +0100
Message-ID: <20110826102104.16894.85228.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We can now introduce the definitions for the Medfield platform and update the
core bits accordingly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                |   17 +++++++++++++++++
 arch/x86/Kconfig.debug          |    6 +++---
 arch/x86/kernel/early_printk.c  |    2 +-
 arch/x86/platform/mrst/Makefile |    2 +-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ff6d4e7..5c2b225 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -421,6 +421,23 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+config X86_MDFLD
+       bool "Medfield MID platform"
+	depends on PCI
+	depends on PCI_GOANY
+	depends on X86_IO_APIC
+	select APB_TIMER
+	select I2C
+	select SPI
+	select INTEL_SCU_IPC
+	select X86_PLATFORM_DEVICES
+	---help---
+	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
+	  Internet Device(MID) platform. 
+	  Unlike standard x86 PCs, Medfield does not have many legacy devices
+	  nor standard legacy replacement devices/features. e.g. Medfield does
+	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
+
 endif
 
 config X86_RDC321X
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2b00959..b2c7f37 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -43,9 +43,9 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
-config EARLY_PRINTK_MRST
-	bool "Early printk for MRST platform support"
-	depends on EARLY_PRINTK && X86_MRST
+config EARLY_PRINTK_INTEL_MID
+	bool "Early printk for Intel MID platform support"
+	depends on EARLY_PRINTK && X86_INTEL_MID
 
 config EARLY_PRINTK_DBGP
 	bool "Early printk via EHCI debug port"
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cd28a35..7a53da0 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -240,7 +240,7 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
-#ifdef CONFIG_EARLY_PRINTK_MRST
+#ifdef CONFIG_EARLY_PRINTK_INTEL_MID
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index 1ea3877..ddeec73 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 obj-$(CONFIG_X86_MRST)		+= vrtc.o
-obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
+obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_mrst.o
 obj-$(CONFIG_X86_MRST)		+= pmu.o

