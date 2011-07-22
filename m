Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1GVPnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:43:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab1GVPnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:43:13 -0400
Date: Fri, 22 Jul 2011 17:42:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>
Subject: [GIT PULL] x86/vdso changes for v3.1
Message-ID: <20110722154219.GA25694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vdso-for-linus


out-of-topic modifications in x86-vdso-for-linus:
-------------------------------------------------
arch/ia64/Kconfig                  # ae7bd11: clocksource: Change __ARCH_HAS_CL
arch/ia64/include/asm/clocksource.h# ae7bd11: clocksource: Change __ARCH_HAS_CL
                                   # 574c44f: ia64: Replace clocksource.fsys_mm
arch/ia64/kernel/cyclone.c         # 574c44f: ia64: Replace clocksource.fsys_mm
arch/ia64/kernel/time.c            # 574c44f: ia64: Replace clocksource.fsys_mm
arch/ia64/sn/kernel/sn2/timer.c    # 574c44f: ia64: Replace clocksource.fsys_mm
drivers/char/hpet.c                # 574c44f: ia64: Replace clocksource.fsys_mm
include/linux/clocksource.h        # ae7bd11: clocksource: Change __ARCH_HAS_CL
                                   # 574c44f: ia64: Replace clocksource.fsys_mm
                                   # 433bd80: clocksource: Replace vread with g
include/linux/seccomp.h            # 5cec93c: x86-64: Emulate legacy vsyscalls

 Thanks,

	Ingo

------------------>
Andy Lutomirski (17):
      x86-64: Fix alignment of jiffies variable
      x86-64: Document some of entry_64.S
      x86-64: Give vvars their own page
      x86-64: Remove kernel.vsyscall64 sysctl
      x86-64: Map the HPET NX
      x86-64: Remove vsyscall number 3 (venosys)
      x86-64: Fill unused parts of the vsyscall page with 0xcc
      x86-64: Emulate legacy vsyscalls
      x86-64: Improve vsyscall emulation CS and RIP handling
      x86: Make alternative instruction pointers relative
      x86-64: Allow alternative patching in the vDSO
      x86-64: Add --no-undefined to vDSO build
      clocksource: Replace vread with generic arch data
      x86-64: Move vread_tsc and vread_hpet into the vDSO
      ia64: Replace clocksource.fsys_mmio with generic arch data
      Document the vDSO and add a reference parser
      x86-64, vdso: Do not allocate memory for the vDSO

Borislav Petkov (1):
      x86, vdso: Drop now wrong comment

H. Peter Anvin (1):
      clocksource: Change __ARCH_HAS_CLOCKSOURCE_DATA to a CONFIG option


 Documentation/ABI/stable/vdso          |   27 +++
 Documentation/vDSO/parse_vdso.c        |  256 ++++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c         |  111 ++++++++++++
 Documentation/x86/entry_64.txt         |   98 ++++++++++
 arch/ia64/Kconfig                      |    3 +
 arch/ia64/include/asm/clocksource.h    |   10 +
 arch/ia64/kernel/cyclone.c             |    2 +-
 arch/ia64/kernel/time.c                |    2 +-
 arch/ia64/sn/kernel/sn2/timer.c        |    2 +-
 arch/x86/Kconfig                       |    4 +
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    8 +-
 arch/x86/include/asm/clocksource.h     |   18 ++
 arch/x86/include/asm/cpufeature.h      |    8 +-
 arch/x86/include/asm/fixmap.h          |    1 +
 arch/x86/include/asm/irq_vectors.h     |    6 +-
 arch/x86/include/asm/pgtable_types.h   |    6 +-
 arch/x86/include/asm/traps.h           |    4 +
 arch/x86/include/asm/tsc.h             |    4 -
 arch/x86/include/asm/vgtod.h           |    3 +-
 arch/x86/include/asm/vsyscall.h        |    4 -
 arch/x86/include/asm/vvar.h            |   24 ++--
 arch/x86/kernel/Makefile               |    8 +-
 arch/x86/kernel/alternative.c          |   23 +--
 arch/x86/kernel/entry_64.S             |    4 +
 arch/x86/kernel/hpet.c                 |   11 +-
 arch/x86/kernel/traps.c                |    6 +
 arch/x86/kernel/tsc.c                  |    2 +-
 arch/x86/kernel/vmlinux.lds.S          |   49 +++---
 arch/x86/kernel/vread_tsc_64.c         |   36 ----
 arch/x86/kernel/vsyscall_64.c          |  310 +++++++++++++++-----------------
 arch/x86/kernel/vsyscall_emu_64.S      |   27 +++
 arch/x86/lib/copy_page_64.S            |    9 +-
 arch/x86/lib/memmove_64.S              |   11 +-
 arch/x86/vdso/Makefile                 |    1 +
 arch/x86/vdso/vclock_gettime.c         |  103 +++++++----
 arch/x86/vdso/vdso.S                   |   15 ++-
 arch/x86/vdso/vma.c                    |   58 ++++--
 drivers/char/hpet.c                    |    2 +-
 include/linux/clocksource.h            |   15 +-
 include/linux/seccomp.h                |   10 +
 41 files changed, 927 insertions(+), 378 deletions(-)
 create mode 100644 Documentation/ABI/stable/vdso
 create mode 100644 Documentation/vDSO/parse_vdso.c
 create mode 100644 Documentation/vDSO/vdso_test.c
 create mode 100644 Documentation/x86/entry_64.txt
 create mode 100644 arch/ia64/include/asm/clocksource.h
 create mode 100644 arch/x86/include/asm/clocksource.h
 delete mode 100644 arch/x86/kernel/vread_tsc_64.c
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

diff --git a/Documentation/ABI/stable/vdso b/Documentation/ABI/stable/vdso
new file mode 100644
index 0000000..8a1cbb5
--- /dev/null
+++ b/Documentation/ABI/stable/vdso
@@ -0,0 +1,27 @@
+On some architectures, when the kernel loads any userspace program it
+maps an ELF DSO into that program's address space.  This DSO is called
+the vDSO and it often contains useful and highly-optimized alternatives
+to real syscalls.
+
+These functions are called just like ordinary C function according to
+your platform's ABI.  Call them from a sensible context.  (For example,
+if you set CS on x86 to something strange, the vDSO functions are
+within their rights to crash.)  In addition, if you pass a bad
+pointer to a vDSO function, you might get SIGSEGV instead of -EFAULT.
+
+To find the DSO, parse the auxiliary vector passed to the program's
+entry point.  The AT_SYSINFO_EHDR entry will point to the vDSO.
+
+The vDSO uses symbol versioning; whenever you request a symbol from the
+vDSO, specify the version you are expecting.
+
+Programs that dynamically link to glibc will use the vDSO automatically.
+Otherwise, you can use the reference parser in Documentation/vDSO/parse_vdso.c.
+
+Unless otherwise noted, the set of symbols with any given version and the
+ABI of those symbols is considered stable.  It may vary across architectures,
+though.
+
+(As of this writing, this ABI documentation as been confirmed for x86_64.
+ The maintainers of the other vDSO-using architectures should confirm
+ that it is correct for their architecture.)
\ No newline at end of file
diff --git a/Documentation/vDSO/parse_vdso.c b/Documentation/vDSO/parse_vdso.c
new file mode 100644
index 0000000..8587020
--- /dev/null
+++ b/Documentation/vDSO/parse_vdso.c
@@ -0,0 +1,256 @@
+/*
+ * parse_vdso.c: Linux reference vDSO parser
+ * Written by Andrew Lutomirski, 2011.
+ *
+ * This code is meant to be linked in to various programs that run on Linux.
+ * As such, it is available with as few restrictions as possible.  This file
+ * is licensed under the Creative Commons Zero License, version 1.0,
+ * available at http://creativecommons.org/publicdomain/zero/1.0/legalcode
+ *
+ * The vDSO is a regular ELF DSO that the kernel maps into user space when
+ * it starts a program.  It works equally well in statically and dynamically
+ * linked binaries.
+ *
+ * This code is tested on x86_64.  In principle it should work on any 64-bit
+ * architecture that has a vDSO.
+ */
+
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <elf.h>
+
+/*
+ * To use this vDSO parser, first call one of the vdso_init_* functions.
+ * If you've already parsed auxv, then pass the value of AT_SYSINFO_EHDR
+ * to vdso_init_from_sysinfo_ehdr.  Otherwise pass auxv to vdso_init_from_auxv.
+ * Then call vdso_sym for each symbol you want.  For example, to look up
+ * gettimeofday on x86_64, use:
+ *
+ *     <some pointer> = vdso_sym("LINUX_2.6", "gettimeofday");
+ * or
+ *     <some pointer> = vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
+ *
+ * vdso_sym will return 0 if the symbol doesn't exist or if the init function
+ * failed or was not called.  vdso_sym is a little slow, so its return value
+ * should be cached.
+ *
+ * vdso_sym is threadsafe; the init functions are not.
+ *
+ * These are the prototypes:
+ */
+extern void vdso_init_from_auxv(void *auxv);
+extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
+extern void *vdso_sym(const char *version, const char *name);
+
+
+/* And here's the code. */
+
+#ifndef __x86_64__
+# error Not yet ported to non-x86_64 architectures
+#endif
+
+static struct vdso_info
+{
+	bool valid;
+
+	/* Load information */
+	uintptr_t load_addr;
+	uintptr_t load_offset;  /* load_addr - recorded vaddr */
+
+	/* Symbol table */
+	Elf64_Sym *symtab;
+	const char *symstrings;
+	Elf64_Word *bucket, *chain;
+	Elf64_Word nbucket, nchain;
+
+	/* Version table */
+	Elf64_Versym *versym;
+	Elf64_Verdef *verdef;
+} vdso_info;
+
+/* Straight from the ELF specification. */
+static unsigned long elf_hash(const unsigned char *name)
+{
+	unsigned long h = 0, g;
+	while (*name)
+	{
+		h = (h << 4) + *name++;
+		if (g = h & 0xf0000000)
+			h ^= g >> 24;
+		h &= ~g;
+	}
+	return h;
+}
+
+void vdso_init_from_sysinfo_ehdr(uintptr_t base)
+{
+	size_t i;
+	bool found_vaddr = false;
+
+	vdso_info.valid = false;
+
+	vdso_info.load_addr = base;
+
+	Elf64_Ehdr *hdr = (Elf64_Ehdr*)base;
+	Elf64_Phdr *pt = (Elf64_Phdr*)(vdso_info.load_addr + hdr->e_phoff);
+	Elf64_Dyn *dyn = 0;
+
+	/*
+	 * We need two things from the segment table: the load offset
+	 * and the dynamic table.
+	 */
+	for (i = 0; i < hdr->e_phnum; i++)
+	{
+		if (pt[i].p_type == PT_LOAD && !found_vaddr) {
+			found_vaddr = true;
+			vdso_info.load_offset =	base
+				+ (uintptr_t)pt[i].p_offset
+				- (uintptr_t)pt[i].p_vaddr;
+		} else if (pt[i].p_type == PT_DYNAMIC) {
+			dyn = (Elf64_Dyn*)(base + pt[i].p_offset);
+		}
+	}
+
+	if (!found_vaddr || !dyn)
+		return;  /* Failed */
+
+	/*
+	 * Fish out the useful bits of the dynamic table.
+	 */
+	Elf64_Word *hash = 0;
+	vdso_info.symstrings = 0;
+	vdso_info.symtab = 0;
+	vdso_info.versym = 0;
+	vdso_info.verdef = 0;
+	for (i = 0; dyn[i].d_tag != DT_NULL; i++) {
+		switch (dyn[i].d_tag) {
+		case DT_STRTAB:
+			vdso_info.symstrings = (const char *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_SYMTAB:
+			vdso_info.symtab = (Elf64_Sym *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_HASH:
+			hash = (Elf64_Word *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_VERSYM:
+			vdso_info.versym = (Elf64_Versym *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_VERDEF:
+			vdso_info.verdef = (Elf64_Verdef *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		}
+	}
+	if (!vdso_info.symstrings || !vdso_info.symtab || !hash)
+		return;  /* Failed */
+
+	if (!vdso_info.verdef)
+		vdso_info.versym = 0;
+
+	/* Parse the hash table header. */
+	vdso_info.nbucket = hash[0];
+	vdso_info.nchain = hash[1];
+	vdso_info.bucket = &hash[2];
+	vdso_info.chain = &hash[vdso_info.nbucket + 2];
+
+	/* That's all we need. */
+	vdso_info.valid = true;
+}
+
+static bool vdso_match_version(Elf64_Versym ver,
+			       const char *name, Elf64_Word hash)
+{
+	/*
+	 * This is a helper function to check if the version indexed by
+	 * ver matches name (which hashes to hash).
+	 *
+	 * The version definition table is a mess, and I don't know how
+	 * to do this in better than linear time without allocating memory
+	 * to build an index.  I also don't know why the table has
+	 * variable size entries in the first place.
+	 *
+	 * For added fun, I can't find a comprehensible specification of how
+	 * to parse all the weird flags in the table.
+	 *
+	 * So I just parse the whole table every time.
+	 */
+
+	/* First step: find the version definition */
+	ver &= 0x7fff;  /* Apparently bit 15 means "hidden" */
+	Elf64_Verdef *def = vdso_info.verdef;
+	while(true) {
+		if ((def->vd_flags & VER_FLG_BASE) == 0
+		    && (def->vd_ndx & 0x7fff) == ver)
+			break;
+
+		if (def->vd_next == 0)
+			return false;  /* No definition. */
+
+		def = (Elf64_Verdef *)((char *)def + def->vd_next);
+	}
+
+	/* Now figure out whether it matches. */
+	Elf64_Verdaux *aux = (Elf64_Verdaux*)((char *)def + def->vd_aux);
+	return def->vd_hash == hash
+		&& !strcmp(name, vdso_info.symstrings + aux->vda_name);
+}
+
+void *vdso_sym(const char *version, const char *name)
+{
+	unsigned long ver_hash;
+	if (!vdso_info.valid)
+		return 0;
+
+	ver_hash = elf_hash(version);
+	Elf64_Word chain = vdso_info.bucket[elf_hash(name) % vdso_info.nbucket];
+
+	for (; chain != STN_UNDEF; chain = vdso_info.chain[chain]) {
+		Elf64_Sym *sym = &vdso_info.symtab[chain];
+
+		/* Check for a defined global or weak function w/ right name. */
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
+			continue;
+		if (ELF64_ST_BIND(sym->st_info) != STB_GLOBAL &&
+		    ELF64_ST_BIND(sym->st_info) != STB_WEAK)
+			continue;
+		if (sym->st_shndx == SHN_UNDEF)
+			continue;
+		if (strcmp(name, vdso_info.symstrings + sym->st_name))
+			continue;
+
+		/* Check symbol version. */
+		if (vdso_info.versym
+		    && !vdso_match_version(vdso_info.versym[chain],
+					   version, ver_hash))
+			continue;
+
+		return (void *)(vdso_info.load_offset + sym->st_value);
+	}
+
+	return 0;
+}
+
+void vdso_init_from_auxv(void *auxv)
+{
+	Elf64_auxv_t *elf_auxv = auxv;
+	for (int i = 0; elf_auxv[i].a_type != AT_NULL; i++)
+	{
+		if (elf_auxv[i].a_type == AT_SYSINFO_EHDR) {
+			vdso_init_from_sysinfo_ehdr(elf_auxv[i].a_un.a_val);
+			return;
+		}
+	}
+
+	vdso_info.valid = false;
+}
diff --git a/Documentation/vDSO/vdso_test.c b/Documentation/vDSO/vdso_test.c
new file mode 100644
index 0000000..fff6334
--- /dev/null
+++ b/Documentation/vDSO/vdso_test.c
@@ -0,0 +1,111 @@
+/*
+ * vdso_test.c: Sample code to test parse_vdso.c on x86_64
+ * Copyright (c) 2011 Andy Lutomirski
+ * Subject to the GNU General Public License, version 2
+ *
+ * You can amuse yourself by compiling with:
+ * gcc -std=gnu99 -nostdlib
+ *     -Os -fno-asynchronous-unwind-tables -flto
+ *      vdso_test.c parse_vdso.c -o vdso_test
+ * to generate a small binary with no dependencies at all.
+ */
+
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <stdint.h>
+
+extern void *vdso_sym(const char *version, const char *name);
+extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
+extern void vdso_init_from_auxv(void *auxv);
+
+/* We need a libc functions... */
+int strcmp(const char *a, const char *b)
+{
+	/* This implementation is buggy: it never returns -1. */
+	while (*a || *b) {
+		if (*a != *b)
+			return 1;
+		if (*a == 0 || *b == 0)
+			return 1;
+		a++;
+		b++;
+	}
+
+	return 0;
+}
+
+/* ...and two syscalls.  This is x86_64-specific. */
+static inline long linux_write(int fd, const void *data, size_t len)
+{
+
+	long ret;
+	asm volatile ("syscall" : "=a" (ret) : "a" (__NR_write),
+		      "D" (fd), "S" (data), "d" (len) :
+		      "cc", "memory", "rcx",
+		      "r8", "r9", "r10", "r11" );
+	return ret;
+}
+
+static inline void linux_exit(int code)
+{
+	asm volatile ("syscall" : : "a" (__NR_exit), "D" (code));
+}
+
+void to_base10(char *lastdig, uint64_t n)
+{
+	while (n) {
+		*lastdig = (n % 10) + '0';
+		n /= 10;
+		lastdig--;
+	}
+}
+
+__attribute__((externally_visible)) void c_main(void **stack)
+{
+	/* Parse the stack */
+	long argc = (long)*stack;
+	stack += argc + 2;
+
+	/* Now we're pointing at the environment.  Skip it. */
+	while(*stack)
+		stack++;
+	stack++;
+
+	/* Now we're pointing at auxv.  Initialize the vDSO parser. */
+	vdso_init_from_auxv((void *)stack);
+
+	/* Find gettimeofday. */
+	typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
+	gtod_t gtod = (gtod_t)vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
+
+	if (!gtod)
+		linux_exit(1);
+
+	struct timeval tv;
+	long ret = gtod(&tv, 0);
+
+	if (ret == 0) {
+		char buf[] = "The time is                     .000000\n";
+		to_base10(buf + 31, tv.tv_sec);
+		to_base10(buf + 38, tv.tv_usec);
+		linux_write(1, buf, sizeof(buf) - 1);
+	} else {
+		linux_exit(ret);
+	}
+
+	linux_exit(0);
+}
+
+/*
+ * This is the real entry point.  It passes the initial stack into
+ * the C entry point.
+ */
+asm (
+	".text\n"
+	".global _start\n"
+        ".type _start,@function\n"
+        "_start:\n\t"
+        "mov %rsp,%rdi\n\t"
+        "jmp c_main"
+	);
diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
new file mode 100644
index 0000000..7869f14
--- /dev/null
+++ b/Documentation/x86/entry_64.txt
@@ -0,0 +1,98 @@
+This file documents some of the kernel entries in
+arch/x86/kernel/entry_64.S.  A lot of this explanation is adapted from
+an email from Ingo Molnar:
+
+http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
+
+The x86 architecture has quite a few different ways to jump into
+kernel code.  Most of these entry points are registered in
+arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
+and arch/x86/ia32/ia32entry.S.
+
+The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+
+Some of these entries are:
+
+ - system_call: syscall instruction from 64-bit code.
+
+ - ia32_syscall: int 0x80 from 32-bit or 64-bit code; compat syscall
+   either way.
+
+ - ia32_syscall, ia32_sysenter: syscall and sysenter from 32-bit
+   code
+
+ - interrupt: An array of entries.  Every IDT vector that doesn't
+   explicitly point somewhere else gets set to the corresponding
+   value in interrupts.  These point to a whole array of
+   magically-generated functions that make their way to do_IRQ with
+   the interrupt number as a parameter.
+
+ - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
+   vsyscall emulation.
+
+ - APIC interrupts: Various special-purpose interrupts for things
+   like TLB shootdown.
+
+ - Architecturally-defined exceptions like divide_error.
+
+There are a few complexities here.  The different x86-64 entries
+have different calling conventions.  The syscall and sysenter
+instructions have their own peculiar calling conventions.  Some of
+the IDT entries push an error code onto the stack; others don't.
+IDT entries using the IST alternative stack mechanism need their own
+magic to get the stack frames right.  (You can find some
+documentation in the AMD APM, Volume 2, Chapter 8 and the Intel SDM,
+Volume 3, Chapter 6.)
+
+Dealing with the swapgs instruction is especially tricky.  Swapgs
+toggles whether gs is the kernel gs or the user gs.  The swapgs
+instruction is rather fragile: it must nest perfectly and only in
+single depth, it should only be used if entering from user mode to
+kernel mode and then when returning to user-space, and precisely
+so. If we mess that up even slightly, we crash.
+
+So when we have a secondary entry, already in kernel mode, we *must
+not* use SWAPGS blindly - nor must we forget doing a SWAPGS when it's
+not switched/swapped yet.
+
+Now, there's a secondary complication: there's a cheap way to test
+which mode the CPU is in and an expensive way.
+
+The cheap way is to pick this info off the entry frame on the kernel
+stack, from the CS of the ptregs area of the kernel stack:
+
+	xorl %ebx,%ebx
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
+	SWAPGS
+
+The expensive (paranoid) way is to read back the MSR_GS_BASE value
+(which is what SWAPGS modifies):
+
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f   /* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+
+and the whole paranoid non-paranoid macro complexity is about whether
+to suffer that RDMSR cost.
+
+If we are at an interrupt or user-trap/gate-alike boundary then we can
+use the faster check: the stack will be a reliable indicator of
+whether SWAPGS was already done: if we see that we are a secondary
+entry interrupting kernel mode execution, then we know that the GS
+base has already been switched. If it says that we interrupted
+user-space execution then we must do the SWAPGS.
+
+But if we are in an NMI/MCE/DEBUG/whatever super-atomic entry context,
+which might have triggered right after a normal entry wrote CS to the
+stack but before we executed SWAPGS, then the only safe way to check
+for GS is the slower method: the RDMSR.
+
+So we try only to mark those entry methods 'paranoid' that absolutely
+need the more expensive check for the GS base - and we generate all
+'normal' entry points with the regular (faster) entry macros.
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 38280ef..0a9820a 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -101,6 +101,9 @@ config GENERIC_IOMAP
 	bool
 	default y
 
+config ARCH_CLOCKSOURCE_DATA
+	def_bool y
+
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
diff --git a/arch/ia64/include/asm/clocksource.h b/arch/ia64/include/asm/clocksource.h
new file mode 100644
index 0000000..5c8596e
--- /dev/null
+++ b/arch/ia64/include/asm/clocksource.h
@@ -0,0 +1,10 @@
+/* IA64-specific clocksource additions */
+
+#ifndef _ASM_IA64_CLOCKSOURCE_H
+#define _ASM_IA64_CLOCKSOURCE_H
+
+struct arch_clocksource_data {
+	void *fsys_mmio;        /* used by fsyscall asm code */
+};
+
+#endif /* _ASM_IA64_CLOCKSOURCE_H */
diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index f64097b..4826ff9 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -115,7 +115,7 @@ int __init init_cyclone_clock(void)
 	}
 	/* initialize last tick */
 	cyclone_mc = cyclone_timer;
-	clocksource_cyclone.fsys_mmio = cyclone_timer;
+	clocksource_cyclone.archdata.fsys_mmio = cyclone_timer;
 	clocksource_register_hz(&clocksource_cyclone, CYCLONE_TIMER_FREQ);
 
 	return 0;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 85118df..43920de 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -468,7 +468,7 @@ void update_vsyscall(struct timespec *wall, struct timespec *wtm,
         fsyscall_gtod_data.clk_mask = c->mask;
         fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
-        fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
+        fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
 
 	/* copy kernel time structures */
diff --git a/arch/ia64/sn/kernel/sn2/timer.c b/arch/ia64/sn/kernel/sn2/timer.c
index c34efda..0f8844e 100644
--- a/arch/ia64/sn/kernel/sn2/timer.c
+++ b/arch/ia64/sn/kernel/sn2/timer.c
@@ -54,7 +54,7 @@ ia64_sn_udelay (unsigned long usecs)
 
 void __init sn_timer_init(void)
 {
-	clocksource_sn2.fsys_mmio = RTC_COUNTER_ADDR;
+	clocksource_sn2.archdata.fsys_mmio = RTC_COUNTER_ADDR;
 	clocksource_register_hz(&clocksource_sn2, sn_rtc_cycles_per_second);
 
 	ia64_udelay = &ia64_sn_udelay;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..c1e41bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,6 +93,10 @@ config CLOCKSOURCE_WATCHDOG
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
+config ARCH_CLOCKSOURCE_DATA
+	def_bool y
+	depends on X86_64
+
 config GENERIC_CLOCKEVENTS_BROADCAST
 	def_bool y
 	depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 94d420b..4554cc6 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -17,8 +17,8 @@
 
 .macro altinstruction_entry orig alt feature orig_len alt_len
 	.align 8
-	.quad \orig
-	.quad \alt
+	.long \orig - .
+	.long \alt - .
 	.word \feature
 	.byte \orig_len
 	.byte \alt_len
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index bf535f9..23fb6d7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -43,8 +43,8 @@
 #endif
 
 struct alt_instr {
-	u8 *instr;		/* original instruction */
-	u8 *replacement;
+	s32 instr_offset;	/* original instruction */
+	s32 repl_offset;	/* offset to replacement instruction */
 	u16 cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen;	/* length of new instruction, <= instrlen */
@@ -84,8 +84,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
       "661:\n\t" oldinstr "\n662:\n"					\
       ".section .altinstructions,\"a\"\n"				\
       _ASM_ALIGN "\n"							\
-      _ASM_PTR "661b\n"				/* label           */	\
-      _ASM_PTR "663f\n"				/* new instruction */	\
+      "	 .long 661b - .\n"			/* label           */	\
+      "	 .long 663f - .\n"			/* new instruction */	\
       "	 .word " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
new file mode 100644
index 0000000..0bdbbb3
--- /dev/null
+++ b/arch/x86/include/asm/clocksource.h
@@ -0,0 +1,18 @@
+/* x86-specific clocksource additions */
+
+#ifndef _ASM_X86_CLOCKSOURCE_H
+#define _ASM_X86_CLOCKSOURCE_H
+
+#ifdef CONFIG_X86_64
+
+#define VCLOCK_NONE 0  /* No vDSO clock available.	*/
+#define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
+#define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
+
+struct arch_clocksource_data {
+	int vclock_mode;
+};
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_CLOCKSOURCE_H */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 71cc380..9929b35 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -331,8 +331,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 _ASM_ALIGN "\n"
-			 _ASM_PTR "1b\n"
-			 _ASM_PTR "0\n" 	/* no replacement */
+			 " .long 1b - .\n"
+			 " .long 0\n"		/* no replacement */
 			 " .word %P0\n"		/* feature bit */
 			 " .byte 2b - 1b\n"	/* source len */
 			 " .byte 0\n"		/* replacement len */
@@ -349,8 +349,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			     "2:\n"
 			     ".section .altinstructions,\"a\"\n"
 			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b\n"
-			     _ASM_PTR "3f\n"
+			     " .long 1b - .\n"
+			     " .long 3f - .\n"
 			     " .word %P1\n"		/* feature bit */
 			     " .byte 2b - 1b\n"		/* source len */
 			     " .byte 4f - 3f\n"		/* replacement len */
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4729b2b..460c74e 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -78,6 +78,7 @@ enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+	VVAR_PAGE,
 	VSYSCALL_HPET,
 #endif
 	FIX_DBGP_BASE,
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..a563c50 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -17,7 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
+ *  Vector  204         : legacy x86_64 vsyscall emulation
+ *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
  *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
@@ -50,6 +51,9 @@
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
 #endif
+#ifdef CONFIG_X86_64
+# define VSYSCALL_EMU_VECTOR		0xcc
+#endif
 
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index d56187c..013286a 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -107,7 +107,8 @@
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
+#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -129,7 +130,8 @@
 #define PAGE_KERNEL_LARGE_NOCACHE	__pgprot(__PAGE_KERNEL_LARGE_NOCACHE)
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
+#define PAGE_KERNEL_VVAR_NOCACHE	__pgprot(__PAGE_KERNEL_VVAR_NOCACHE)
 
 #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0310da6..2bae0a5 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_TRAPS_H
 #define _ASM_X86_TRAPS_H
 
+#include <linux/kprobes.h>
+
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
@@ -38,6 +40,7 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
+asmlinkage void emulate_vsyscall(void);
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -64,6 +67,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *, long);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9db5583..83e2efd 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -51,10 +51,6 @@ extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
 
-#ifdef CONFIG_X86_64
-extern cycles_t vread_tsc(void);
-#endif
-
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 646b4c1..815285b 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -11,10 +11,9 @@ struct vsyscall_gtod_data {
 	time_t		wall_time_sec;
 	u32		wall_time_nsec;
 
-	int		sysctl_enabled;
 	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
-		cycle_t (*vread)(void);
+		int vclock_mode;
 		cycle_t	cycle_last;
 		cycle_t	mask;
 		u32	mult;
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d555973..6010707 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -16,10 +16,6 @@ enum vsyscall_num {
 #ifdef __KERNEL__
 #include <linux/seqlock.h>
 
-/* Definitions for CONFIG_GENERIC_TIME definitions */
-#define __vsyscall_fn \
-	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
-
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..de656ac 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -10,15 +10,14 @@
  * In normal kernel code, they are used like any other variable.
  * In user code, they are accessed through the VVAR macro.
  *
- * Each of these variables lives in the vsyscall page, and each
- * one needs a unique offset within the little piece of the page
- * reserved for vvars.  Specify that offset in DECLARE_VVAR.
- * (There are 896 bytes available.  If you mess up, the linker will
- * catch it.)
+ * These variables live in a page of kernel data that has an extra RO
+ * mapping for userspace.  Each variable needs a unique offset within
+ * that page; specify that offset with the DECLARE_VVAR macro.  (If
+ * you mess up, the linker will catch it.)
  */
 
-/* Offset of vars within vsyscall page */
-#define VSYSCALL_VARS_OFFSET (3072 + 128)
+/* Base address of vvars.  This is not ABI. */
+#define VVAR_ADDRESS (-10*1024*1024 - 4096)
 
 #if defined(__VVAR_KERNEL_LDS)
 
@@ -26,17 +25,17 @@
  * right place.
  */
 #define DECLARE_VVAR(offset, type, name) \
-	EMIT_VVAR(name, VSYSCALL_VARS_OFFSET + offset)
+	EMIT_VVAR(name, offset)
 
 #else
 
 #define DECLARE_VVAR(offset, type, name)				\
 	static type const * const vvaraddr_ ## name =			\
-		(void *)(VSYSCALL_START + VSYSCALL_VARS_OFFSET + (offset));
+		(void *)(VVAR_ADDRESS + (offset));
 
 #define DEFINE_VVAR(type, name)						\
-	type __vvar_ ## name						\
-	__attribute__((section(".vsyscall_var_" #name), aligned(16)))
+	type name							\
+	__attribute__((section(".vvar_" #name), aligned(16)))
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
@@ -45,8 +44,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-#undef VSYSCALL_VARS_OFFSET
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..2deef3d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,17 +24,12 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
-CFLAGS_vread_tsc_64.o	:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
-GCOV_PROFILE_vread_tsc_64.o	:= n
 GCOV_PROFILE_paravirt.o		:= n
 
-# vread_tsc_64 is hot and should be fully optimized:
-CFLAGS_REMOVE_vread_tsc_64.o = -pg -fno-optimize-sibling-calls
-
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
@@ -43,7 +38,8 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a81f2d5..c638228 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -14,7 +14,6 @@
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
-#include <asm/vsyscall.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
@@ -250,7 +249,6 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-extern char __vsyscall_0;
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -263,6 +261,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 					 struct alt_instr *end)
 {
 	struct alt_instr *a;
+	u8 *instr, *replacement;
 	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
@@ -276,25 +275,23 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	 * order.
 	 */
 	for (a = start; a < end; a++) {
-		u8 *instr = a->instr;
+		instr = (u8 *)&a->instr_offset + a->instr_offset;
+		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
 		BUG_ON(a->cpuid >= NCAPINTS*32);
 		if (!boot_cpu_has(a->cpuid))
 			continue;
-#ifdef CONFIG_X86_64
-		/* vsyscall code is not mapped yet. resolve it manually. */
-		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
-			instr = __va(instr - (u8*)VSYSCALL_START + (u8*)__pa_symbol(&__vsyscall_0));
-			DPRINTK("%s: vsyscall fixup: %p => %p\n",
-				__func__, a->instr, instr);
-		}
-#endif
-		memcpy(insnbuf, a->replacement, a->replacementlen);
+
+		memcpy(insnbuf, replacement, a->replacementlen);
+
+		/* 0xe8 is a relative jump; fix the offset. */
 		if (*insnbuf == 0xe8 && a->replacementlen == 5)
-		    *(s32 *)(insnbuf + 1) += a->replacement - a->instr;
+		    *(s32 *)(insnbuf + 1) += replacement - instr;
+
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
+
 		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..e949793 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -9,6 +9,8 @@
 /*
  * entry.S contains the system-call and fault low-level handling routines.
  *
+ * Some of this is documented in Documentation/x86/entry_64.txt
+ *
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
  *
@@ -1121,6 +1123,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry emulate_vsyscall do_emulate_vsyscall
+
 
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..d10cc00 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -71,7 +71,7 @@ static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
 #ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
 #endif
 }
 
@@ -738,13 +738,6 @@ static cycle_t read_hpet(struct clocksource *cs)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
-#ifdef CONFIG_X86_64
-static cycle_t __vsyscall_fn vread_hpet(void)
-{
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
-}
-#endif
-
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -753,7 +746,7 @@ static struct clocksource clocksource_hpet = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
-	.vread		= vread_hpet,
+	.archdata	= { .vclock_mode = VCLOCK_HPET },
 #endif
 };
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..fbc097a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,6 +872,12 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
+#ifdef CONFIG_X86_64
+	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
+	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
+#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6cc6922..56c633a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -777,7 +777,7 @@ static struct clocksource clocksource_tsc = {
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 #ifdef CONFIG_X86_64
-	.vread                  = vread_tsc,
+	.archdata               = { .vclock_mode = VCLOCK_TSC },
 #endif
 };
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 89aed99..4aa9c54 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -161,50 +161,47 @@ SECTIONS
 
 #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-#define EMIT_VVAR(x, offset) .vsyscall_var_ ## x	\
-	ADDR(.vsyscall_0) + offset		 	\
-	: AT(VLOAD(.vsyscall_var_ ## x)) {     		\
-		*(.vsyscall_var_ ## x)			\
-	}						\
-	x = VVIRT(.vsyscall_var_ ## x);
 
 	. = ALIGN(4096);
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
+	.vsyscall : AT(VLOAD(.vsyscall)) {
 		*(.vsyscall_0)
-	} :user
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
-		*(.vsyscall_fn)
-	}
-
-	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		. = 1024;
 		*(.vsyscall_1)
-	}
-	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
-		*(.vsyscall_2)
-	}
 
-	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
-	}
-
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
+		. = 2048;
+		*(.vsyscall_2)
 
-	. = __vsyscall_0 + PAGE_SIZE;
+		. = 4096;  /* Pad the whole page. */
+	} :user =0xcc
+	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
 #undef VLOAD_OFFSET
 #undef VLOAD
 #undef VVIRT_OFFSET
 #undef VVIRT
+
+	__vvar_page = .;
+
+	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+
+	      /* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 		\
+		. = offset;		\
+		*(.vvar_ ## name)
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
+	} :data
+
+       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+
 #endif /* CONFIG_X86_64 */
 
 	/* Init code and data - will be freed after init */
diff --git a/arch/x86/kernel/vread_tsc_64.c b/arch/x86/kernel/vread_tsc_64.c
deleted file mode 100644
index a81aa9e..0000000
--- a/arch/x86/kernel/vread_tsc_64.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/* This code runs in userspace. */
-
-#define DISABLE_BRANCH_PROFILING
-#include <asm/vgtod.h>
-
-notrace cycle_t __vsyscall_fn vread_tsc(void)
-{
-	cycle_t ret;
-	u64 last;
-
-	/*
-	 * Empirically, a fence (of type that depends on the CPU)
-	 * before rdtsc is enough to ensure that rdtsc is ordered
-	 * with respect to loads.  The various CPU manuals are unclear
-	 * as to whether rdtsc can be reordered with later loads,
-	 * but no one has ever seen it happen.
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
-
-	if (likely(ret >= last))
-		return ret;
-
-	/*
-	 * GCC likes to generate cmov here, but this branch is extremely
-	 * predictable (it's just a funciton of time and the likely is
-	 * very likely) and there's a data dependence, so force GCC
-	 * to generate a branch instead.  I don't barrier() because
-	 * we don't actually need a barrier, and if this function
-	 * ever gets inlined it will generate worse code.
-	 */
-	asm volatile ("");
-	return last;
-}
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e68218..dda7dff 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -2,6 +2,8 @@
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *
+ *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ *
  *  Thanks to hpa@transmeta.com for some useful hint.
  *  Special thanks to Ingo Molnar for his early experience with
  *  a different vsyscall implementation for Linux/IA32 and for the name.
@@ -11,10 +13,9 @@
  *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
  *  jumping out of line if necessary. We cannot add more with this
  *  mechanism because older kernels won't return -ENOSYS.
- *  If we want more than four we need a vDSO.
  *
- *  Note: the concept clashes with user mode linux. If you use UML and
- *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
+ *  Note: the concept clashes with user mode linux.  UML users should
+ *  use the vDSO.
  */
 
 /* Disable profiling for userspace code: */
@@ -32,9 +33,12 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/syscalls.h>
+#include <linux/ratelimit.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
+#include <asm/compat.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
@@ -44,16 +48,12 @@
 #include <asm/desc.h>
 #include <asm/topology.h>
 #include <asm/vgtod.h>
-
-#define __vsyscall(nr) \
-		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
-#define __syscall_clobber "r11","cx","memory"
+#include <asm/traps.h>
 
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
-	.sysctl_enabled = 1,
 };
 
 void update_vsyscall_tz(void)
@@ -72,179 +72,149 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	unsigned long flags;
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vread = clock->vread;
-	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
-	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = mult;
-	vsyscall_gtod_data.clock.shift = clock->shift;
-	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic = *wtm;
-	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
+	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
+	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
+	vsyscall_gtod_data.clock.mask		= clock->mask;
+	vsyscall_gtod_data.clock.mult		= mult;
+	vsyscall_gtod_data.clock.shift		= clock->shift;
+	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
+	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
+	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
+	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
+
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-/* RED-PEN may want to readd seq locking, but then the variable should be
- * write-once.
- */
-static __always_inline void do_get_tz(struct timezone * tz)
+static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
+			      const char *message)
 {
-	*tz = VVAR(vsyscall_gtod_data).sys_tz;
-}
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
+	struct task_struct *tsk;
 
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
-{
-	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
-	return ret;
-}
+	if (!show_unhandled_signals || !__ratelimit(&rs))
+		return;
 
-static __always_inline long time_syscall(long *t)
-{
-	long secs;
-	asm volatile("syscall"
-		: "=a" (secs)
-		: "0" (__NR_time),"D" (t) : __syscall_clobber);
-	return secs;
-}
+	tsk = current;
 
-static __always_inline void do_vgettimeofday(struct timeval * tv)
-{
-	cycle_t now, base, mask, cycle_delta;
-	unsigned seq;
-	unsigned long mult, shift, nsec;
-	cycle_t (*vread)(void);
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
-
-		vread = VVAR(vsyscall_gtod_data).clock.vread;
-		if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled ||
-			     !vread)) {
-			gettimeofday(tv,NULL);
-			return;
-		}
-
-		now = vread();
-		base = VVAR(vsyscall_gtod_data).clock.cycle_last;
-		mask = VVAR(vsyscall_gtod_data).clock.mask;
-		mult = VVAR(vsyscall_gtod_data).clock.mult;
-		shift = VVAR(vsyscall_gtod_data).clock.shift;
-
-		tv->tv_sec = VVAR(vsyscall_gtod_data).wall_time_sec;
-		nsec = VVAR(vsyscall_gtod_data).wall_time_nsec;
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
-
-	/* calculate interval: */
-	cycle_delta = (now - base) & mask;
-	/* convert to nsecs: */
-	nsec += (cycle_delta * mult) >> shift;
-
-	while (nsec >= NSEC_PER_SEC) {
-		tv->tv_sec += 1;
-		nsec -= NSEC_PER_SEC;
-	}
-	tv->tv_usec = nsec / NSEC_PER_USEC;
+	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	       level, tsk->comm, task_pid_nr(tsk),
+	       message, regs->ip - 2, regs->cs,
+	       regs->sp, regs->ax, regs->si, regs->di);
 }
 
-int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
+static int addr_to_vsyscall_nr(unsigned long addr)
 {
-	if (tv)
-		do_vgettimeofday(tv);
-	if (tz)
-		do_get_tz(tz);
-	return 0;
-}
+	int nr;
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-time_t __vsyscall(1) vtime(time_t *t)
-{
-	unsigned seq;
-	time_t result;
-	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
-		return time_syscall(t);
+	if ((addr & ~0xC00UL) != VSYSCALL_START)
+		return -EINVAL;
 
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
+	nr = (addr & 0xC00UL) >> 10;
+	if (nr >= 3)
+		return -EINVAL;
 
-		result = VVAR(vsyscall_gtod_data).wall_time_sec;
+	return nr;
+}
 
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
+{
+	struct task_struct *tsk;
+	unsigned long caller;
+	int vsyscall_nr;
+	long ret;
+
+	local_irq_enable();
+
+	/*
+	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
+	 * is bogus.
+	 */
+	if (regs->cs != __USER_CS) {
+		/*
+		 * If we trapped from kernel mode, we might as well OOPS now
+		 * instead of returning to some random address and OOPSing
+		 * then.
+		 */
+		BUG_ON(!user_mode(regs));
+
+		/* Compat mode and non-compat 32-bit CS should both segfault. */
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc from 32-bit mode");
+		goto sigsegv;
+	}
 
-	if (t)
-		*t = result;
-	return result;
-}
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
+	 * and int 0xcc is two bytes long.
+	 */
+	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
+	if (vsyscall_nr < 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc (exploit attempt?)");
+		goto sigsegv;
+	}
 
-/* Fast way to get current CPU and node.
-   This helps to do per node and per CPU caches in user space.
-   The result is not guaranteed without CPU affinity, but usually
-   works out because the scheduler tries to keep a thread on the same
-   CPU.
+	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
+		goto sigsegv;
+	}
 
-   tcache must point to a two element sized long array.
-   All arguments can be NULL. */
-long __vsyscall(2)
-vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
-{
-	unsigned int p;
-	unsigned long j = 0;
-
-	/* Fast cache - only recompute value once per jiffies and avoid
-	   relatively costly rdtscp/cpuid otherwise.
-	   This works because the scheduler usually keeps the process
-	   on the same CPU and this syscall doesn't guarantee its
-	   results anyways.
-	   We do this here because otherwise user space would do it on
-	   its own in a likely inferior way (no access to jiffies).
-	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = VVAR(jiffies))) {
-		p = tcache->blob[1];
-	} else if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	tsk = current;
+	if (seccomp_mode(&tsk->seccomp))
+		do_exit(SIGKILL);
+
+	switch (vsyscall_nr) {
+	case 0:
+		ret = sys_gettimeofday(
+			(struct timeval __user *)regs->di,
+			(struct timezone __user *)regs->si);
+		break;
+
+	case 1:
+		ret = sys_time((time_t __user *)regs->di);
+		break;
+
+	case 2:
+		ret = sys_getcpu((unsigned __user *)regs->di,
+				 (unsigned __user *)regs->si,
+				 0);
+		break;
 	}
-	if (tcache) {
-		tcache->blob[0] = j;
-		tcache->blob[1] = p;
+
+	if (ret == -EFAULT) {
+		/*
+		 * Bad news -- userspace fed a bad pointer to a vsyscall.
+		 *
+		 * With a real vsyscall, that would have caused SIGSEGV.
+		 * To make writing reliable exploits using the emulated
+		 * vsyscalls harder, generate SIGSEGV here as well.
+		 */
+		warn_bad_vsyscall(KERN_INFO, regs,
+				  "vsyscall fault (exploit attempt?)");
+		goto sigsegv;
 	}
-	if (cpu)
-		*cpu = p & 0xfff;
-	if (node)
-		*node = p >> 12;
-	return 0;
-}
 
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
-}
+	regs->ax = ret;
 
-#ifdef CONFIG_SYSCTL
-static ctl_table kernel_table2[] = {
-	{ .procname = "vsyscall64",
-	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644,
-	  .proc_handler = proc_dointvec },
-	{}
-};
+	/* Emulate a ret instruction. */
+	regs->ip = caller;
+	regs->sp += 8;
 
-static ctl_table kernel_root_table2[] = {
-	{ .procname = "kernel", .mode = 0555,
-	  .child = kernel_table2 },
-	{}
-};
-#endif
+	local_irq_disable();
+	return;
+
+sigsegv:
+	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
+	force_sig(SIGSEGV, current);
+	local_irq_disable();
+}
 
-/* Assume __initcall executes before all user space. Hopefully kmod
-   doesn't violate that. We'll find out if it does. */
+/*
+ * Assume __initcall executes before all user space. Hopefully kmod
+ * doesn't violate that. We'll find out if it does.
+ */
 static void __cpuinit vsyscall_set_cpu(int cpu)
 {
 	unsigned long d;
@@ -255,13 +225,15 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
 		write_rdtscp_aux((node << 12) | cpu);
 
-	/* Store cpu number in limit so that it can be loaded quickly
-	   in user space in vgetcpu.
-	   12 bits for the CPU and 8 bits for the node. */
+	/*
+	 * Store cpu number in limit so that it can be loaded quickly
+	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
+	 */
 	d = 0x0f40000000000ULL;
 	d |= cpu;
 	d |= (node & 0xf) << 12;
 	d |= (node >> 4) << 48;
+
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
@@ -275,8 +247,10 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
+
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+
 	return NOTIFY_DONE;
 }
 
@@ -284,25 +258,23 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_0;
 	unsigned long physaddr_page0 = __pa_symbol(&__vsyscall_0);
+	extern char __vvar_page;
+	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
 	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
+	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) != (unsigned long)VVAR_ADDRESS);
 }
 
 static int __init vsyscall_init(void)
 {
-	BUG_ON(((unsigned long) &vgettimeofday !=
-			VSYSCALL_ADDR(__NR_vgettimeofday)));
-	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
-	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
-	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
-#ifdef CONFIG_SYSCTL
-	register_sysctl_table(kernel_root_table2);
-#endif
+	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
+
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
+
 	return 0;
 }
-
 __initcall(vsyscall_init);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
new file mode 100644
index 0000000..ffa845e
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -0,0 +1,27 @@
+/*
+ * vsyscall_emu_64.S: Vsyscall emulation page
+ *
+ * Copyright (c) 2011 Andy Lutomirski
+ *
+ * Subject to the GNU General Public License, version 2
+ */
+
+#include <linux/linkage.h>
+#include <asm/irq_vectors.h>
+
+/* The unused parts of the page are filled with 0xcc by the linker script. */
+
+.section .vsyscall_0, "a"
+ENTRY(vsyscall_0)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_0)
+
+.section .vsyscall_1, "a"
+ENTRY(vsyscall_1)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_1)
+
+.section .vsyscall_2, "a"
+ENTRY(vsyscall_2)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_2)
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6fec2d1..01c805b 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -2,6 +2,7 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 	ALIGN
 copy_page_c:
@@ -110,10 +111,6 @@ ENDPROC(copy_page)
 2:
 	.previous
 	.section .altinstructions,"a"
-	.align 8
-	.quad copy_page
-	.quad 1b
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lcopy_page_end - copy_page
-	.byte 2b - 1b
+	altinstruction_entry copy_page, 1b, X86_FEATURE_REP_GOOD,	\
+		.Lcopy_page_end-copy_page, 2b-1b
 	.previous
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index d0ec9c2..ee16461 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 #undef memmove
 
@@ -214,11 +215,9 @@ ENTRY(memmove)
 	.previous
 
 	.section .altinstructions,"a"
-	.align 8
-	.quad .Lmemmove_begin_forward
-	.quad .Lmemmove_begin_forward_efs
-	.word X86_FEATURE_ERMS
-	.byte .Lmemmove_end_forward-.Lmemmove_begin_forward
-	.byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
+	altinstruction_entry .Lmemmove_begin_forward,		\
+		.Lmemmove_begin_forward_efs,X86_FEATURE_ERMS,	\
+		.Lmemmove_end_forward-.Lmemmove_begin_forward,	\
+		.Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
 	.previous
 ENDPROC(memmove)
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index bef0bc9..5d17950 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -26,6 +26,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+			-Wl,--no-undefined \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index a724905..6bc0e72 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -6,7 +6,6 @@
  *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
- * Also alternative() doesn't work.
  */
 
 /* Disable profiling for userspace code: */
@@ -17,6 +16,7 @@
 #include <linux/time.h>
 #include <linux/string.h>
 #include <asm/vsyscall.h>
+#include <asm/fixmap.h>
 #include <asm/vgtod.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
@@ -25,6 +25,43 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
+notrace static cycle_t vread_tsc(void)
+{
+	cycle_t ret;
+	u64 last;
+
+	/*
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
+
+	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
+}
+
+static notrace cycle_t vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
@@ -36,9 +73,12 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 notrace static inline long vgetns(void)
 {
 	long v;
-	cycles_t (*vread)(void);
-	vread = gtod->clock.vread;
-	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
+	cycles_t cycles;
+	if (gtod->clock.vclock_mode == VCLOCK_TSC)
+		cycles = vread_tsc();
+	else
+		cycles = vread_hpet();
+	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
@@ -116,21 +156,21 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled))
-		switch (clock) {
-		case CLOCK_REALTIME:
-			if (likely(gtod->clock.vread))
-				return do_realtime(ts);
-			break;
-		case CLOCK_MONOTONIC:
-			if (likely(gtod->clock.vread))
-				return do_monotonic(ts);
-			break;
-		case CLOCK_REALTIME_COARSE:
-			return do_realtime_coarse(ts);
-		case CLOCK_MONOTONIC_COARSE:
-			return do_monotonic_coarse(ts);
-		}
+	switch (clock) {
+	case CLOCK_REALTIME:
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
+			return do_realtime(ts);
+		break;
+	case CLOCK_MONOTONIC:
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
+			return do_monotonic(ts);
+		break;
+	case CLOCK_REALTIME_COARSE:
+		return do_realtime_coarse(ts);
+	case CLOCK_MONOTONIC_COARSE:
+		return do_monotonic_coarse(ts);
+	}
+
 	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
@@ -139,7 +179,7 @@ int clock_gettime(clockid_t, struct timespec *)
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
+	if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
 		if (likely(tv != NULL)) {
 			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
 				     offsetof(struct timespec, tv_nsec) ||
@@ -161,27 +201,14 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-
-static __always_inline long time_syscall(long *t)
-{
-	long secs;
-	asm volatile("syscall"
-		     : "=a" (secs)
-		     : "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
-	return secs;
-}
-
+/*
+ * This will break when the xtime seconds get inaccurate, but that is
+ * unlikely
+ */
 notrace time_t __vdso_time(time_t *t)
 {
-	time_t result;
-
-	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
-		return time_syscall(t);
-
 	/* This is atomic on x86_64 so we don't need any locks. */
-	result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+	time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
 
 	if (t)
 		*t = result;
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1d3aa6b..1b979c1 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,10 +1,21 @@
+#include <asm/page_types.h>
+#include <linux/linkage.h>
 #include <linux/init.h>
 
-__INITDATA
+__PAGE_ALIGNED_DATA
 
 	.globl vdso_start, vdso_end
+	.align PAGE_SIZE
 vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
 vdso_end:
 
-__FINIT
+.previous
+
+	.globl vdso_pages
+	.bss
+	.align 8
+	.type vdso_pages, @object
+vdso_pages:
+	.zero (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
+	.size vdso_pages, .-vdso_pages
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7abd2be..316fbca 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -14,41 +14,61 @@
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
+#include <asm/page.h>
 
 unsigned int __read_mostly vdso_enabled = 1;
 
 extern char vdso_start[], vdso_end[];
 extern unsigned short vdso_sync_cpuid;
 
-static struct page **vdso_pages;
+extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
-static int __init init_vdso_vars(void)
+static void __init patch_vdso(void *vdso, size_t len)
+{
+	Elf64_Ehdr *hdr = vdso;
+	Elf64_Shdr *sechdrs, *alt_sec = 0;
+	char *secstrings;
+	void *alt_data;
+	int i;
+
+	BUG_ON(len < sizeof(Elf64_Ehdr));
+	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
+
+	sechdrs = (void *)hdr + hdr->e_shoff;
+	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		Elf64_Shdr *shdr = &sechdrs[i];
+		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
+			alt_sec = shdr;
+			goto found;
+		}
+	}
+
+	/* If we get here, it's probably a bug. */
+	pr_warning("patch_vdso: .altinstructions not found\n");
+	return;  /* nothing to patch */
+
+found:
+	alt_data = (void *)hdr + alt_sec->sh_offset;
+	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+}
+
+static int __init init_vdso(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
 
+	patch_vdso(vdso_start, vdso_end - vdso_start);
+
 	vdso_size = npages << PAGE_SHIFT;
-	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
-	if (!vdso_pages)
-		goto oom;
-	for (i = 0; i < npages; i++) {
-		struct page *p;
-		p = alloc_page(GFP_KERNEL);
-		if (!p)
-			goto oom;
-		vdso_pages[i] = p;
-		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
-	}
+	for (i = 0; i < npages; i++)
+		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
 	return 0;
-
- oom:
-	printk("Cannot allocate vdso\n");
-	vdso_enabled = 0;
-	return -ENOMEM;
 }
-subsys_initcall(init_vdso_vars);
+subsys_initcall(init_vdso);
 
 struct linux_binprm;
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 051474c..0557651 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -931,7 +931,7 @@ int hpet_alloc(struct hpet_data *hdp)
 #ifdef CONFIG_IA64
 	if (!hpet_clocksource) {
 		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
-		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
+		clocksource_hpet.archdata.fsys_mmio = hpet_mctr;
 		clocksource_register_hz(&clocksource_hpet, hpetp->hp_tick_freq);
 		hpetp->hp_clocksource = &clocksource_hpet;
 		hpet_clocksource = &clocksource_hpet;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index d4646b4..59ee970 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -22,6 +22,10 @@
 typedef u64 cycle_t;
 struct clocksource;
 
+#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
+#include <asm/clocksource.h>
+#endif
+
 /**
  * struct cyclecounter - hardware abstraction for a free running counter
  *	Provides completely state-free accessors to the underlying hardware.
@@ -153,7 +157,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
- * @vread:		vsyscall based read
+ * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  */
@@ -169,16 +173,13 @@ struct clocksource {
 	u32 shift;
 	u64 max_idle_ns;
 
-#ifdef CONFIG_IA64
-	void *fsys_mmio;        /* used by fsyscall asm code */
-#define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
-#else
-#define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
+#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
+	struct arch_clocksource_data archdata;
 #endif
+
 	const char *name;
 	struct list_head list;
 	int rating;
-	cycle_t (*vread)(void);
 	int (*enable)(struct clocksource *cs);
 	void (*disable)(struct clocksource *cs);
 	unsigned long flags;
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..cc7a4e9 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -19,6 +19,11 @@ static inline void secure_computing(int this_syscall)
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return s->mode;
+}
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
@@ -37,6 +42,11 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 	return -EINVAL;
 }
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SECCOMP */
 
 #endif /* _LINUX_SECCOMP_H */
