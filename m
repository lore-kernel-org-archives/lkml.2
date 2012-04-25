Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2DYL2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:28:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:33063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2DYL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:28:49 -0400
Message-Id: <20120425112244.894997253@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 25 Apr 2012 13:15:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] math128: Introduce {mult,add,cmp}_u128
References: <20120425111552.665217867@chello.nl>
Content-Disposition: inline; filename=math128.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grow rudimentary u128 support without relying on gcc/libgcc.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/Kbuild      |    1 
 arch/arm/include/asm/Kbuild        |    1 
 arch/avr32/include/asm/Kbuild      |    1 
 arch/blackfin/include/asm/Kbuild   |    1 
 arch/c6x/include/asm/Kbuild        |    1 
 arch/cris/include/asm/Kbuild       |    1 
 arch/frv/include/asm/Kbuild        |    1 
 arch/h8300/include/asm/Kbuild      |    1 
 arch/hexagon/include/asm/Kbuild    |    1 
 arch/ia64/include/asm/Kbuild       |    1 
 arch/m32r/include/asm/Kbuild       |    1 
 arch/m68k/include/asm/Kbuild       |    1 
 arch/microblaze/include/asm/Kbuild |    1 
 arch/mips/include/asm/Kbuild       |    1 
 arch/mn10300/include/asm/Kbuild    |    1 
 arch/openrisc/include/asm/Kbuild   |    1 
 arch/parisc/include/asm/Kbuild     |    1 
 arch/powerpc/include/asm/Kbuild    |    1 
 arch/s390/include/asm/Kbuild       |    1 
 arch/score/include/asm/Kbuild      |    1 
 arch/sh/include/asm/Kbuild         |    1 
 arch/sparc/include/asm/Kbuild      |    1 
 arch/tile/include/asm/Kbuild       |    1 
 arch/um/include/asm/Kbuild         |    1 
 arch/unicore32/include/asm/Kbuild  |    1 
 arch/x86/include/asm/Kbuild        |    1 
 arch/xtensa/include/asm/Kbuild     |    1 
 include/asm-generic/math128.h      |    4 
 include/linux/math128.h            |  173 +++++++++++++++++++++++++++++++++++++
 lib/Makefile                       |    2 
 lib/math128.c                      |   40 ++++++++
 31 files changed, 245 insertions(+), 1 deletion(-)

--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -8,3 +8,4 @@ header-y += pal.h
 header-y += reg.h
 header-y += regdef.h
 header-y += sysinfo.h
+generic-y += math128.h
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -18,3 +18,4 @@ generic-y += resource.h
 generic-y += sections.h
 generic-y += siginfo.h
 generic-y += sizes.h
+generic-y += math128.h
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y	+= cachectl.h
+generic-y += math128.h
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -47,3 +47,4 @@ generic-y += xor.h
 header-y += bfin_sport.h
 header-y += cachectl.h
 header-y += fixed_code.h
+generic-y += math128.h
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -51,3 +51,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
+generic-y += math128.h
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -8,3 +8,4 @@ header-y += etraxgpio.h
 header-y += rs485.h
 header-y += rtc.h
 header-y += sync_serial.h
+generic-y += math128.h
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,3 +2,4 @@ include include/asm-generic/Kbuild.asm
 
 header-y += registers.h
 header-y += termios.h
+generic-y += math128.h
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+generic-y += math128.h
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -56,3 +56,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
+generic-y += math128.h
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -12,3 +12,4 @@ header-y += ptrace_offsets.h
 header-y += rse.h
 header-y += ucontext.h
 header-y += ustack.h
+generic-y += math128.h
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+generic-y += math128.h
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,2 +1,3 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
+generic-y += math128.h
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y  += elf.h
+generic-y += math128.h
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
 header-y += sgidefs.h
 header-y += sysmips.h
+generic-y += math128.h
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+generic-y += math128.h
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -65,3 +65,4 @@ generic-y += topology.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
+generic-y += math128.h
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += pdc.h
+generic-y += math128.h
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -36,3 +36,4 @@ header-y += ucontext.h
 header-y += unistd.h
 
 generic-y += rwsem.h
+generic-y += math128.h
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -13,3 +13,4 @@ header-y += tape390.h
 header-y += ucontext.h
 header-y += vtoc.h
 header-y += zcrypt.h
+generic-y += math128.h
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y +=
+generic-y += math128.h
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -9,3 +9,4 @@ header-y += ptrace_32.h
 header-y += ptrace_64.h
 header-y += unistd_32.h
 header-y += unistd_64.h
+generic-y += math128.h
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -21,3 +21,4 @@ generic-y += div64.h
 generic-y += local64.h
 generic-y += irq_regs.h
 generic-y += local.h
+generic-y += math128.h
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -42,3 +42,4 @@ generic-y += termios.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += xor.h
+generic-y += math128.h
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -2,3 +2,4 @@ generic-y += bug.h cputime.h device.h em
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h
+generic-y += math128.h
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -58,3 +58,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += math128.h
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -26,3 +26,4 @@ header-y += vsyscall.h
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
+generic-y += math128.h
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+generic-y += math128.h
--- /dev/null
+++ b/include/asm-generic/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_GENERIC_MATH128_H
+#define _ASM_GENERIC_MATH128_H
+
+#endif /*_ASM_GENERIC_MATH128_H */
--- /dev/null
+++ b/include/linux/math128.h
@@ -0,0 +1,173 @@
+#ifndef _LINUX_MATH128_H
+#define _LINUX_MATH128_H
+
+#include <linux/types.h>
+
+typedef union {
+	struct {
+#if __BYTE_ORDER__  == __ORDER_LITTLE_ENDIAN__
+		u64 lo, hi;
+#else
+		u64 hi, lo;
+#endif
+	};
+#ifdef __SIZEOF_INT128__ /* gcc-4.6+ */
+	unsigned __int128 val;
+#endif
+} u128;
+
+#define U128_INIT(_hi, _lo) (u128){{ .hi = (_hi), .lo = (_lo) }}
+
+#include <asm/math128.h>
+
+/*
+ * Make usage of __int128 dependent on arch code so they can
+ * judge if gcc is doing the right thing for them and can over-ride
+ * any funnies.
+ */
+
+#ifndef ARCH_HAS_INT128
+
+#ifndef add_u128
+static inline u128 add_u128(u128 a, u128 b)
+{
+	a.lo += b.lo;
+	if (a.lo < b.lo)
+		a.hi++;
+
+	return a;
+}
+#endif /* add_u128 */
+
+#ifndef mul_u64_u64
+extern u128 mul_u64_u64(u64 a, u64 b);
+#endif
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	u32 ah, al;
+	u64 t1, t2;
+
+	ah = a >> 32;
+	al = a;
+
+	t1 = ((u64)al * mul) >> shift;
+	t2 = ((u64)ah * mul) << (32 - shift);
+
+	return t1 + t2;
+}
+#endif /* mul_u64_u32_shr */
+
+#ifndef shl_u128
+static inline u128 shl_u128(u128 x, unsigned int n)
+{
+	u128 res;
+
+	if (n < 64) {
+		res.hi = x.hi << n;
+		res.hi |= x.lo >> (64 - n);
+		res.lo = x.lo << n;
+	} else {
+		res.lo = 0;
+		res.hi = x.lo << (n - 64);
+	}
+
+	return res;
+}
+#endif /* shl_u128 */
+
+#ifndef shr_u128
+static inline u128 shr_u128(u128 x, unsigned int n)
+{
+	u128 res;
+
+	if (n < 64) {
+		res.lo = x.lo >> n;
+		res.lo |= x.hi << (64 - n);
+		res.hi = x.hi >> n;
+	} else {
+		res.hi = 0;
+		res.lo = x.hi >> (n - 64);
+	}
+
+	return res;
+}
+#endif /* shr_u128 */
+
+#ifndef cmp_u128
+static inline int cmp_u128(u128 a, u128 b)
+{
+	if (a.hi > b.hi)
+		return 1;
+	if (a.hi < b.hi)
+		return -1;
+	if (a.lo > b.lo)
+		return 1;
+	if (a.lo < b.lo)
+		return -1;
+
+	return 0;
+}
+#endif /* cmp_u128 */
+
+#else /* ARCH_HAS_INT128 */
+
+#ifndef add_u128
+static inline u128 add_u128(u128 a, u128 b)
+{
+	a.val += b.val;
+	return a;
+}
+#endif /* add_u128 */
+
+#ifndef mul_u64_u64
+static inline u128 mul_u64_u64(u64 a, u64 b)
+{
+	u128 res;
+
+	res.val = a;
+	res.val *= b;
+
+	return res;
+}
+#define mul_u64_u64 mul_u64_u64
+#endif
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	return (u64)(((unsigned __int128)a * mul) >> shift);
+}
+#endif /* mul_u64_u32_shr */
+
+#ifndef shl_u128
+static inline u128 shl_u128(u128 x, unsigned int n)
+{
+	x.val <<= n;
+	return x;
+}
+#endif /* shl_u128 */
+
+#ifndef shr_u128
+static inline u128 shr_u128(u128 x, unsigned int n)
+{
+	x.val >>= n;
+	return x;
+}
+#endif /* shr_u128 */
+
+#ifndef cmp_u128
+static inline int cmp_u128(u128 a, u128 b)
+{
+	if (a.val < b.val)
+		return -1;
+	if (a.val > b.val)
+		return 1;
+	return 0;
+}
+#endif /* cmp_u128 */
+
+#endif /* ARCH_HAS_INT128 */
+
+#endif /* _LINUX_MATH128_H */
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o math128.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
--- /dev/null
+++ b/lib/math128.c
@@ -0,0 +1,40 @@
+#include <linux/math128.h>
+
+#ifndef mult_u64_u64
+/*
+ * a * b = (ah * 2^32 + al) * (bh * 2^32 + bl) =
+ *   ah*bh * 2^64 + (ah*bl + bh*al) * 2^32 + al*bl
+ */
+u128 mult_u64_u64(u64 a, u64 b)
+{
+	u128 t1, t2, t3, t4;
+	u32 ah, al;
+	u32 bh, bl;
+
+	ah = a >> 32;
+	al = a;
+
+	bh = b >> 32;
+	bl = b;
+
+	t1.lo = 0;
+	t1.hi = (u64)ah * bh;
+
+	t2.lo = (u64)ah * bl;
+	t2.hi = t2.lo >> 32;
+	t2.lo <<= 32;
+
+	t3.lo = (u64)al * bh;
+	t3.hi = t3.lo >> 32;
+	t3.lo <<= 32;
+
+	t4.lo = (u64)al * bl;
+	t4.hi = 0;
+
+	t1 = add_u128(t1, t2);
+	t1 = add_u128(t1, t3);
+	t1 = add_u128(t1, t4);
+
+	return t1;
+}
+#endif /* mult_u128 */


