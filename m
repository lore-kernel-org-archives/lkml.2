Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2H1S5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:57:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50766 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab2H1S5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:57:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clkdev: Add default clkdev.h
Date: Tue, 28 Aug 2012 11:56:53 -0700
Message-Id: <1346180213-14963-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ease the deployment of clkdev by providing a default asm/clkdev.h for
use if the arch does not have an include/asm/clkdev.h.

Due to limitations in Kbuild we manually add clkdev.h to all
architectures that don't have one rather than having the header appear
by default.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/alpha/include/asm/Kbuild      |    2 ++
 arch/avr32/include/asm/Kbuild      |    2 ++
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    2 ++
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    2 ++
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/microblaze/include/asm/Kbuild |    2 ++
 arch/mn10300/include/asm/Kbuild    |    2 ++
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    2 ++
 arch/score/include/asm/Kbuild      |    2 ++
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    2 +-
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/Kbuild        |    2 ++
 arch/xtensa/include/asm/Kbuild     |    2 ++
 include/asm-generic/clkdev.h       |   28 ++++++++++++++++++++++++++++
 23 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 include/asm-generic/clkdev.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index e423def..d97d663 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,5 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += clkdev.h
+
 header-y += compiler.h
 header-y += console.h
 header-y += fpu.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 3136628..e3ba7bc 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y	+= clkdev.h
+
 header-y	+= cachectl.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 28b690d..0d3854c 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -8,4 +8,5 @@ header-y += etraxgpio.h
 header-y += rs485.h
 header-y += sync_serial.h
 
+generic-y += clkdev.h
 generic-y += module.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 5be6663..0c8cf8a 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,3 +2,5 @@ include include/asm-generic/Kbuild.asm
 
 header-y += registers.h
 header-y += termios.h
+
+generic-y += clkdev.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 871382d..65902a6 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y	+= clkdev.h
 generic-y	+= module.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 0690642..3364b696 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -7,6 +7,7 @@ header-y += user.h
 generic-y += auxvec.h
 generic-y += bug.h
 generic-y += bugs.h
+generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index d4eb9383..47c545b 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -13,3 +13,5 @@ header-y += ptrace_offsets.h
 header-y += rse.h
 header-y += ucontext.h
 header-y += ustack.h
+
+generiy-y += clkdev.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 871382d..65902a6 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y	+= clkdev.h
 generic-y	+= module.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index a74e5d9..bfe675f 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -2,6 +2,7 @@ include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
 
 generic-y += bitsperlong.h
+generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += device.h
 generic-y += emergency-restart.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index db5294c..153a2a1 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
 header-y  += elf.h
+
+generic-y += clkdev.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index c68e168..0d20f55 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+generic-y += clkdev.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 0922959..7140b6b 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += bug.h
 generic-y += bugs.h
 generic-y += cacheflush.h
 generic-y += checksum.h
+generic-y += clkdev.h
 generic-y += cmpxchg.h
 generic-y += cmpxchg-local.h
 generic-y += cputime.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 4383707..0587f62 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += pdc.h
+generic-y += clkdev.h
 generic-y += word-at-a-time.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 13d6b7b..2767973 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -36,4 +36,5 @@ header-y += ucontext.h
 header-y += unistd.h
 header-y += epapr_hcalls.h
 
+generic-y += clkdev.h
 generic-y += rwsem.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 287d7bb..f18fc79 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -13,3 +13,5 @@ header-y += tape390.h
 header-y += ucontext.h
 header-y += vtoc.h
 header-y += zcrypt.h
+
+generic-y += clkdev.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index b367abd..ec697ae 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
 header-y +=
+
+generic-y += clkdev.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index fbe1cb5..100aa10 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -17,6 +17,7 @@ header-y += uctx.h
 header-y += utrap.h
 header-y += watchdog.h
 
+generic-y += clkdev.h
 generic-y += div64.h
 generic-y += local64.h
 generic-y += irq_regs.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 5bd7199..ea2e8ea 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -8,6 +8,7 @@ header-y += hardwall.h
 
 generic-y += bug.h
 generic-y += bugs.h
+generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += div64.h
 generic-y += emergency-restart.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index fff2435..0f6e7b3 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,4 +1,4 @@
 generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
-generic-y += switch_to.h
+generic-y += switch_to.h clkdev.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 34b789b..123c59a 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += bitsperlong.h
 generic-y += bugs.h
+generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index f9c0d3ba..66e5f0e 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -26,3 +26,5 @@ header-y += vsyscall.h
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
+
+generic-y += clkdev.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c68e168..0d20f55 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+generic-y += clkdev.h
diff --git a/include/asm-generic/clkdev.h b/include/asm-generic/clkdev.h
new file mode 100644
index 0000000..90a32a6
--- /dev/null
+++ b/include/asm-generic/clkdev.h
@@ -0,0 +1,28 @@
+/*
+ *  include/asm-generic/clkdev.h
+ *
+ * Based on the ARM clkdev.h:
+ *  Copyright (C) 2008 Russell King.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper for the clk API to assist looking up a struct clk.
+ */
+#ifndef __ASM_CLKDEV_H
+#define __ASM_CLKDEV_H
+
+#include <linux/slab.h>
+
+struct clk;
+
+static inline int __clk_get(struct clk *clk) { return 1; }
+static inline void __clk_put(struct clk *clk) { }
+
+static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+#endif
-- 
1.7.10.4

