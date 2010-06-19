Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0FSFKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:10:31 -0400
Received: from smtp-out-037.synserver.de ([212.40.180.37]:1036 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754579Ab0FSFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:10:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13414
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 14/26] MIPS: JZ4740: Add Kbuild files
Date: Sat, 19 Jun 2010 07:08:19 +0200
Message-Id: <1276924111-11158-15-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1276924111-11158-1-git-send-email-lars@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kbuild files for the JZ4740 architecture and adds JZ4740
support to the MIPS Kbuild files.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1
- Adjust to MIPS Kbuild changes
---
 arch/mips/Kbuild.platforms |    1 +
 arch/mips/Kconfig          |   13 +++++++++++++
 arch/mips/jz4740/Kconfig   |    8 ++++++++
 arch/mips/jz4740/Makefile  |   18 ++++++++++++++++++
 arch/mips/jz4740/Platform  |    5 +++++
 5 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/jz4740/Kconfig
 create mode 100644 arch/mips/jz4740/Makefile
 create mode 100644 arch/mips/jz4740/Platform

diff --git a/arch/mips/Kbuild.platforms b/arch/mips/Kbuild.platforms
index ea3b96c..78439b8 100644
--- a/arch/mips/Kbuild.platforms
+++ b/arch/mips/Kbuild.platforms
@@ -9,6 +9,7 @@ platforms += cobalt
 platforms += dec
 platforms += emma
 platforms += jazz
+platforms += jz4740
 platforms += lasat
 platforms += loongson
 platforms += mipssim
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
diff --git a/arch/mips/jz4740/Platform b/arch/mips/jz4740/Platform
new file mode 100644
index 0000000..540bb35
--- /dev/null
+++ b/arch/mips/jz4740/Platform
@@ -0,0 +1,3 @@
+core-$(CONFIG_MACH_JZ4740)	+= arch/mips/jz4740/
+cflags-$(CONFIG_MACH_JZ4740)	+= -I$(srctree)/arch/mips/include/asm/mach-jz4740
+load-$(CONFIG_MACH_JZ4740)	+= 0xffffffff80010000
-- 
1.5.6.5

