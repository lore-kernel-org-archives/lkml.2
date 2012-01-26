Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2AZC7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:59:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37228 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2AZC7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:59:07 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org
Subject: [PATCH] irq: make SPARSE_IRQ an optionally hidden option
Date: Wed, 25 Jan 2012 20:58:47 -0600
Message-Id: <1327546727-31681-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

On ARM, we don't want SPARSE_IRQ to be a user visible option. Make
SPARSE_IRQ visible based on MAY_HAVE_SPARSE_IRQ instead of depending
on HAVE_SPARSE_IRQ.

With this, SPARSE_IRQ is not visible on C6X and ARM.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-c6x-dev@linux-c6x.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
---

This is part of an irq include consolidation series for ARM:

http://www.spinics.net/lists/arm-kernel/msg156492.html

Rob

 arch/arm/Kconfig     |    1 -
 arch/c6x/Kconfig     |    2 +-
 arch/powerpc/Kconfig |    2 +-
 arch/sh/Kconfig      |    2 +-
 arch/x86/Kconfig     |    1 -
 kernel/irq/Kconfig   |    5 ++---
 6 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 24626b0..30e7840 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -28,7 +28,6 @@ config ARM
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_SHOW
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 26e67f0..2f58c61 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -11,7 +11,7 @@ config TMS320C6X
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
-	select HAVE_SPARSE_IRQ
+	select SPARSE_IRQ
 	select OF
 	select OF_EARLY_FLATTREE
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1919634..06c1cf0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,7 +133,7 @@ config PPC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_SPARSE_IRQ
+	select MAY_HAVE_SPARSE_IRQ
 	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 3c8db65..21b82a8 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -22,7 +22,7 @@ config SUPERH
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_SPARSE_IRQ
+	select MAY_HAVE_SPARSE_IRQ
 	select IRQ_FORCED_THREADING
 	select RTC_LIB
 	select GENERIC_ATOMIC64
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 864cc6e..fb2da44 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,7 +69,6 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_SPARSE_IRQ
 	select SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 5a38bf4..1f2dece 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -13,7 +13,7 @@ config GENERIC_HARDIRQS
 # Options selectable by the architecture code
 
 # Make sparse irq Kconfig switch below available
-config HAVE_SPARSE_IRQ
+config MAY_HAVE_SPARSE_IRQ
        bool
 
 # Enable the generic irq autoprobe mechanism
@@ -61,8 +61,7 @@ config IRQ_FORCED_THREADING
        bool
 
 config SPARSE_IRQ
-	bool "Support sparse irq numbering"
-	depends on HAVE_SPARSE_IRQ
+	bool "Support sparse irq numbering" if MAY_HAVE_SPARSE_IRQ
 	---help---
 
 	  Sparse irq numbering is useful for distro kernels that want
-- 
1.7.5.4

