Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab0FBTLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:11:40 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:38191 "EHLO
	smtp-out-182.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758521Ab0FBTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:11:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13236
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC][PATCH 14/26] MIPS: JZ4740: Add Kbuild files
Date: Wed,  2 Jun 2010 21:10:30 +0200
Message-Id: <1275505832-17185-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1275505397-16758-1-git-send-email-lars@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kbuild files for the JZ4740 architecture and adds JZ4740
support to the MIPS Kbuild files.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/Kconfig         |   13 +++++++++++++
 arch/mips/Makefile        |    6 ++++++
 arch/mips/jz4740/Kconfig  |    8 ++++++++
 arch/mips/jz4740/Makefile |   18 ++++++++++++++++++
 4 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/jz4740/Kconfig
 create mode 100644 arch/mips/jz4740/Makefile

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cdaae94..4d44bad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -162,6 +162,18 @@ config MACH_JAZZ
 	 Members include the Acer PICA, MIPS Magnum 4000, MIPS Millennium and
 	 Olivetti M700-10 workstations.
 
+config MACH_JZ4740
+	bool "Ingenic JZ4740 based machines"
+	select SYS_HAS_CPU_MIPS32_R1
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select DMA_NONCOHERENT
+	select IRQ_CPU
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select SYS_HAS_EARLY_PRINTK
+	select HAVE_PWM
+
 config LASAT
 	bool "LASAT Networks platforms"
 	select CEVT_R4K
@@ -686,6 +698,7 @@ endchoice
 source "arch/mips/alchemy/Kconfig"
 source "arch/mips/bcm63xx/Kconfig"
 source "arch/mips/jazz/Kconfig"
+source "arch/mips/jz4740/Kconfig"
 source "arch/mips/lasat/Kconfig"
 source "arch/mips/pmc-sierra/Kconfig"
 source "arch/mips/powertv/Kconfig"
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 0b9c01a..a5cb578 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -659,6 +659,12 @@ else
 load-$(CONFIG_CPU_CAVIUM_OCTEON) 	+= 0xffffffff81100000
 endif
 
+# Ingenic JZ4740
+#
+core-$(CONFIG_MACH_JZ4740)	+= arch/mips/jz4740/
+cflags-$(CONFIG_MACH_JZ4740)	+= -I$(srctree)/arch/mips/include/asm/mach-jz4740
+load-$(CONFIG_MACH_JZ4740)	+= 0xffffffff80010000
+
 cflags-y			+= -I$(srctree)/arch/mips/include/asm/mach-generic
 drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 
diff --git a/arch/mips/jz4740/Kconfig b/arch/mips/jz4740/Kconfig
new file mode 100644
index 0000000..8a5e850
--- /dev/null
+++ b/arch/mips/jz4740/Kconfig
@@ -0,0 +1,8 @@
+choice
+	prompt "Machine type"
+	depends on MACH_JZ4740
+
+endchoice
+
+config HAVE_PWM
+	bool
diff --git a/arch/mips/jz4740/Makefile b/arch/mips/jz4740/Makefile
new file mode 100644
index 0000000..a803ccb
--- /dev/null
+++ b/arch/mips/jz4740/Makefile
@@ -0,0 +1,18 @@
+#
+# Makefile for the Ingenic JZ4740.
+#
+
+# Object file lists.
+
+obj-y += prom.o irq.o time.o reset.o setup.o dma.o \
+	gpio.o clock.o platform.o timer.o pwm.o serial.o
+
+obj-$(CONFIG_DEBUG_FS) += clock-debugfs.o
+
+# board specific support
+
+# PM support
+
+obj-$(CONFIG_PM) += pm.o
+
+EXTRA_CFLAGS += -Werror -Wall
-- 
1.5.6.5

