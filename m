Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2EaPj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:39:28 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:57725 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2EaPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:39:24 -0400
Date: Thu, 31 May 2012 17:39:17 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.5 merge window
Message-ID: <20120531153917.GA3090@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053115-1948-0000-0000-000001F62423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive a couple of s390 patches for the 3.5 merge window.
Just a collection of bug fixes and cleanups.

Thanks,
Heiko

Heiko Carstens (9):
      s390/headers: remove #ifdef __KERNEL__ from not exported headers
      s390/headers: replace __s390x__ with CONFIG_64BIT where possible
      s390/cpu: remove cpu "capabilities" sysfs attribute
      s390/cmpxchg: add missing memory barrier to cmpxchg64
      s390/cmpxchg: fix compile warnings specific to s390
      s390/cmpxchg: fix 1 and 2 byte memory accesses
      s390/cmpxchg: fix sign extension bugs
      s390/cmpxchg: select HAVE_CMPXCHG_LOCAL option
      s390/uaccess: fix access_ok compile warnings

Hendrik Brueckner (1):
      s390/irq: split irq stats for cpu-measurement alert facilities

Michael Holzheu (6):
      s390/kernel: Remove OS info init function call and diag 308 for kdump
      s390/kdump: Account /sys/kernel/kexec_crash_size changes in OS info
      s390/kdump: Use real mode for PSW restart and kexec
      s390/kexec: Move early_pgm_check_handler() to text section
      s390/kernel: Introduce memcpy_absolute() function
      s390/kernel: Fix smp_call_ipl_cpu() for offline CPUs

 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/bitops.h      |   21 ++++-------
 arch/s390/include/asm/cio.h         |    4 --
 arch/s390/include/asm/cmpxchg.h     |   54 ++++++++++++++++++++----------
 arch/s390/include/asm/cputime.h     |   10 +++---
 arch/s390/include/asm/ctl_reg.h     |    6 ++--
 arch/s390/include/asm/current.h     |    3 --
 arch/s390/include/asm/elf.h         |   12 +++---
 arch/s390/include/asm/futex.h       |    3 --
 arch/s390/include/asm/idals.h       |   10 +++---
 arch/s390/include/asm/io.h          |    4 --
 arch/s390/include/asm/irq.h         |    3 +-
 arch/s390/include/asm/kexec.h       |    4 +--
 arch/s390/include/asm/kmap_types.h  |    2 -
 arch/s390/include/asm/mmu_context.h |    2 +-
 arch/s390/include/asm/module.h      |    2 +-
 arch/s390/include/asm/os_info.h     |    5 +--
 arch/s390/include/asm/percpu.h      |    2 +-
 arch/s390/include/asm/pgalloc.h     |    6 ++--
 arch/s390/include/asm/pgtable.h     |   44 ++++++++++++------------
 arch/s390/include/asm/processor.h   |   39 ++++++++-------------
 arch/s390/include/asm/rwsem.h       |   63 ++++++++++++++++------------------
 arch/s390/include/asm/setup.h       |   18 +++++-----
 arch/s390/include/asm/sfp-util.h    |    2 +-
 arch/s390/include/asm/string.h      |    4 --
 arch/s390/include/asm/thread_info.h |   10 ++----
 arch/s390/include/asm/timer.h       |    4 --
 arch/s390/include/asm/tlb.h         |    4 +-
 arch/s390/include/asm/tlbflush.h    |    4 +-
 arch/s390/include/asm/types.h       |    4 +-
 arch/s390/include/asm/uaccess.h     |   15 +++++---
 arch/s390/include/asm/vdso.h        |    5 ---
 arch/s390/kernel/base.S             |   12 +++++++
 arch/s390/kernel/early.c            |    2 +-
 arch/s390/kernel/head_kdump.S       |    7 ----
 arch/s390/kernel/ipl.c              |   16 +++++---
 arch/s390/kernel/irq.c              |    3 +-
 arch/s390/kernel/machine_kexec.c    |   11 +++++-
 arch/s390/kernel/os_info.c          |    3 +-
 arch/s390/kernel/perf_cpum_cf.c     |    2 +-
 arch/s390/kernel/setup.c            |   12 ++++---
 arch/s390/kernel/smp.c              |   45 +++++-------------------
 arch/s390/kernel/sysinfo.c          |   21 -----------
 arch/s390/lib/uaccess_mvcos.c       |    2 +-
 arch/s390/lib/uaccess_std.c         |    2 +-
 arch/s390/mm/maccess.c              |   38 +++++++++------------
 arch/s390/mm/vmem.c                 |    2 +-
 arch/s390/oprofile/hwsampler.c      |    2 +-
 drivers/s390/block/dasd_int.h       |    4 --
 drivers/s390/char/sclp_sdias.c      |    2 +-
 50 files changed, 245 insertions(+), 311 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e16390c..57c86da 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
+	select HAVE_CMPXCHG_LOCAL
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index e5beb49..a6ff5a8 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -13,8 +13,6 @@
  *
  */
 
-#ifdef __KERNEL__
-
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
@@ -63,7 +61,7 @@ extern const char _ni_bitmap[];
 extern const char _zb_findmap[];
 extern const char _sb_findmap[];
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 #define __BITOPS_ALIGN		3
 #define __BITOPS_WORDSIZE	32
@@ -83,7 +81,7 @@ extern const char _sb_findmap[];
 		: "d" (__val), "Q" (*(unsigned long *) __addr)	\
 		: "cc");
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 #define __BITOPS_ALIGN		7
 #define __BITOPS_WORDSIZE	64
@@ -103,7 +101,7 @@ extern const char _sb_findmap[];
 		: "d" (__val), "Q" (*(unsigned long *) __addr)	\
 		: "cc");
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define __BITOPS_WORDS(bits) (((bits)+__BITOPS_WORDSIZE-1)/__BITOPS_WORDSIZE)
 #define __BITOPS_BARRIER() asm volatile("" : : : "memory")
@@ -412,7 +410,7 @@ static inline unsigned long __ffz_word_loop(const unsigned long *addr,
 	unsigned long bytes = 0;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	ahi	%1,-1\n"
 		"	sra	%1,5\n"
 		"	jz	1f\n"
@@ -449,7 +447,7 @@ static inline unsigned long __ffs_word_loop(const unsigned long *addr,
 	unsigned long bytes = 0;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	ahi	%1,-1\n"
 		"	sra	%1,5\n"
 		"	jz	1f\n"
@@ -481,7 +479,7 @@ static inline unsigned long __ffs_word_loop(const unsigned long *addr,
  */
 static inline unsigned long __ffz_word(unsigned long nr, unsigned long word)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if ((word & 0xffffffff) == 0xffffffff) {
 		word >>= 32;
 		nr += 32;
@@ -505,7 +503,7 @@ static inline unsigned long __ffz_word(unsigned long nr, unsigned long word)
  */
 static inline unsigned long __ffs_word(unsigned long nr, unsigned long word)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if ((word & 0xffffffff) == 0) {
 		word >>= 32;
 		nr += 32;
@@ -546,7 +544,7 @@ static inline unsigned long __load_ulong_le(const unsigned long *p,
 	unsigned long word;
 
 	p = (unsigned long *)((unsigned long) p + offset);
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	asm volatile(
 		"	ic	%0,%O1(%R1)\n"
 		"	icm	%0,2,%O1+1(%R1)\n"
@@ -834,7 +832,4 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
 
-
-#endif /* __KERNEL__ */
-
 #endif /* _S390_BITOPS_H */
diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index fc50a334..4c8d4d5 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -10,8 +10,6 @@
 #include <linux/spinlock.h>
 #include <asm/types.h>
 
-#ifdef __KERNEL__
-
 #define LPM_ANYPATH 0xff
 #define __MAX_CSSID 0
 
@@ -291,5 +289,3 @@ int chsc_sstpc(void *page, unsigned int op, u16 ctrl);
 int chsc_sstpi(void *page, void *result, size_t size);
 
 #endif
-
-#endif
diff --git a/arch/s390/include/asm/cmpxchg.h b/arch/s390/include/asm/cmpxchg.h
index 81d7908..8d798e9 100644
--- a/arch/s390/include/asm/cmpxchg.h
+++ b/arch/s390/include/asm/cmpxchg.h
@@ -29,7 +29,7 @@ static inline unsigned long __xchg(unsigned long x, void *ptr, int size)
 			"	cs	%0,0,%4\n"
 			"	jl	0b\n"
 			: "=&d" (old), "=Q" (*(int *) addr)
-			: "d" (x << shift), "d" (~(255 << shift)),
+			: "d" ((x & 0xff) << shift), "d" (~(0xff << shift)),
 			  "Q" (*(int *) addr) : "memory", "cc", "0");
 		return old >> shift;
 	case 2:
@@ -44,7 +44,7 @@ static inline unsigned long __xchg(unsigned long x, void *ptr, int size)
 			"	cs	%0,0,%4\n"
 			"	jl	0b\n"
 			: "=&d" (old), "=Q" (*(int *) addr)
-			: "d" (x << shift), "d" (~(65535 << shift)),
+			: "d" ((x & 0xffff) << shift), "d" (~(0xffff << shift)),
 			  "Q" (*(int *) addr) : "memory", "cc", "0");
 		return old >> shift;
 	case 4:
@@ -113,9 +113,10 @@ static inline unsigned long __cmpxchg(void *ptr, unsigned long old,
 			"	nr	%1,%5\n"
 			"	jnz	0b\n"
 			"1:"
-			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
-			: "d" (old << shift), "d" (new << shift),
-			  "d" (~(255 << shift)), "Q" (*(int *) ptr)
+			: "=&d" (prev), "=&d" (tmp), "+Q" (*(int *) addr)
+			: "d" ((old & 0xff) << shift),
+			  "d" ((new & 0xff) << shift),
+			  "d" (~(0xff << shift))
 			: "memory", "cc");
 		return prev >> shift;
 	case 2:
@@ -134,9 +135,10 @@ static inline unsigned long __cmpxchg(void *ptr, unsigned long old,
 			"	nr	%1,%5\n"
 			"	jnz	0b\n"
 			"1:"
-			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
-			: "d" (old << shift), "d" (new << shift),
-			  "d" (~(65535 << shift)), "Q" (*(int *) ptr)
+			: "=&d" (prev), "=&d" (tmp), "+Q" (*(int *) addr)
+			: "d" ((old & 0xffff) << shift),
+			  "d" ((new & 0xffff) << shift),
+			  "d" (~(0xffff << shift))
 			: "memory", "cc");
 		return prev >> shift;
 	case 4:
@@ -160,9 +162,14 @@ static inline unsigned long __cmpxchg(void *ptr, unsigned long old,
 	return old;
 }
 
-#define cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
-				       (unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						 \
+({									 \
+	__typeof__(*(ptr)) __ret;					 \
+	__ret = (__typeof__(*(ptr)))					 \
+		__cmpxchg((ptr), (unsigned long)(o), (unsigned long)(n), \
+			  sizeof(*(ptr)));				 \
+	__ret;								 \
+})
 
 #ifdef CONFIG_64BIT
 #define cmpxchg64(ptr, o, n)						\
@@ -181,13 +188,19 @@ static inline unsigned long long __cmpxchg64(void *ptr,
 		"	cds	%0,%2,%1"
 		: "+&d" (rp_old), "=Q" (ptr)
 		: "d" (rp_new), "Q" (ptr)
-		: "cc");
+		: "memory", "cc");
 	return rp_old.pair;
 }
-#define cmpxchg64(ptr, o, n)						\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
-					 (unsigned long long)(o),	\
-					 (unsigned long long)(n)))
+
+#define cmpxchg64(ptr, o, n)				\
+({							\
+	__typeof__(*(ptr)) __ret;			\
+	__ret = (__typeof__(*(ptr)))			\
+		__cmpxchg64((ptr),			\
+			    (unsigned long long)(o),	\
+			    (unsigned long long)(n));	\
+	__ret;						\
+})
 #endif /* CONFIG_64BIT */
 
 #include <asm-generic/cmpxchg-local.h>
@@ -216,8 +229,13 @@ static inline unsigned long __cmpxchg_local(void *ptr,
  * them available.
  */
 #define cmpxchg_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	__ret = (__typeof__(*(ptr)))					\
+		__cmpxchg_local((ptr), (unsigned long)(o),		\
+				(unsigned long)(n), sizeof(*(ptr)));	\
+	__ret;								\
+})
 
 #define cmpxchg64_local(ptr, o, n)	cmpxchg64((ptr), (o), (n))
 
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 24ef186..718374d 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -21,15 +21,15 @@ typedef unsigned long long __nocast cputime64_t;
 
 static inline unsigned long __div(unsigned long long n, unsigned long base)
 {
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	register_pair rp;
 
 	rp.pair = n >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (base >> 1));
 	return rp.subreg.odd;
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 	return n / base;
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 }
 
 #define cputime_one_jiffy		jiffies_to_cputime(1)
@@ -100,7 +100,7 @@ static inline void cputime_to_timespec(const cputime_t cputime,
 				       struct timespec *value)
 {
 	unsigned long long __cputime = (__force unsigned long long) cputime;
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	register_pair rp;
 
 	rp.pair = __cputime >> 1;
@@ -128,7 +128,7 @@ static inline void cputime_to_timeval(const cputime_t cputime,
 				      struct timeval *value)
 {
 	unsigned long long __cputime = (__force unsigned long long) cputime;
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	register_pair rp;
 
 	rp.pair = __cputime >> 1;
diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
index ecde941..debfda3 100644
--- a/arch/s390/include/asm/ctl_reg.h
+++ b/arch/s390/include/asm/ctl_reg.h
@@ -7,7 +7,7 @@
 #ifndef __ASM_CTL_REG_H
 #define __ASM_CTL_REG_H
 
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 
 #define __ctl_load(array, low, high) ({				\
 	typedef struct { char _[sizeof(array)]; } addrtype;	\
@@ -25,7 +25,7 @@
 		: "i" (low), "i" (high));			\
 	})
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 #define __ctl_load(array, low, high) ({				\
 	typedef struct { char _[sizeof(array)]; } addrtype;	\
@@ -43,7 +43,7 @@
 		: "i" (low), "i" (high));			\
 	})
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define __ctl_set_bit(cr, bit) ({	\
 	unsigned long __dummy;		\
diff --git a/arch/s390/include/asm/current.h b/arch/s390/include/asm/current.h
index 83cf36c..7a68084 100644
--- a/arch/s390/include/asm/current.h
+++ b/arch/s390/include/asm/current.h
@@ -11,13 +11,10 @@
 #ifndef _S390_CURRENT_H
 #define _S390_CURRENT_H
 
-#ifdef __KERNEL__
 #include <asm/lowcore.h>
 
 struct task_struct;
 
 #define current ((struct task_struct *const)S390_lowcore.current_task)
 
-#endif
-
 #endif /* !(_S390_CURRENT_H) */
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index c4ee39f..06151e6 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -107,11 +107,11 @@
 /*
  * These are used to set parameters in the core dumps.
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define ELF_CLASS	ELFCLASS32
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define ELF_CLASS	ELFCLASS64
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_S390
 
@@ -181,9 +181,9 @@ extern unsigned long elf_hwcap;
 extern char elf_platform[];
 #define ELF_PLATFORM (elf_platform)
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define SET_PERSONALITY(ex) set_personality(PER_LINUX)
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define SET_PERSONALITY(ex)					\
 do {								\
 	if (personality(current->personality) != PER_LINUX32)	\
@@ -194,7 +194,7 @@ do {								\
 	else							\
 		clear_thread_flag(TIF_31BIT);			\
 } while (0)
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define STACK_RND_MASK	0x7ffUL
 
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 81cf36b..96bc83e 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_S390_FUTEX_H
 #define _ASM_S390_FUTEX_H
 
-#ifdef __KERNEL__
-
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
@@ -48,5 +46,4 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
 }
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_S390_FUTEX_H */
diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index aae276d..aef0dde 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -20,7 +20,7 @@
 #include <asm/cio.h>
 #include <asm/uaccess.h>
 
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 #define IDA_SIZE_LOG 12 /* 11 for 2k , 12 for 4k */
 #else
 #define IDA_SIZE_LOG 11 /* 11 for 2k , 12 for 4k */
@@ -33,7 +33,7 @@
 static inline int
 idal_is_needed(void *vaddr, unsigned int length)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	return ((__pa(vaddr) + length - 1) >> 31) != 0;
 #else
 	return 0;
@@ -78,7 +78,7 @@ static inline unsigned long *idal_create_words(unsigned long *idaws,
 static inline int
 set_normalized_cda(struct ccw1 * ccw, void *vaddr)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	unsigned int nridaws;
 	unsigned long *idal;
 
@@ -105,7 +105,7 @@ set_normalized_cda(struct ccw1 * ccw, void *vaddr)
 static inline void
 clear_normalized_cda(struct ccw1 * ccw)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if (ccw->flags & CCW_FLAG_IDA) {
 		kfree((void *)(unsigned long) ccw->cda);
 		ccw->flags &= ~CCW_FLAG_IDA;
@@ -182,7 +182,7 @@ idal_buffer_free(struct idal_buffer *ib)
 static inline int
 __idal_buffer_is_needed(struct idal_buffer *ib)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	return ib->size > (4096ul << ib->page_order) ||
 		idal_is_needed(ib->data[0], ib->size);
 #else
diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index 27216d3..f81a097 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -11,8 +11,6 @@
 #ifndef _S390_IO_H
 #define _S390_IO_H
 
-#ifdef __KERNEL__
-
 #include <asm/page.h>
 
 #define IO_SPACE_LIMIT 0xffffffff
@@ -46,6 +44,4 @@ void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
  */
 #define xlate_dev_kmem_ptr(p)	p
 
-#endif /* __KERNEL__ */
-
 #endif
diff --git a/arch/s390/include/asm/irq.h b/arch/s390/include/asm/irq.h
index 5289cac..2b9d418 100644
--- a/arch/s390/include/asm/irq.h
+++ b/arch/s390/include/asm/irq.h
@@ -17,7 +17,8 @@ enum interruption_class {
 	EXTINT_VRT,
 	EXTINT_SCP,
 	EXTINT_IUC,
-	EXTINT_CPM,
+	EXTINT_CMS,
+	EXTINT_CMC,
 	IOINT_CIO,
 	IOINT_QAI,
 	IOINT_DAS,
diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 3f30dac..f4f3882 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -10,10 +10,8 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
-#ifdef __KERNEL__
-#include <asm/page.h>
-#endif
 #include <asm/processor.h>
+#include <asm/page.h>
 /*
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
  * I.e. Maximum page that is mapped directly into kernel memory,
diff --git a/arch/s390/include/asm/kmap_types.h b/arch/s390/include/asm/kmap_types.h
index 94ec3ee..0a88622 100644
--- a/arch/s390/include/asm/kmap_types.h
+++ b/arch/s390/include/asm/kmap_types.h
@@ -1,8 +1,6 @@
-#ifdef __KERNEL__
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
 #include <asm-generic/kmap_types.h>
 
 #endif
-#endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 5d09e40..69bdf72 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -49,7 +49,7 @@ static inline int init_new_context(struct task_struct *tsk,
 
 #define destroy_context(mm)             do { } while (0)
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define LCTL_OPCODE "lctl"
 #else
 #define LCTL_OPCODE "lctlg"
diff --git a/arch/s390/include/asm/module.h b/arch/s390/include/asm/module.h
index 1cc1c5a..f0b6b26 100644
--- a/arch/s390/include/asm/module.h
+++ b/arch/s390/include/asm/module.h
@@ -28,7 +28,7 @@ struct mod_arch_specific
 	struct mod_arch_syminfo *syminfo;
 };
 
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 #define ElfW(x) Elf64_ ## x
 #define ELFW(x) ELF64_ ## x
 #else
diff --git a/arch/s390/include/asm/os_info.h b/arch/s390/include/asm/os_info.h
index d07518a..295f2c4 100644
--- a/arch/s390/include/asm/os_info.h
+++ b/arch/s390/include/asm/os_info.h
@@ -13,7 +13,6 @@
 
 #define OS_INFO_VMCOREINFO	0
 #define OS_INFO_REIPL_BLOCK	1
-#define OS_INFO_INIT_FN		2
 
 struct os_info_entry {
 	u64	addr;
@@ -28,8 +27,8 @@ struct os_info {
 	u16	version_minor;
 	u64	crashkernel_addr;
 	u64	crashkernel_size;
-	struct os_info_entry entry[3];
-	u8	reserved[4004];
+	struct os_info_entry entry[2];
+	u8	reserved[4024];
 } __packed;
 
 void os_info_init(void);
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 0fbd189..6537e72 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -15,7 +15,7 @@
  * per cpu area, use weak definitions to force the compiler to
  * generate external references.
  */
-#if defined(CONFIG_SMP) && defined(__s390x__) && defined(MODULE)
+#if defined(CONFIG_SMP) && defined(CONFIG_64BIT) && defined(MODULE)
 #define ARCH_NEEDS_WEAK_PER_CPU
 #endif
 
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index 78e3041..43078c1 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -48,7 +48,7 @@ static inline void crst_table_init(unsigned long *crst, unsigned long entry)
 	clear_table(crst, entry, sizeof(unsigned long)*2048);
 }
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 {
@@ -64,7 +64,7 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 #define pgd_populate(mm, pgd, pud)		BUG()
 #define pud_populate(mm, pud, pmd)		BUG()
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 {
@@ -106,7 +106,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 	pud_val(*pud) = _REGION3_ENTRY | __pa(pmd);
 }
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 011358c..b322741 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -74,15 +74,15 @@ static inline int is_zero_pfn(unsigned long pfn)
  * table can map
  * PGDIR_SHIFT determines what a third-level page table entry can map
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 # define PMD_SHIFT	20
 # define PUD_SHIFT	20
 # define PGDIR_SHIFT	20
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 # define PMD_SHIFT	20
 # define PUD_SHIFT	31
 # define PGDIR_SHIFT	42
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define PMD_SIZE        (1UL << PMD_SHIFT)
 #define PMD_MASK        (~(PMD_SIZE-1))
@@ -98,13 +98,13 @@ static inline int is_zero_pfn(unsigned long pfn)
  * that leads to 1024 pte per pgd
  */
 #define PTRS_PER_PTE	256
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define PTRS_PER_PMD	1
 #define PTRS_PER_PUD	1
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define PTRS_PER_PMD	2048
 #define PTRS_PER_PUD	2048
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 #define PTRS_PER_PGD	2048
 
 #define FIRST_USER_ADDRESS  0
@@ -276,7 +276,7 @@ extern struct page *vmemmap;
  * swap pte is 1011 and 0001, 0011, 0101, 0111 are invalid.
  */
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 /* Bits in the segment table address-space-control-element */
 #define _ASCE_SPACE_SWITCH	0x80000000UL	/* space switch event	    */
@@ -308,7 +308,7 @@ extern struct page *vmemmap;
 #define KVM_UR_BIT	0x00008000UL
 #define KVM_UC_BIT	0x00004000UL
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 /* Bits in the segment/region table address-space-control-element */
 #define _ASCE_ORIGIN		~0xfffUL/* segment table origin		    */
@@ -363,7 +363,7 @@ extern struct page *vmemmap;
 #define KVM_UR_BIT	0x0000800000000000UL
 #define KVM_UC_BIT	0x0000400000000000UL
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 /*
  * A user page table pointer has the space-switch-event bit, the
@@ -424,7 +424,7 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 /*
  * pgd/pmd/pte query functions
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 static inline int pgd_present(pgd_t pgd) { return 1; }
 static inline int pgd_none(pgd_t pgd)    { return 0; }
@@ -434,7 +434,7 @@ static inline int pud_present(pud_t pud) { return 1; }
 static inline int pud_none(pud_t pud)	 { return 0; }
 static inline int pud_bad(pud_t pud)	 { return 0; }
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 static inline int pgd_present(pgd_t pgd)
 {
@@ -490,7 +490,7 @@ static inline int pud_bad(pud_t pud)
 	return (pud_val(pud) & mask) != 0;
 }
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 static inline int pmd_present(pmd_t pmd)
 {
@@ -741,7 +741,7 @@ static inline int pte_young(pte_t pte)
 
 static inline void pgd_clear(pgd_t *pgd)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R2)
 		pgd_val(*pgd) = _REGION2_ENTRY_EMPTY;
 #endif
@@ -749,7 +749,7 @@ static inline void pgd_clear(pgd_t *pgd)
 
 static inline void pud_clear(pud_t *pud)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
 		pud_val(*pud) = _REGION3_ENTRY_EMPTY;
 #endif
@@ -921,7 +921,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 static inline void __ptep_ipte(unsigned long address, pte_t *ptep)
 {
 	if (!(pte_val(*ptep) & _PAGE_INVALID)) {
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		/* pto must point to the start of the segment table */
 		pte_t *pto = (pte_t *) (((unsigned long) ptep) & 0x7ffffc00);
 #else
@@ -1116,7 +1116,7 @@ static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 #define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pmd) ({ BUG(); 0UL; })
@@ -1125,7 +1125,7 @@ static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 #define pud_offset(pgd, address) ((pud_t *) pgd)
 #define pmd_offset(pud, address) ((pmd_t *) pud + pmd_index(address))
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
@@ -1147,7 +1147,7 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 	return pmd + pmd_index(address);
 }
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define pfn_pte(pfn,pgprot) mk_pte_phys(__pa((pfn) << PAGE_SHIFT),(pgprot))
 #define pte_pfn(x) (pte_val(x) >> PAGE_SHIFT)
@@ -1196,7 +1196,7 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
  *  0000000000111111111122222222223333333333444444444455 5555 5 55566 66
  *  0123456789012345678901234567890123456789012345678901 2345 6 78901 23
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define __SWP_OFFSET_MASK (~0UL >> 12)
 #else
 #define __SWP_OFFSET_MASK (~0UL >> 11)
@@ -1217,11 +1217,11 @@ static inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 # define PTE_FILE_MAX_BITS	26
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 # define PTE_FILE_MAX_BITS	59
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define pte_to_pgoff(__pte) \
 	((((__pte).pte >> 12) << 7) + (((__pte).pte >> 1) & 0x7f))
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index d499b30..a6951a7 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -20,7 +20,6 @@
 #include <asm/ptrace.h>
 #include <asm/setup.h>
 
-#ifdef __KERNEL__
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -33,39 +32,33 @@ static inline void get_cpu_id(struct cpuid *ptr)
 }
 
 extern void s390_adjust_jiffies(void);
-extern int get_cpu_capability(unsigned int *);
 extern const struct seq_operations cpuinfo_op;
 extern int sysctl_ieee_emulation_warnings;
 
 /*
  * User space process size: 2GB for 31 bit, 4TB or 8PT for 64 bit.
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 
 #define TASK_SIZE		(1UL << 31)
 #define TASK_UNMAPPED_BASE	(1UL << 30)
 
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 
 #define TASK_SIZE_OF(tsk)	((tsk)->mm->context.asce_limit)
 #define TASK_UNMAPPED_BASE	(test_thread_flag(TIF_31BIT) ? \
 					(1UL << 30) : (1UL << 41))
 #define TASK_SIZE		TASK_SIZE_OF(current)
 
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
-#ifdef __KERNEL__
-
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define STACK_TOP		(1UL << 31)
 #define STACK_TOP_MAX		(1UL << 31)
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define STACK_TOP		(1UL << (test_thread_flag(TIF_31BIT) ? 31:42))
 #define STACK_TOP_MAX		(1UL << 42)
-#endif /* __s390x__ */
-
-
-#endif
+#endif /* CONFIG_64BIT */
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
@@ -185,7 +178,7 @@ static inline void psw_set_key(unsigned int key)
  */
 static inline void __load_psw(psw_t psw)
 {
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	asm volatile("lpsw  %0" : : "Q" (psw) : "cc");
 #else
 	asm volatile("lpswe %0" : : "Q" (psw) : "cc");
@@ -203,7 +196,7 @@ static inline void __load_psw_mask (unsigned long mask)
 
 	psw.mask = mask;
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	asm volatile(
 		"	basr	%0,0\n"
 		"0:	ahi	%0,1f-0b\n"
@@ -211,14 +204,14 @@ static inline void __load_psw_mask (unsigned long mask)
 		"	lpsw	%1\n"
 		"1:"
 		: "=&d" (addr), "=Q" (psw) : "Q" (psw) : "memory", "cc");
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 	asm volatile(
 		"	larl	%0,1f\n"
 		"	stg	%0,%O1+8(%R1)\n"
 		"	lpswe	%1\n"
 		"1:"
 		: "=&d" (addr), "=Q" (psw) : "Q" (psw) : "memory", "cc");
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 }
 
 /*
@@ -226,7 +219,7 @@ static inline void __load_psw_mask (unsigned long mask)
  */
 static inline unsigned long __rewind_psw(psw_t psw, unsigned long ilc)
 {
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	if (psw.addr & PSW_ADDR_AMODE)
 		/* 31 bit mode */
 		return (psw.addr - ilc) | PSW_ADDR_AMODE;
@@ -256,7 +249,7 @@ static inline void __noreturn disabled_wait(unsigned long code)
          * Store status and then load disabled wait psw,
          * the processor is dead afterwards
          */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	asm volatile(
 		"	stctl	0,0,0(%2)\n"
 		"	ni	0(%2),0xef\n"	/* switch off protection */
@@ -275,7 +268,7 @@ static inline void __noreturn disabled_wait(unsigned long code)
 		"	lpsw	0(%1)"
 		: "=m" (ctl_buf)
 		: "a" (&dw_psw), "a" (&ctl_buf), "m" (dw_psw) : "cc");
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 	asm volatile(
 		"	stctg	0,0,0(%2)\n"
 		"	ni	4(%2),0xef\n"	/* switch off protection */
@@ -308,7 +301,7 @@ static inline void __noreturn disabled_wait(unsigned long code)
 		"	lpswe	0(%1)"
 		: "=m" (ctl_buf)
 		: "a" (&dw_psw), "a" (&ctl_buf), "m" (dw_psw) : "cc", "0", "1");
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 	while (1);
 }
 
@@ -341,12 +334,10 @@ extern void (*s390_base_ext_handler_fn)(void);
 
 #define ARCH_LOW_ADDRESS_LIMIT	0x7fffffffUL
 
-#endif
-
 /*
  * Helper macro for exception table entries
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define EX_TABLE(_fault,_target)			\
 	".section __ex_table,\"a\"\n"			\
 	"	.align 4\n"				\
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index d0eb465..1ceee10 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -41,19 +41,17 @@
 #error "please don't include asm/rwsem.h directly, use linux/rwsem.h instead"
 #endif
 
-#ifdef __KERNEL__
-
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define RWSEM_UNLOCKED_VALUE	0x00000000
 #define RWSEM_ACTIVE_BIAS	0x00000001
 #define RWSEM_ACTIVE_MASK	0x0000ffff
 #define RWSEM_WAITING_BIAS	(-0x00010000)
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define RWSEM_UNLOCKED_VALUE	0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS	0x0000000000000001L
 #define RWSEM_ACTIVE_MASK	0x00000000ffffffffL
 #define RWSEM_WAITING_BIAS	(-0x0000000100000000L)
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 #define RWSEM_ACTIVE_READ_BIAS	RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
@@ -65,19 +63,19 @@ static inline void __down_read(struct rw_semaphore *sem)
 	signed long old, new;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	ahi	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	aghi	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "i" (RWSEM_ACTIVE_READ_BIAS)
 		: "cc", "memory");
@@ -93,7 +91,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 	signed long old, new;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	ltr	%1,%0\n"
 		"	jm	1f\n"
@@ -101,7 +99,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 		"	cs	%0,%1,%2\n"
 		"	jl	0b\n"
 		"1:"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	ltgr	%1,%0\n"
 		"	jm	1f\n"
@@ -109,7 +107,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 		"	csg	%0,%1,%2\n"
 		"	jl	0b\n"
 		"1:"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "i" (RWSEM_ACTIVE_READ_BIAS)
 		: "cc", "memory");
@@ -125,19 +123,19 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	a	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	ag	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "m" (tmp)
 		: "cc", "memory");
@@ -158,19 +156,19 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
 	signed long old;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%1\n"
 		"0:	ltr	%0,%0\n"
 		"	jnz	1f\n"
 		"	cs	%0,%3,%1\n"
 		"	jl	0b\n"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%1\n"
 		"0:	ltgr	%0,%0\n"
 		"	jnz	1f\n"
 		"	csg	%0,%3,%1\n"
 		"	jl	0b\n"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		"1:"
 		: "=&d" (old), "=Q" (sem->count)
 		: "Q" (sem->count), "d" (RWSEM_ACTIVE_WRITE_BIAS)
@@ -186,19 +184,19 @@ static inline void __up_read(struct rw_semaphore *sem)
 	signed long old, new;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	ahi	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	aghi	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "i" (-RWSEM_ACTIVE_READ_BIAS)
 		: "cc", "memory");
@@ -216,19 +214,19 @@ static inline void __up_write(struct rw_semaphore *sem)
 
 	tmp = -RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	a	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	ag	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "m" (tmp)
 		: "cc", "memory");
@@ -246,19 +244,19 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 
 	tmp = -RWSEM_WAITING_BIAS;
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	a	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	ag	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "m" (tmp)
 		: "cc", "memory");
@@ -274,19 +272,19 @@ static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 	signed long old, new;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	ar	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	agr	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "d" (delta)
 		: "cc", "memory");
@@ -300,24 +298,23 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	signed long old, new;
 
 	asm volatile(
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 		"	l	%0,%2\n"
 		"0:	lr	%1,%0\n"
 		"	ar	%1,%4\n"
 		"	cs	%0,%1,%2\n"
 		"	jl	0b"
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
 		"	agr	%1,%4\n"
 		"	csg	%0,%1,%2\n"
 		"	jl	0b"
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 		: "=&d" (old), "=&d" (new), "=Q" (sem->count)
 		: "Q" (sem->count), "d" (delta)
 		: "cc", "memory");
 	return new;
 }
 
-#endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 7244e1f..40eb2ff 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -22,19 +22,19 @@
 #include <asm/lowcore.h>
 #include <asm/types.h>
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define IPL_DEVICE        (*(unsigned long *)  (0x10404))
 #define INITRD_START      (*(unsigned long *)  (0x1040C))
 #define INITRD_SIZE       (*(unsigned long *)  (0x10414))
 #define OLDMEM_BASE	  (*(unsigned long *)  (0x1041C))
 #define OLDMEM_SIZE	  (*(unsigned long *)  (0x10424))
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define IPL_DEVICE        (*(unsigned long *)  (0x10400))
 #define INITRD_START      (*(unsigned long *)  (0x10408))
 #define INITRD_SIZE       (*(unsigned long *)  (0x10410))
 #define OLDMEM_BASE	  (*(unsigned long *)  (0x10418))
 #define OLDMEM_SIZE	  (*(unsigned long *)  (0x10420))
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 #define COMMAND_LINE      ((char *)            (0x10480))
 
 #define CHUNK_READ_WRITE 0
@@ -89,7 +89,7 @@ extern unsigned int user_mode;
 
 #define MACHINE_HAS_DIAG9C	(S390_lowcore.machine_flags & MACHINE_FLAG_DIAG9C)
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define MACHINE_HAS_IEEE	(S390_lowcore.machine_flags & MACHINE_FLAG_IEEE)
 #define MACHINE_HAS_CSP		(S390_lowcore.machine_flags & MACHINE_FLAG_CSP)
 #define MACHINE_HAS_IDTE	(0)
@@ -100,7 +100,7 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(0)
 #define MACHINE_HAS_SPP		(0)
 #define MACHINE_HAS_TOPOLOGY	(0)
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define MACHINE_HAS_IEEE	(1)
 #define MACHINE_HAS_CSP		(1)
 #define MACHINE_HAS_IDTE	(S390_lowcore.machine_flags & MACHINE_FLAG_IDTE)
@@ -111,7 +111,7 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(S390_lowcore.machine_flags & MACHINE_FLAG_PFMF)
 #define MACHINE_HAS_SPP		(S390_lowcore.machine_flags & MACHINE_FLAG_SPP)
 #define MACHINE_HAS_TOPOLOGY	(S390_lowcore.machine_flags & MACHINE_FLAG_TOPOLOGY)
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
 #define ZFCPDUMP_HSA_SIZE_MAX	(64UL<<20)
@@ -153,19 +153,19 @@ extern void (*_machine_power_off)(void);
 
 #else /* __ASSEMBLY__ */
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define IPL_DEVICE        0x10404
 #define INITRD_START      0x1040C
 #define INITRD_SIZE       0x10414
 #define OLDMEM_BASE	  0x1041C
 #define OLDMEM_SIZE	  0x10424
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #define IPL_DEVICE        0x10400
 #define INITRD_START      0x10408
 #define INITRD_SIZE       0x10410
 #define OLDMEM_BASE	  0x10418
 #define OLDMEM_SIZE	  0x10420
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 #define COMMAND_LINE      0x10480
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/s390/include/asm/sfp-util.h b/arch/s390/include/asm/sfp-util.h
index ca3f881..5959bfb 100644
--- a/arch/s390/include/asm/sfp-util.h
+++ b/arch/s390/include/asm/sfp-util.h
@@ -51,7 +51,7 @@
 	wl = __wl;					\
 })
 
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 #define udiv_qrnnd(q, r, n1, n0, d)			\
   do { unsigned long __n;				\
        unsigned int __r, __d;				\
diff --git a/arch/s390/include/asm/string.h b/arch/s390/include/asm/string.h
index cd0241d..8cc160c 100644
--- a/arch/s390/include/asm/string.h
+++ b/arch/s390/include/asm/string.h
@@ -9,8 +9,6 @@
 #ifndef _S390_STRING_H_
 #define _S390_STRING_H_
 
-#ifdef __KERNEL__
-
 #ifndef _LINUX_TYPES_H
 #include <linux/types.h>
 #endif
@@ -152,6 +150,4 @@ size_t strlen(const char *s);
 size_t strnlen(const char * s, size_t n);
 #endif /* !IN_ARCH_STRING_C */
 
-#endif /* __KERNEL__ */
-
 #endif /* __S390_STRING_H_ */
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 003b04e..4e40b25 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -9,15 +9,13 @@
 #ifndef _ASM_THREAD_INFO_H
 #define _ASM_THREAD_INFO_H
 
-#ifdef __KERNEL__
-
 /*
  * Size of kernel stack for each process
  */
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define THREAD_ORDER 1
 #define ASYNC_ORDER  1
-#else /* __s390x__ */
+#else /* CONFIG_64BIT */
 #ifndef __SMALL_STACK
 #define THREAD_ORDER 2
 #define ASYNC_ORDER  2
@@ -25,7 +23,7 @@
 #define THREAD_ORDER 1
 #define ASYNC_ORDER  1
 #endif
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 #define THREAD_SIZE (PAGE_SIZE << THREAD_ORDER)
 #define ASYNC_SIZE  (PAGE_SIZE << ASYNC_ORDER)
@@ -123,8 +121,6 @@ static inline struct thread_info *current_thread_info(void)
 #define is_32bit_task()		(1)
 #endif
 
-#endif /* __KERNEL__ */
-
 #define PREEMPT_ACTIVE		0x4000000
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/s390/include/asm/timer.h b/arch/s390/include/asm/timer.h
index e63069b..15d6479 100644
--- a/arch/s390/include/asm/timer.h
+++ b/arch/s390/include/asm/timer.h
@@ -10,8 +10,6 @@
 #ifndef _ASM_S390_TIMER_H
 #define _ASM_S390_TIMER_H
 
-#ifdef __KERNEL__
-
 #include <linux/timer.h>
 
 #define VTIMER_MAX_SLICE (0x7ffffffffffff000LL)
@@ -50,6 +48,4 @@ extern void vtime_init(void);
 extern void vtime_stop_cpu(void);
 extern void vtime_start_leave(void);
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_S390_TIMER_H */
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 775a5ee..06e5acb 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -106,7 +106,7 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 				unsigned long address)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if (tlb->mm->context.asce_limit <= (1UL << 31))
 		return;
 	if (!tlb->fullmm)
@@ -125,7 +125,7 @@ static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 static inline void pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 				unsigned long address)
 {
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	if (tlb->mm->context.asce_limit <= (1UL << 42))
 		return;
 	if (!tlb->fullmm)
diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index 1d8648c..9fde315 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -27,12 +27,12 @@ static inline void __tlb_flush_global(void)
 	register unsigned long reg4 asm("4");
 	long dummy;
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 	if (!MACHINE_HAS_CSP) {
 		smp_ptlb_all();
 		return;
 	}
-#endif /* __s390x__ */
+#endif /* CONFIG_64BIT */
 
 	dummy = 0;
 	reg2 = reg3 = 0;
diff --git a/arch/s390/include/asm/types.h b/arch/s390/include/asm/types.h
index 05ebbcd..6c8c35f 100644
--- a/arch/s390/include/asm/types.h
+++ b/arch/s390/include/asm/types.h
@@ -28,7 +28,7 @@ typedef __signed__ long saddr_t;
 
 #ifndef __ASSEMBLY__
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 typedef union {
 	unsigned long long pair;
 	struct {
@@ -37,7 +37,7 @@ typedef union {
 	} subreg;
 } register_pair;
 
-#endif /* ! __s390x__   */
+#endif /* ! CONFIG_64BIT   */
 #endif /* __ASSEMBLY__  */
 #endif /* __KERNEL__    */
 #endif /* _S390_TYPES_H */
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 8f2cada..1f3a79b 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -50,10 +50,15 @@
 
 #define segment_eq(a,b) ((a).ar4 == (b).ar4)
 
-#define __access_ok(addr, size)	\
-({				\
-	__chk_user_ptr(addr);	\
-	1;			\
+static inline int __range_ok(unsigned long addr, unsigned long size)
+{
+	return 1;
+}
+
+#define __access_ok(addr, size)				\
+({							\
+	__chk_user_ptr(addr);				\
+	__range_ok((unsigned long)(addr), (size));	\
 })
 
 #define access_ok(type, addr, size) __access_ok(addr, size)
@@ -377,7 +382,7 @@ clear_user(void __user *to, unsigned long n)
 }
 
 extern int memcpy_real(void *, void *, size_t);
-extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
+extern void memcpy_absolute(void *, void *, size_t);
 extern int copy_to_user_real(void __user *dest, void *src, size_t count);
 extern int copy_from_user_real(void *dest, void __user *src, size_t count);
 
diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index c4a11cf..a73eb2e 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -1,8 +1,6 @@
 #ifndef __S390_VDSO_H__
 #define __S390_VDSO_H__
 
-#ifdef __KERNEL__
-
 /* Default link addresses for the vDSOs */
 #define VDSO32_LBASE	0
 #define VDSO64_LBASE	0
@@ -45,7 +43,4 @@ void vdso_free_per_cpu(struct _lowcore *lowcore);
 #endif
 
 #endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
 #endif /* __S390_VDSO_H__ */
diff --git a/arch/s390/kernel/base.S b/arch/s390/kernel/base.S
index 3aa4d00..c880ff7 100644
--- a/arch/s390/kernel/base.S
+++ b/arch/s390/kernel/base.S
@@ -88,6 +88,9 @@ ENTRY(diag308_reset)
 	stctg	%c0,%c15,0(%r4)
 	larl	%r4,.Lfpctl		# Floating point control register
 	stfpc	0(%r4)
+	larl	%r4,.Lcontinue_psw	# Save PSW flags
+	epsw	%r2,%r3
+	stm	%r2,%r3,0(%r4)
 	larl	%r4,.Lrestart_psw	# Setup restart PSW at absolute 0
 	lghi	%r3,0
 	lg	%r4,0(%r4)		# Save PSW
@@ -103,11 +106,20 @@ ENTRY(diag308_reset)
 	lctlg	%c0,%c15,0(%r4)
 	larl	%r4,.Lfpctl		# Restore floating point ctl register
 	lfpc	0(%r4)
+	larl	%r4,.Lcontinue_psw	# Restore PSW flags
+	lpswe	0(%r4)
+.Lcontinue:
 	br	%r14
 .align 16
 .Lrestart_psw:
 	.long	0x00080000,0x80000000 + .Lrestart_part2
 
+	.section .data..nosave,"aw",@progbits
+.align 8
+.Lcontinue_psw:
+	.quad	0,.Lcontinue
+	.previous
+
 	.section .bss
 .align 8
 .Lctlregs:
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index d84181f..6684fff 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -237,7 +237,7 @@ static noinline __init void detect_machine_type(void)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_VM;
 }
 
-static __init void early_pgm_check_handler(void)
+static void early_pgm_check_handler(void)
 {
 	unsigned long addr;
 	const struct exception_table_entry *fixup;
diff --git a/arch/s390/kernel/head_kdump.S b/arch/s390/kernel/head_kdump.S
index e1ac389..796c976 100644
--- a/arch/s390/kernel/head_kdump.S
+++ b/arch/s390/kernel/head_kdump.S
@@ -85,11 +85,6 @@ startup_kdump_relocated:
 	basr	%r13,0
 0:
 	mvc	0(8,%r0),.Lrestart_psw-0b(%r13)	# Setup restart PSW
-	mvc	464(16,%r0),.Lpgm_psw-0b(%r13)	# Setup pgm check PSW
-	lhi	%r1,1				# Start new kernel
-	diag	%r1,%r1,0x308			# with diag 308
-
-.Lno_diag308:					# No diag 308
 	sam31					# Switch to 31 bit addr mode
 	sr	%r1,%r1				# Erase register r1
 	sr	%r2,%r2				# Erase register r2
@@ -98,8 +93,6 @@ startup_kdump_relocated:
 .align	8
 .Lrestart_psw:
 	.long	0x00080000,0x80000000 + startup
-.Lpgm_psw:
-	.quad	0x0000000180000000,0x0000000000000000 + .Lno_diag308
 #else
 .align 2
 .Lep_startup_kdump:
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 8342e65..2f6cfd4 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1528,12 +1528,15 @@ static struct shutdown_action __refdata dump_action = {
 
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
-	u32 csum;
-
-	csum = csum_partial(reipl_block_actual, reipl_block_actual->hdr.len, 0);
-	copy_to_absolute_zero(&S390_lowcore.ipib_checksum, &csum, sizeof(csum));
-	copy_to_absolute_zero(&S390_lowcore.ipib, &reipl_block_actual,
-			      sizeof(reipl_block_actual));
+	struct {
+		void	*addr;
+		__u32	csum;
+	} __packed ipib;
+
+	ipib.csum = csum_partial(reipl_block_actual,
+				 reipl_block_actual->hdr.len, 0);
+	ipib.addr = reipl_block_actual;
+	memcpy_absolute(&S390_lowcore.ipib, &ipib, sizeof(ipib));
 	dump_run(trigger);
 }
 
@@ -1750,6 +1753,7 @@ static struct kobj_attribute on_restart_attr =
 
 static void __do_restart(void *ignore)
 {
+	__arch_local_irq_stosm(0x04); /* enable DAT */
 	smp_send_stop();
 #ifdef CONFIG_CRASH_DUMP
 	crash_kexec(NULL);
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 8a22c27..b4f4a71 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -42,7 +42,8 @@ static const struct irq_class intrclass_names[] = {
 	{.name = "VRT", .desc = "[EXT] Virtio" },
 	{.name = "SCP", .desc = "[EXT] Service Call" },
 	{.name = "IUC", .desc = "[EXT] IUCV" },
-	{.name = "CPM", .desc = "[EXT] CPU Measurement" },
+	{.name = "CMS", .desc = "[EXT] CPU-Measurement: Sampling" },
+	{.name = "CMC", .desc = "[EXT] CPU-Measurement: Counter" },
 	{.name = "CIO", .desc = "[I/O] Common I/O Layer Interrupt" },
 	{.name = "QAI", .desc = "[I/O] QDIO Adapter Interrupt" },
 	{.name = "DAS", .desc = "[I/O] DASD" },
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index bdad47d..cdacf8f 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -24,6 +24,7 @@
 #include <asm/ipl.h>
 #include <asm/diag.h>
 #include <asm/asm-offsets.h>
+#include <asm/os_info.h>
 
 typedef void (*relocate_kernel_t)(kimage_entry_t *, unsigned long);
 
@@ -79,8 +80,8 @@ static void __do_machine_kdump(void *image)
 #ifdef CONFIG_CRASH_DUMP
 	int (*start_kdump)(int) = (void *)((struct kimage *) image)->start;
 
-	__load_psw_mask(PSW_MASK_BASE | PSW_DEFAULT_KEY | PSW_MASK_EA | PSW_MASK_BA);
 	setup_regs();
+	__load_psw_mask(PSW_MASK_BASE | PSW_DEFAULT_KEY | PSW_MASK_EA | PSW_MASK_BA);
 	start_kdump(1);
 #endif
 }
@@ -114,8 +115,13 @@ static void crash_map_pages(int enable)
 	       size % KEXEC_CRASH_MEM_ALIGN);
 	if (enable)
 		vmem_add_mapping(crashk_res.start, size);
-	else
+	else {
 		vmem_remove_mapping(crashk_res.start, size);
+		if (size)
+			os_info_crashkernel_add(crashk_res.start, size);
+		else
+			os_info_crashkernel_add(0, 0);
+	}
 }
 
 /*
@@ -208,6 +214,7 @@ static void __machine_kexec(void *data)
 {
 	struct kimage *image = data;
 
+	__arch_local_irq_stosm(0x04); /* enable DAT */
 	pfault_fini();
 	tracing_off();
 	debug_locks_off();
diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index e8d6c21..95fa5ac 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -60,7 +60,7 @@ void __init os_info_init(void)
 	os_info.version_minor = OS_INFO_VERSION_MINOR;
 	os_info.magic = OS_INFO_MAGIC;
 	os_info.csum = os_info_csum(&os_info);
-	copy_to_absolute_zero(&S390_lowcore.os_info, &ptr, sizeof(ptr));
+	memcpy_absolute(&S390_lowcore.os_info, &ptr, sizeof(ptr));
 }
 
 #ifdef CONFIG_CRASH_DUMP
@@ -138,7 +138,6 @@ static void os_info_old_init(void)
 		goto fail_free;
 	os_info_old_alloc(OS_INFO_VMCOREINFO, 1);
 	os_info_old_alloc(OS_INFO_REIPL_BLOCK, 1);
-	os_info_old_alloc(OS_INFO_INIT_FN, PAGE_SIZE);
 	pr_info("crashkernel: addr=0x%lx size=%lu\n",
 		(unsigned long) os_info_old->crashkernel_addr,
 		(unsigned long) os_info_old->crashkernel_size);
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index cb019f4..9871b19 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -225,7 +225,7 @@ static void cpumf_measurement_alert(struct ext_code ext_code,
 	if (!(alert & CPU_MF_INT_CF_MASK))
 		return;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CPM]++;
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_CMC]++;
 	cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	/* Measurement alerts are shared and might happen when the PMU
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 06264ae..489d1d8 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -428,10 +428,12 @@ static void __init setup_lowcore(void)
 	lc->restart_fn = (unsigned long) do_restart;
 	lc->restart_data = 0;
 	lc->restart_source = -1UL;
-	memcpy(&S390_lowcore.restart_stack, &lc->restart_stack,
-	       4*sizeof(unsigned long));
-	copy_to_absolute_zero(&S390_lowcore.restart_psw,
-			      &lc->restart_psw, sizeof(psw_t));
+
+	/* Setup absolute zero lowcore */
+	memcpy_absolute(&S390_lowcore.restart_stack, &lc->restart_stack,
+			4 * sizeof(unsigned long));
+	memcpy_absolute(&S390_lowcore.restart_psw, &lc->restart_psw,
+			sizeof(lc->restart_psw));
 
 	set_prefix((u32)(unsigned long) lc);
 	lowcore_ptr[0] = lc;
@@ -598,7 +600,7 @@ static void __init setup_vmcoreinfo(void)
 #ifdef CONFIG_KEXEC
 	unsigned long ptr = paddr_vmcoreinfo_note();
 
-	copy_to_absolute_zero(&S390_lowcore.vmcore_info, &ptr, sizeof(ptr));
+	memcpy_absolute(&S390_lowcore.vmcore_info, &ptr, sizeof(ptr));
 #endif
 }
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 647ba94..15cca26 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -297,26 +297,27 @@ static void pcpu_start_fn(struct pcpu *pcpu, void (*func)(void *), void *data)
 static void pcpu_delegate(struct pcpu *pcpu, void (*func)(void *),
 			  void *data, unsigned long stack)
 {
-	struct _lowcore *lc = pcpu->lowcore;
-	unsigned short this_cpu;
+	struct _lowcore *lc = lowcore_ptr[pcpu - pcpu_devices];
+	struct {
+		unsigned long	stack;
+		void		*func;
+		void		*data;
+		unsigned long	source;
+	} restart = { stack, func, data, stap() };
 
 	__load_psw_mask(psw_kernel_bits);
-	this_cpu = stap();
-	if (pcpu->address == this_cpu)
+	if (pcpu->address == restart.source)
 		func(data);	/* should not return */
 	/* Stop target cpu (if func returns this stops the current cpu). */
 	pcpu_sigp_retry(pcpu, sigp_stop, 0);
 	/* Restart func on the target cpu and stop the current cpu. */
-	lc->restart_stack = stack;
-	lc->restart_fn = (unsigned long) func;
-	lc->restart_data = (unsigned long) data;
-	lc->restart_source = (unsigned long) this_cpu;
+	memcpy_absolute(&lc->restart_stack, &restart, sizeof(restart));
 	asm volatile(
 		"0:	sigp	0,%0,6	# sigp restart to target cpu\n"
 		"	brc	2,0b	# busy, try again\n"
 		"1:	sigp	0,%1,5	# sigp stop to current cpu\n"
 		"	brc	2,1b	# busy, try again\n"
-		: : "d" (pcpu->address), "d" (this_cpu) : "0", "1", "cc");
+		: : "d" (pcpu->address), "d" (restart.source) : "0", "1", "cc");
 	for (;;) ;
 }
 
@@ -800,17 +801,6 @@ void __noreturn cpu_die(void)
 
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static void smp_call_os_info_init_fn(void)
-{
-	int (*init_fn)(void);
-	unsigned long size;
-
-	init_fn = os_info_old_entry(OS_INFO_INIT_FN, &size);
-	if (!init_fn)
-		return;
-	init_fn();
-}
-
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	/* request the 0x1201 emergency signal external interrupt */
@@ -819,7 +809,6 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	/* request the 0x1202 external call external interrupt */
 	if (register_external_interrupt(0x1202, do_ext_call_interrupt) != 0)
 		panic("Couldn't request external interrupt 0x1202");
-	smp_call_os_info_init_fn();
 	smp_detect_cpus();
 }
 
@@ -943,19 +932,6 @@ static struct attribute_group cpu_common_attr_group = {
 	.attrs = cpu_common_attrs,
 };
 
-static ssize_t show_capability(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	unsigned int capability;
-	int rc;
-
-	rc = get_cpu_capability(&capability);
-	if (rc)
-		return rc;
-	return sprintf(buf, "%u\n", capability);
-}
-static DEVICE_ATTR(capability, 0444, show_capability, NULL);
-
 static ssize_t show_idle_count(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -993,7 +969,6 @@ static ssize_t show_idle_time(struct device *dev,
 static DEVICE_ATTR(idle_time_us, 0444, show_idle_time, NULL);
 
 static struct attribute *cpu_online_attrs[] = {
-	&dev_attr_capability.attr,
 	&dev_attr_idle_count.attr,
 	&dev_attr_idle_time_us.attr,
 	NULL,
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index 2a94b77..fa0eb23 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -393,27 +393,6 @@ static __init int create_proc_service_level(void)
 subsys_initcall(create_proc_service_level);
 
 /*
- * Bogomips calculation based on cpu capability.
- */
-int get_cpu_capability(unsigned int *capability)
-{
-	struct sysinfo_1_2_2 *info;
-	int rc;
-
-	info = (void *) get_zeroed_page(GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-	rc = stsi(info, 1, 2, 2);
-	if (rc == -ENOSYS)
-		goto out;
-	rc = 0;
-	*capability = info->capability;
-out:
-	free_page((unsigned long) info);
-	return rc;
-}
-
-/*
  * CPU capability might have changed. Therefore recalculate loops_per_jiffy.
  */
 void s390_adjust_jiffies(void)
diff --git a/arch/s390/lib/uaccess_mvcos.c b/arch/s390/lib/uaccess_mvcos.c
index 60455f1..58a75a8 100644
--- a/arch/s390/lib/uaccess_mvcos.c
+++ b/arch/s390/lib/uaccess_mvcos.c
@@ -14,7 +14,7 @@
 #include <asm/futex.h>
 #include "uaccess.h"
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define AHI	"ahi"
 #define ALR	"alr"
 #define CLR	"clr"
diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
index bb1a7ee..57e9429 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -15,7 +15,7 @@
 #include <asm/futex.h>
 #include "uaccess.h"
 
-#ifndef __s390x__
+#ifndef CONFIG_64BIT
 #define AHI	"ahi"
 #define ALR	"alr"
 #define CLR	"clr"
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 795a0a9..921fa54 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -101,19 +101,27 @@ int memcpy_real(void *dest, void *src, size_t count)
 }
 
 /*
- * Copy memory to absolute zero
+ * Copy memory in absolute mode (kernel to kernel)
  */
-void copy_to_absolute_zero(void *dest, void *src, size_t count)
+void memcpy_absolute(void *dest, void *src, size_t count)
 {
-	unsigned long cr0;
+	unsigned long cr0, flags, prefix;
 
-	BUG_ON((unsigned long) dest + count >= sizeof(struct _lowcore));
-	preempt_disable();
+	flags = arch_local_irq_save();
 	__ctl_store(cr0, 0, 0);
 	__ctl_clear_bit(0, 28); /* disable lowcore protection */
-	memcpy_real(dest + store_prefix(), src, count);
+	prefix = store_prefix();
+	if (prefix) {
+		local_mcck_disable();
+		set_prefix(0);
+		memcpy(dest, src, count);
+		set_prefix(prefix);
+		local_mcck_enable();
+	} else {
+		memcpy(dest, src, count);
+	}
 	__ctl_load(cr0, 0, 0);
-	preempt_enable();
+	arch_local_irq_restore(flags);
 }
 
 /*
@@ -188,20 +196,6 @@ static int is_swapped(unsigned long addr)
 }
 
 /*
- * Return swapped prefix or zero page address
- */
-static unsigned long get_swapped(unsigned long addr)
-{
-	unsigned long prefix = store_prefix();
-
-	if (addr < sizeof(struct _lowcore))
-		return addr + prefix;
-	if (addr >= prefix && addr < prefix + sizeof(struct _lowcore))
-		return addr - prefix;
-	return addr;
-}
-
-/*
  * Convert a physical pointer for /dev/mem access
  *
  * For swapped prefix pages a new buffer is returned that contains a copy of
@@ -218,7 +212,7 @@ void *xlate_dev_mem_ptr(unsigned long addr)
 		size = PAGE_SIZE - (addr & ~PAGE_MASK);
 		bounce = (void *) __get_free_page(GFP_ATOMIC);
 		if (bounce)
-			memcpy_real(bounce, (void *) get_swapped(addr), size);
+			memcpy_absolute(bounce, (void *) addr, size);
 	}
 	preempt_enable();
 	put_online_cpus();
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 4799383..71ae20d 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -109,7 +109,7 @@ static int vmem_add_mem(unsigned long start, unsigned long size, int ro)
 		pte = mk_pte_phys(address, __pgprot(ro ? _PAGE_RO : 0));
 		pm_dir = pmd_offset(pu_dir, address);
 
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 		if (MACHINE_HAS_HPAGE && !(address & ~HPAGE_MASK) &&
 		    (address + HPAGE_SIZE <= start + size) &&
 		    (address >= HPAGE_SIZE)) {
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index c6646de..a4a89fa 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -235,7 +235,7 @@ static void hws_ext_handler(struct ext_code ext_code,
 	if (!(param32 & CPU_MF_INT_SF_MASK))
 		return;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_CPM]++;
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_CMS]++;
 	atomic_xchg(&cb->ext_params, atomic_read(&cb->ext_params) | param32);
 
 	if (hws_wq)
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 33a6743..c05da00 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -10,8 +10,6 @@
 #ifndef DASD_INT_H
 #define DASD_INT_H
 
-#ifdef __KERNEL__
-
 /* we keep old device allocation scheme; IOW, minors are still in 0..255 */
 #define DASD_PER_MAJOR (1U << (MINORBITS - DASD_PARTN_BITS))
 #define DASD_PARTN_MASK ((1 << DASD_PARTN_BITS) - 1)
@@ -791,6 +789,4 @@ static inline int dasd_eer_enabled(struct dasd_device *device)
 #define dasd_eer_enabled(d)	(0)
 #endif	/* CONFIG_DASD_ERR */
 
-#endif				/* __KERNEL__ */
-
 #endif				/* DASD_H */
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index 69e6c50..50f7115 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -211,7 +211,7 @@ int sclp_sdias_copy(void *dest, int start_blk, int nr_blks)
 	sccb.evbuf.event_qual = EQ_STORE_DATA;
 	sccb.evbuf.data_id = DI_FCP_DUMP;
 	sccb.evbuf.event_id = 4712;
-#ifdef __s390x__
+#ifdef CONFIG_64BIT
 	sccb.evbuf.asa_size = ASA_SIZE_64;
 #else
 	sccb.evbuf.asa_size = ASA_SIZE_32;

