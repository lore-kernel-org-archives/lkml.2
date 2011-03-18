Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1CRNyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:54:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab1CRNyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:54:18 -0400
Date: Fri, 18 Mar 2011 14:54:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110318135403.GA8506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, quirk: Fix SB600 revision check

Boris Ostrovsky (1):
      x86, AMD: Set ARAT feature on AMD processors

Borislav Petkov (1):
      x86, amd-nb: Misc cleanliness fixes

Ingo Molnar (1):
      x86: Clean up csum-copy_64.S a bit

Jon Nettleton (1):
      x86: Use PentiumPro-optimized partial_csum() on VIA C7

Lucas De Marchi (2):
      x86: Fix misspelling and align params
      x86: Fix common misspellings

Mathieu Desnoyers (1):
      x86: stop_machine_text_poke() should issue sync_core()

Namhyung Kim (1):
      x86, dumpstack: Correct stack dump info when frame pointer is available

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode


 Documentation/x86/x86_64/boot-options.txt   |   14 +-
 arch/x86/Kconfig.cpu                        |    4 +-
 arch/x86/crypto/aesni-intel_asm.S           |    6 +-
 arch/x86/include/asm/amd_nb.h               |   12 +-
 arch/x86/include/asm/cacheflush.h           |    2 +-
 arch/x86/include/asm/kdebug.h               |    2 +-
 arch/x86/include/asm/nmi.h                  |    4 +-
 arch/x86/include/asm/nops.h                 |    2 +-
 arch/x86/include/asm/olpc.h                 |    2 +-
 arch/x86/include/asm/perf_event_p4.h        |    4 +-
 arch/x86/include/asm/pgtable-3level.h       |   11 +-
 arch/x86/include/asm/processor-flags.h      |    2 +-
 arch/x86/include/asm/ptrace-abi.h           |    2 +-
 arch/x86/include/asm/ptrace.h               |    4 +-
 arch/x86/include/asm/stacktrace.h           |    6 +-
 arch/x86/include/asm/tsc.h                  |    2 +-
 arch/x86/include/asm/xen/interface.h        |    2 +-
 arch/x86/kernel/alternative.c               |    9 +-
 arch/x86/kernel/amd_nb.c                    |   18 +-
 arch/x86/kernel/aperture_64.c               |    2 +-
 arch/x86/kernel/apic/io_apic.c              |    4 +-
 arch/x86/kernel/apm_32.c                    |    2 +-
 arch/x86/kernel/cpu/amd.c                   |    4 +
 arch/x86/kernel/cpu/cpufreq/longhaul.c      |    4 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c |    4 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c            |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c          |    2 +-
 arch/x86/kernel/cpu/perf_event.c            |    4 +-
 arch/x86/kernel/cpu/perf_event_p4.c         |    8 +-
 arch/x86/kernel/cpu/vmware.c                |    2 +-
 arch/x86/kernel/dumpstack.c                 |   14 +-
 arch/x86/kernel/dumpstack_32.c              |   15 +-
 arch/x86/kernel/dumpstack_64.c              |   14 +-
 arch/x86/kernel/early-quirks.c              |    7 +-
 arch/x86/kernel/entry_64.S                  |    4 +-
 arch/x86/kernel/i387.c                      |    2 +-
 arch/x86/kernel/irq_32.c                    |    2 +-
 arch/x86/kernel/kgdb.c                      |    2 +-
 arch/x86/kernel/mca_32.c                    |    2 +-
 arch/x86/kernel/mpparse.c                   |    4 +-
 arch/x86/kernel/pci-calgary_64.c            |    4 +-
 arch/x86/kernel/process.c                   |    2 +-
 arch/x86/kernel/stacktrace.c                |    6 +-
 arch/x86/kernel/step.c                      |    2 +-
 arch/x86/kernel/topology.c                  |    2 +-
 arch/x86/kernel/tsc.c                       |    4 +-
 arch/x86/kernel/verify_cpu.S                |    2 +-
 arch/x86/kernel/xsave.c                     |    2 +-
 arch/x86/kvm/paging_tmpl.h                  |    2 +-
 arch/x86/kvm/timer.c                        |    2 +-
 arch/x86/kvm/x86.c                          |    2 +-
 arch/x86/lguest/boot.c                      |    2 +-
 arch/x86/lib/copy_user_64.S                 |    2 +-
 arch/x86/lib/csum-copy_64.S                 |  242 +++++++++++++-------------
 arch/x86/lib/csum-partial_64.c              |    2 +-
 arch/x86/mm/hugetlbpage.c                   |    2 +-
 arch/x86/mm/init_32.c                       |    2 +-
 arch/x86/mm/numa_64.c                       |    2 +-
 arch/x86/mm/pageattr.c                      |    2 +-
 arch/x86/mm/pgtable.c                       |    3 +-
 arch/x86/oprofile/backtrace.c               |    2 +-
 arch/x86/pci/i386.c                         |    4 +-
 arch/x86/xen/mmu.c                          |    2 +-
 65 files changed, 263 insertions(+), 250 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 7fbbaf8..48c13b8 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -189,13 +189,13 @@ ACPI
 
 PCI
 
-  pci=off	Don't use PCI
-  pci=conf1	Use conf1 access.
-  pci=conf2	Use conf2 access.
-  pci=rom	Assign ROMs.
-  pci=assign-busses    Assign busses
-  pci=irqmask=MASK	       Set PCI interrupt mask to MASK
-  pci=lastbus=NUMBER	       Scan upto NUMBER busses, no matter what the mptable says.
+  pci=off		Don't use PCI
+  pci=conf1		Use conf1 access.
+  pci=conf2		Use conf2 access.
+  pci=rom		Assign ROMs.
+  pci=assign-busses	Assign busses
+  pci=irqmask=MASK	Set PCI interrupt mask to MASK
+  pci=lastbus=NUMBER	Scan up to NUMBER busses, no matter what the mptable says.
   pci=noacpi		Don't use ACPI to set up PCI interrupt routing.
 
 IOMMU (input/output memory management unit)
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index ed47e6e..d161e93 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -326,7 +326,7 @@ config X86_PPRO_FENCE
 	  Old PentiumPro multiprocessor systems had errata that could cause
 	  memory operations to violate the x86 ordering standard in rare cases.
 	  Enabling this option will attempt to work around some (but not all)
-	  occurances of this problem, at the cost of much heavier spinlock and
+	  occurrences of this problem, at the cost of much heavier spinlock and
 	  memory barrier operations.
 
 	  If unsure, say n here. Even distro kernels should think twice before
@@ -366,7 +366,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
 
 config X86_USE_3DNOW
 	def_bool y
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 8fe2a49..adcf794 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1346,7 +1346,7 @@ _zero_cipher_left_decrypt:
 	and	$15, %r13				# %r13 = arg4 (mod 16)
 	je	_multiple_of_16_bytes_decrypt
 
-        # Handle the last <16 byte block seperately
+        # Handle the last <16 byte block separately
 
 	paddd ONE(%rip), %xmm0         # increment CNT to get Yn
         movdqa SHUF_MASK(%rip), %xmm10
@@ -1355,7 +1355,7 @@ _zero_cipher_left_decrypt:
 	ENCRYPT_SINGLE_BLOCK  %xmm0, %xmm1    # E(K, Yn)
 	sub $16, %r11
 	add %r13, %r11
-	movdqu (%arg3,%r11,1), %xmm1   # recieve the last <16 byte block
+	movdqu (%arg3,%r11,1), %xmm1   # receive the last <16 byte block
 	lea SHIFT_MASK+16(%rip), %r12
 	sub %r13, %r12
 # adjust the shuffle mask pointer to be able to shift 16-%r13 bytes
@@ -1607,7 +1607,7 @@ _zero_cipher_left_encrypt:
 	and	$15, %r13			# %r13 = arg4 (mod 16)
 	je	_multiple_of_16_bytes_encrypt
 
-         # Handle the last <16 Byte block seperately
+         # Handle the last <16 Byte block separately
 	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
         movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index e264ae5..3316822 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -13,7 +13,7 @@ extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
-extern int early_is_amd_nb(u32 value);
+extern bool early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(void);
@@ -32,18 +32,18 @@ struct amd_northbridge_info {
 };
 extern struct amd_northbridge_info amd_northbridges;
 
-#define AMD_NB_GART			0x1
-#define AMD_NB_L3_INDEX_DISABLE		0x2
-#define AMD_NB_L3_PARTITIONING		0x4
+#define AMD_NB_GART			BIT(0)
+#define AMD_NB_L3_INDEX_DISABLE		BIT(1)
+#define AMD_NB_L3_PARTITIONING		BIT(2)
 
 #ifdef CONFIG_AMD_NB
 
-static inline int amd_nb_num(void)
+static inline u16 amd_nb_num(void)
 {
 	return amd_northbridges.num;
 }
 
-static inline int amd_nb_has_feature(int feature)
+static inline bool amd_nb_has_feature(unsigned feature)
 {
 	return ((amd_northbridges.flags & feature) == feature);
 }
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 62f0844..4e12668 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -71,7 +71,7 @@ static inline void set_page_memtype(struct page *pg, unsigned long memtype) { }
  * Read/Write    : ReadOnly, ReadWrite
  * Presence      : NotPresent
  *
- * Within a catagory, the attributes are mutually exclusive.
+ * Within a category, the attributes are mutually exclusive.
  *
  * The implementation of this API will take care of various aspects that
  * are associated with changing such attributes, such as:
diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 518bbbb..fe2cc6e 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -26,7 +26,7 @@ extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
-		       unsigned long *sp);
+		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 07f4601..4886a68 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -29,8 +29,8 @@ void arch_trigger_all_cpu_backtrace(void);
  * external nmis, because the local ones are more frequent.
  *
  * Also setup some default high/normal/low settings for
- * subsystems to registers with.  Using 4 bits to seperate
- * the priorities.  This can go alot higher if needed be.
+ * subsystems to registers with.  Using 4 bits to separate
+ * the priorities.  This can go a lot higher if needed be.
  */
 
 #define NMI_LOCAL_SHIFT		16	/* randomly picked */
diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index 6d8723a..af78849 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -38,7 +38,7 @@
 #define K8_NOP8	K8_NOP4 K8_NOP4
 
 /* K7 nops
-   uses eax dependencies (arbitary choice)
+   uses eax dependencies (arbitrary choice)
    1: nop
    2: movl %eax,%eax
    3: leal (,%eax,1),%eax
diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index f482010..5ca6801 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -20,7 +20,7 @@ extern struct olpc_platform_t olpc_platform_info;
 
 /*
  * OLPC board IDs contain the major build number within the mask 0x0ff0,
- * and the minor build number withing 0x000f.  Pre-builds have a minor
+ * and the minor build number within 0x000f.  Pre-builds have a minor
  * number less than 8, and normal builds start at 8.  For example, 0x0B10
  * is a PreB1, and 0x0C18 is a C1.
  */
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index cc29086..56fd9e3 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -1,5 +1,5 @@
 /*
- * Netburst Perfomance Events (P4, old Xeon)
+ * Netburst Performance Events (P4, old Xeon)
  */
 
 #ifndef PERF_EVENT_P4_H
@@ -9,7 +9,7 @@
 #include <linux/bitops.h>
 
 /*
- * NetBurst has perfomance MSRs shared between
+ * NetBurst has performance MSRs shared between
  * threads if HT is turned on, ie for both logical
  * processors (mem: in turn in Atom with HT support
  * perf-MSRs are not shared and every thread has its
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 94b979d..effff47 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -69,8 +69,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 
 static inline void pud_clear(pud_t *pudp)
 {
-	unsigned long pgd;
-
 	set_pud(pudp, __pud(0));
 
 	/*
@@ -79,13 +77,10 @@ static inline void pud_clear(pud_t *pudp)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * Make sure the pud entry we're updating is within the
-	 * current pgd to avoid unnecessary TLB flushes.
+	 * Currently all places where pud_clear() is called either have
+	 * flush_tlb_mm() followed or don't need TLB flush (x86_64 code or
+	 * pud_clear_bad()), so we don't need TLB flush here.
 	 */
-	pgd = read_cr3();
-	if (__pa(pudp) >= pgd && __pa(pudp) <
-	    (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
-		write_cr3(pgd);
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index 7a3e836..a898a2b 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -7,7 +7,7 @@
  */
 #define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
 #define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
+#define X86_EFLAGS_AF	0x00000010 /* Auxiliary carry Flag */
 #define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
 #define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
 #define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 52b098a..7b0a55a 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -31,7 +31,7 @@
 #define R12 24
 #define RBP 32
 #define RBX 40
-/* arguments: interrupts/non tracing syscalls only save upto here*/
+/* arguments: interrupts/non tracing syscalls only save up to here*/
 #define R11 48
 #define R10 56
 #define R9 64
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 78cd1ea..1babf8a 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -73,7 +73,7 @@ struct pt_regs {
 	unsigned long r12;
 	unsigned long rbp;
 	unsigned long rbx;
-/* arguments: non interrupts/non tracing syscalls only save upto here*/
+/* arguments: non interrupts/non tracing syscalls only save up to here*/
 	unsigned long r11;
 	unsigned long r10;
 	unsigned long r9;
@@ -103,7 +103,7 @@ struct pt_regs {
 	unsigned long r12;
 	unsigned long bp;
 	unsigned long bx;
-/* arguments: non interrupts/non tracing syscalls only save upto here*/
+/* arguments: non interrupts/non tracing syscalls only save up to here*/
 	unsigned long r11;
 	unsigned long r10;
 	unsigned long r9;
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 52b5c7e..d7e89c8 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -47,7 +47,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data);
 
 #ifdef CONFIG_X86_32
@@ -86,11 +86,11 @@ stack_frame(struct task_struct *task, struct pt_regs *regs)
 
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *stack, char *log_lvl);
+		   unsigned long *stack, unsigned long bp, char *log_lvl);
 
 extern void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl);
+		   unsigned long *sp, unsigned long bp, char *log_lvl);
 
 extern unsigned int code_bytes;
 
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 1ca132f..83e2efd 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -35,7 +35,7 @@ static inline cycles_t get_cycles(void)
 static __always_inline cycles_t vget_cycles(void)
 {
 	/*
-	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
+	 * We only do VDSOs on TSC capable CPUs, so this shouldn't
 	 * access boot_cpu_data (which is not VDSO-safe):
 	 */
 #ifndef CONFIG_X86_TSC
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 1c10c88..5d4922a 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -86,7 +86,7 @@ DEFINE_GUEST_HANDLE(void);
  * The privilege level specifies which modes may enter a trap via a software
  * interrupt. On x86/64, since rings 1 and 2 are unavailable, we allocate
  * privilege levels as follows:
- *  Level == 0: Noone may enter
+ *  Level == 0: No one may enter
  *  Level == 1: Kernel may enter
  *  Level == 2: Kernel may enter
  *  Level == 3: Everyone may enter
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7038b95..4a23467 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -199,7 +199,7 @@ void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
-   self modifying code. This implies that assymetric systems where
+   self modifying code. This implies that asymmetric systems where
    APs have less capabilities than the boot processor are not handled.
    Tough. Make sure you disable such features by hand. */
 
@@ -620,7 +620,12 @@ static int __kprobes stop_machine_text_poke(void *data)
 		flush_icache_range((unsigned long)p->addr,
 				   (unsigned long)p->addr + p->len);
 	}
-
+	/*
+	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
+	 * that a core serializing instruction such as "cpuid" should be
+	 * executed on _each_ core before the new instruction is made visible.
+	 */
+	sync_core();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index ed3c2e5..6563419 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -48,7 +48,7 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 
 int amd_cache_northbridges(void)
 {
-	int i = 0;
+	u16 i = 0;
 	struct amd_northbridge *nb;
 	struct pci_dev *misc, *link;
 
@@ -103,9 +103,11 @@ int amd_cache_northbridges(void)
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
 
-/* Ignores subdevice/subvendor but as far as I can figure out
-   they're useless anyways */
-int __init early_is_amd_nb(u32 device)
+/*
+ * Ignores subdevice/subvendor but as far as I can figure out
+ * they're useless anyways
+ */
+bool __init early_is_amd_nb(u32 device)
 {
 	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
@@ -113,8 +115,8 @@ int __init early_is_amd_nb(u32 device)
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
-			return 1;
-	return 0;
+			return true;
+	return false;
 }
 
 int amd_get_subcaches(int cpu)
@@ -176,9 +178,9 @@ int amd_set_subcaches(int cpu, int mask)
 	return 0;
 }
 
-int amd_cache_gart(void)
+static int amd_cache_gart(void)
 {
-       int i;
+	u16 i;
 
        if (!amd_nb_has_feature(AMD_NB_GART))
                return 0;
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 7b1e8e1..86d1ad4 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -73,7 +73,7 @@ static u32 __init allocate_aperture(void)
 	/*
 	 * using 512M as goal, in case kexec will load kernel_big
 	 * that will do the on position decompress, and  could overlap with
-	 * that positon with gart that is used.
+	 * that position with gart that is used.
 	 * sequende:
 	 * kernel_small
 	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4b5ebd2..f15c6f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1886,7 +1886,7 @@ void disable_IO_APIC(void)
 	 *
 	 * With interrupt-remapping, for now we will use virtual wire A mode,
 	 * as virtual wire B is little complex (need to configure both
-	 * IOAPIC RTE aswell as interrupt-remapping table entry).
+	 * IOAPIC RTE as well as interrupt-remapping table entry).
 	 * As this gets called during crash dump, keep this simple for now.
 	 */
 	if (ioapic_i8259.pin != -1 && !intr_remapping_enabled) {
@@ -2905,7 +2905,7 @@ void __init setup_IO_APIC(void)
 }
 
 /*
- *      Called after all the initialization is done. If we didnt find any
+ *      Called after all the initialization is done. If we didn't find any
  *      APIC bugs then we can allow the modify fast path
  */
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..a10e516 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -66,7 +66,7 @@
  *    1.5: Fix segment register reloading (in case of bad segments saved
  *         across BIOS call).
  *         Stephen Rothwell
- *    1.6: Cope with complier/assembler differences.
+ *    1.6: Cope with compiler/assembler differences.
  *         Only try to turn off the first display device.
  *         Fix OOPS at power off with no APM BIOS by Jan Echternach
  *                   <echter@informatik.uni-rostock.de>
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f771ab6..3ecece0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -611,6 +611,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index 03162da..cf48cdd 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -444,7 +444,7 @@ static int __cpuinit longhaul_get_ranges(void)
 		return -EINVAL;
 	}
 	/* Get max multiplier - as we always did.
-	 * Longhaul MSR is usefull only when voltage scaling is enabled.
+	 * Longhaul MSR is useful only when voltage scaling is enabled.
 	 * C3 is booting at max anyway. */
 	maxmult = mult;
 	/* Get min multiplier */
@@ -1011,7 +1011,7 @@ static void __exit longhaul_exit(void)
  * trigger frequency transition in some cases. */
 module_param(disable_acpi_c3, int, 0644);
 MODULE_PARM_DESC(disable_acpi_c3, "Don't use ACPI C3 support");
-/* Change CPU voltage with frequency. Very usefull to save
+/* Change CPU voltage with frequency. Very useful to save
  * power, but most VIA C3 processors aren't supporting it. */
 module_param(scale_voltage, int, 0644);
 MODULE_PARM_DESC(scale_voltage, "Scale voltage of processor");
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index c567dec..b41f7da 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1276,7 +1276,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	if (powernow_k8_cpu_init_acpi(data)) {
 		/*
-		 * Use the PSB BIOS structure. This is only availabe on
+		 * Use the PSB BIOS structure. This is only available on
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8abd869..91bc25b 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -292,7 +292,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 
 	result = speedstep_smi_ownership();
 	if (result) {
-		dprintk("fails in aquiring ownership of a SMI interface.\n");
+		dprintk("fails in acquiring ownership of a SMI interface.\n");
 		return -EINVAL;
 	}
 
@@ -360,7 +360,7 @@ static int speedstep_resume(struct cpufreq_policy *policy)
 	int result = speedstep_smi_ownership();
 
 	if (result)
-		dprintk("fails in re-aquiring ownership of a SMI interface.\n");
+		dprintk("fails in re-acquiring ownership of a SMI interface.\n");
 
 	return result;
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index a779719..0ed633c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -32,7 +32,7 @@ static void inject_mce(struct mce *m)
 {
 	struct mce *i = &per_cpu(injectm, m->extcpu);
 
-	/* Make sure noone reads partially written injectm */
+	/* Make sure no one reads partially written injectm */
 	i->finished = 0;
 	mb();
 	m->finished = 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..ab11229 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -881,7 +881,7 @@ reset:
  * Check if the address reported by the CPU is in a format we can parse.
  * It would be possible to add code for most other cases, but all would
  * be somewhat complicated (e.g. segment offset would require an instruction
- * parser). So only support physical addresses upto page granuality for now.
+ * parser). So only support physical addresses up to page granuality for now.
  */
 static int mce_usable_address(struct mce *m)
 {
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 9f27228..a71efcdb 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -1,6 +1,6 @@
 /*
  * This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
- * because MTRRs can span upto 40 bits (36bits on most modern x86)
+ * because MTRRs can span up to 40 bits (36bits on most modern x86)
  */
 #define DEBUG
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2660418..3061276 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1111,7 +1111,7 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 
 	/*
 	 * If group events scheduling transaction was started,
-	 * skip the schedulability test here, it will be peformed
+	 * skip the schedulability test here, it will be performed
 	 * at commit time (->commit_txn) as a whole
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
@@ -1792,7 +1792,7 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	perf_callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3769ac8..0811f5e 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1,5 +1,5 @@
 /*
- * Netburst Perfomance Events (P4, old Xeon)
+ * Netburst Performance Events (P4, old Xeon)
  *
  *  Copyright (C) 2010 Parallels, Inc., Cyrill Gorcunov <gorcunov@openvz.org>
  *  Copyright (C) 2010 Intel Corporation, Lin Ming <ming.m.lin@intel.com>
@@ -679,7 +679,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 */
 
 	/*
-	 * if an event is shared accross the logical threads
+	 * if an event is shared across the logical threads
 	 * the user needs special permissions to be able to use it
 	 */
 	if (p4_ht_active() && p4_event_bind_map[v].shared) {
@@ -790,13 +790,13 @@ static void p4_pmu_disable_pebs(void)
 	 *
 	 * It's still allowed that two threads setup same cache
 	 * events so we can't simply clear metrics until we knew
-	 * noone is depending on us, so we need kind of counter
+	 * no one is depending on us, so we need kind of counter
 	 * for "ReplayEvent" users.
 	 *
 	 * What is more complex -- RAW events, if user (for some
 	 * reason) will pass some cache event metric with improper
 	 * event opcode -- it's fine from hardware point of view
-	 * but completely nonsence from "meaning" of such action.
+	 * but completely nonsense from "meaning" of such action.
 	 *
 	 * So at moment let leave metrics turned on forever -- it's
 	 * ok for now but need to be revisited!
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 227b044..d22d0c4 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -86,7 +86,7 @@ static void __init vmware_platform_setup(void)
 }
 
 /*
- * While checking the dmi string infomation, just checking the product
+ * While checking the dmi string information, just checking the product
  * serial key should be enough, as this will always have a VMware
  * specific string when running under VMware hypervisor.
  */
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 220a1c1..999e279 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -175,21 +175,21 @@ static const struct stacktrace_ops print_trace_ops = {
 
 void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, char *log_lvl)
+		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
 	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, &print_trace_ops, log_lvl);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack)
+		unsigned long *stack, unsigned long bp)
 {
-	show_trace_log_lvl(task, regs, stack, "");
+	show_trace_log_lvl(task, regs, stack, bp, "");
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, "");
+	show_stack_log_lvl(task, NULL, sp, 0, "");
 }
 
 /*
@@ -197,14 +197,16 @@ void show_stack(struct task_struct *task, unsigned long *sp)
  */
 void dump_stack(void)
 {
+	unsigned long bp;
 	unsigned long stack;
 
+	bp = stack_frame(current, NULL);
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &stack);
+	show_trace(NULL, NULL, &stack, bp);
 }
 EXPORT_SYMBOL(dump_stack);
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 74cc1ed..3b97a80 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -17,12 +17,11 @@
 #include <asm/stacktrace.h>
 
 
-void dump_trace(struct task_struct *task,
-		struct pt_regs *regs, unsigned long *stack,
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
-	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -35,7 +34,9 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	if (!bp)
+		bp = stack_frame(task, regs);
+
 	for (;;) {
 		struct thread_info *context;
 
@@ -55,7 +56,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -77,7 +78,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 
@@ -102,7 +103,7 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk(KERN_EMERG "Stack:\n");
-		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a6b6fcf..e71c98d 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -139,8 +139,8 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-void dump_trace(struct task_struct *task,
-		struct pt_regs *regs, unsigned long *stack,
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
@@ -150,7 +150,6 @@ void dump_trace(struct task_struct *task,
 	struct thread_info *tinfo;
 	int graph = 0;
 	unsigned long dummy;
-	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -161,7 +160,8 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	if (!bp)
+		bp = stack_frame(task, regs);
 	/*
 	 * Print function call entries in all stacks, starting at the
 	 * current stack address. If the stacks consist of nested
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *irq_stack_end;
 	unsigned long *irq_stack;
@@ -269,7 +269,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	preempt_enable();
 
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 void show_registers(struct pt_regs *regs)
@@ -298,7 +298,7 @@ void show_registers(struct pt_regs *regs)
 
 		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				   KERN_EMERG);
+				   0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 9efbdcc..3755ef4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -159,7 +159,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b72b4a6..8a445a0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -18,7 +18,7 @@
  * A note on terminology:
  * - top of stack: Architecture defined interrupt frame from SS to RIP
  * at the top of the kernel process stack.
- * - partial stack frame: partially saved registers upto R11.
+ * - partial stack frame: partially saved registers up to R11.
  * - full stack frame: Like partial stack frame, but all register saved.
  *
  * Some macro usage:
@@ -422,7 +422,7 @@ ENTRY(ret_from_fork)
 END(ret_from_fork)
 
 /*
- * System call entry. Upto 6 arguments in registers are supported.
+ * System call entry. Up to 6 arguments in registers are supported.
  *
  * SYSCALL does not save anything on the stack and does not change the
  * stack pointer.
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e60c38c..12aff25 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -145,7 +145,7 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  * The _current_ task is using the FPU for the first time
  * so initialize it and set the mxcsr to its default
  * value at reset if we support XMM instructions and then
- * remeber the current task has used the FPU.
+ * remember the current task has used the FPU.
  */
 int init_fpu(struct task_struct *tsk)
 {
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 9974d21..7209070 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -172,7 +172,7 @@ asmlinkage void do_softirq(void)
 
 		call_on_stack(__do_softirq, isp);
 		/*
-		 * Shouldnt happen, we returned above if in_interrupt():
+		 * Shouldn't happen, we returned above if in_interrupt():
 		 */
 		WARN_ON_ONCE(softirq_count());
 	}
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 7c64c42..dba0b36 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -278,7 +278,7 @@ static int hw_break_release_slot(int breakno)
 		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
 		if (dbg_release_bp_slot(*pevent))
 			/*
-			 * The debugger is responisble for handing the retry on
+			 * The debugger is responsible for handing the retry on
 			 * remove failure.
 			 */
 			return -1;
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index 63eaf65..177183c 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -259,7 +259,7 @@ static int __init mca_init(void)
 	/*
 	 * WARNING: Be careful when making changes here. Putting an adapter
 	 * and the motherboard simultaneously into setup mode may result in
-	 * damage to chips (according to The Indispensible PC Hardware Book
+	 * damage to chips (according to The Indispensable PC Hardware Book
 	 * by Hans-Peter Messmer). Also, we disable system interrupts (so
 	 * that we are not disturbed in the middle of this).
 	 */
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 01b0f6d..6f789a8 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -883,7 +883,7 @@ static int __init update_mp_table(void)
 
 	if (!mpc_new_phys) {
 		unsigned char old, new;
-		/* check if we can change the postion */
+		/* check if we can change the position */
 		mpc->checksum = 0;
 		old = mpf_checksum((unsigned char *)mpc, mpc->length);
 		mpc->checksum = 0xff;
@@ -892,7 +892,7 @@ static int __init update_mp_table(void)
 			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
 			return 0;
 		}
-		printk(KERN_INFO "use in-positon replacing\n");
+		printk(KERN_INFO "use in-position replacing\n");
 	} else {
 		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index f56a117..e8c33a3 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1279,7 +1279,7 @@ static int __init calgary_bus_has_devices(int bus, unsigned short pci_dev)
 
 	if (pci_dev == PCI_DEVICE_ID_IBM_CALIOC2) {
 		/*
-		 * FIXME: properly scan for devices accross the
+		 * FIXME: properly scan for devices across the
 		 * PCI-to-PCI bridge on every CalIOC2 port.
 		 */
 		return 1;
@@ -1295,7 +1295,7 @@ static int __init calgary_bus_has_devices(int bus, unsigned short pci_dev)
 
 /*
  * calgary_init_bitmap_from_tce_table():
- * Funtion for kdump case. In the second/kdump kernel initialize
+ * Function for kdump case. In the second/kdump kernel initialize
  * the bitmap based on the tce table entries obtained from first kernel
  */
 static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 99fa3ad..d46cbe4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,7 +87,7 @@ void exit_thread(void)
 void show_regs(struct pt_regs *regs)
 {
 	show_registers(regs);
-	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs));
+	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs), 0);
 }
 
 void show_regs_common(void)
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 938c8e1..6515733 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -73,7 +73,7 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
@@ -81,14 +81,14 @@ EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
 {
-	dump_trace(current, regs, NULL, &save_stack_ops, trace);
+	dump_trace(current, regs, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	dump_trace(tsk, NULL, NULL, &save_stack_ops_nosched, trace);
+	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 58de45e..7977f0c 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -166,7 +166,7 @@ static void enable_step(struct task_struct *child, bool block)
 	 * Make sure block stepping (BTF) is not enabled unless it should be.
 	 * Note that we don't try to worry about any is_setting_trap_flag()
 	 * instructions after the first when using block stepping.
-	 * So noone should try to use debugger block stepping in a program
+	 * So no one should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
 	if (enable_single_step(child) && block) {
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 7e45159..8927486 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -39,7 +39,7 @@ int __ref arch_register_cpu(int num)
 	/*
 	 * CPU0 cannot be offlined due to several
 	 * restrictions and assumptions in kernel. This basically
-	 * doesnt add a control file, one cannot attempt to offline
+	 * doesn't add a control file, one cannot attempt to offline
 	 * BSP.
 	 *
 	 * Also certain PCI quirks require not to enable hotplug control
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ffe5755..9335bf7 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -427,7 +427,7 @@ unsigned long native_calibrate_tsc(void)
 	 * the delta to the previous read. We keep track of the min
 	 * and max values of that delta. The delta is mostly defined
 	 * by the IO time of the PIT access, so we can detect when a
-	 * SMI/SMM disturbance happend between the two reads. If the
+	 * SMI/SMM disturbance happened between the two reads. If the
 	 * maximum time is significantly larger than the minimum time,
 	 * then we discard the result and have another try.
 	 *
@@ -900,7 +900,7 @@ static DECLARE_DELAYED_WORK(tsc_irqwork, tsc_refine_calibration_work);
  * timer based, instead of loop based, we don't block the boot
  * process while this longer calibration is done.
  *
- * If there are any calibration anomolies (too many SMIs, etc),
+ * If there are any calibration anomalies (too many SMIs, etc),
  * or the refined calibration is off by 1% of the fast early
  * calibration, we throw out the new calibration and use the
  * early calibration.
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 0edefc1..b9242ba 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -18,7 +18,7 @@
  *	This file is expected to run in 32bit code.  Currently:
  *
  *	arch/x86/boot/compressed/head_64.S: Boot cpu verification
- *	arch/x86/kernel/trampoline_64.S: secondary processor verfication
+ *	arch/x86/kernel/trampoline_64.S: secondary processor verification
  *	arch/x86/kernel/head_32.S: processor startup
  *
  *	verify_cpu, returns the status of longmode and SSE in register %eax.
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 5471285..a391134 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -53,7 +53,7 @@ void __sanitize_i387_state(struct task_struct *tsk)
 
 	/*
 	 * None of the feature bits are in init state. So nothing else
-	 * to do for us, as the memory layout is upto date.
+	 * to do for us, as the memory layout is up to date.
 	 */
 	if ((xstate_bv & pcntxt_mask) == pcntxt_mask)
 		return;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bccc24..a51517d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -348,7 +348,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return;
 	kvm_get_pfn(pfn);
 	/*
-	 * we call mmu_set_spte() with host_writable = true beacuse that
+	 * we call mmu_set_spte() with host_writable = true because that
 	 * vcpu->arch.update_pte.pfn was fetched from get_user_pages(write = 1).
 	 */
 	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index fc7a101..abd86e86 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -25,7 +25,7 @@ static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
 
 	/*
 	 * There is a race window between reading and incrementing, but we do
-	 * not care about potentially loosing timer events in the !reinject
+	 * not care about potentially losing timer events in the !reinject
 	 * case anyway. Note: KVM_REQ_PENDING_TIMER is implicitly checked
 	 * in vcpu_enter_guest.
 	 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..e3a9e4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1028,7 +1028,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	/*
 	 * Special case: close write to TSC within 5 seconds of
 	 * another CPU is interpreted as an attempt to synchronize
-	 * The 5 seconds is to accomodate host load / swapping as
+	 * The 5 seconds is to accommodate host load / swapping as
 	 * well as any reset of TSC during the boot process.
 	 *
 	 * In that case, for a reliable TSC, we can match TSC offsets,
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index b9ec1c7..1cd6089 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -397,7 +397,7 @@ static void lguest_load_tr_desc(void)
  * instead we just use the real "cpuid" instruction.  Then I pretty much turned
  * off feature bits until the Guest booted.  (Don't say that: you'll damage
  * lguest sales!)  Shut up, inner voice!  (Hey, just pointing out that this is
- * hardly future proof.)  Noone's listening!  They don't like you anyway,
+ * hardly future proof.)  No one's listening!  They don't like you anyway,
  * parenthetic weirdo!
  *
  * Replacing the cpuid so we can turn features off is great for the kernel, but
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a460158..99e4826 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -117,7 +117,7 @@ ENDPROC(bad_from_user)
  * rdx count
  *
  * Output:
- * eax uncopied bytes or 0 if successfull.
+ * eax uncopied bytes or 0 if successful.
  */
 ENTRY(copy_user_generic_unrolled)
 	CFI_STARTPROC
diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index f0dba36..fb903b7 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -1,6 +1,6 @@
 /*
- * Copyright 2002,2003 Andi Kleen, SuSE Labs.
- *	
+ * Copyright 2002, 2003 Andi Kleen, SuSE Labs.
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
  * for more details. No warranty for anything given at all.
@@ -11,82 +11,82 @@
 
 /*
  * Checksum copy with exception handling.
- * On exceptions src_err_ptr or dst_err_ptr is set to -EFAULT and the 
+ * On exceptions src_err_ptr or dst_err_ptr is set to -EFAULT and the
  * destination is zeroed.
- * 
+ *
  * Input
  * rdi  source
  * rsi  destination
  * edx  len (32bit)
- * ecx  sum (32bit) 
+ * ecx  sum (32bit)
  * r8   src_err_ptr (int)
  * r9   dst_err_ptr (int)
  *
  * Output
  * eax  64bit sum. undefined in case of exception.
- * 
- * Wrappers need to take care of valid exception sum and zeroing.		 
+ *
+ * Wrappers need to take care of valid exception sum and zeroing.
  * They also should align source or destination to 8 bytes.
  */
 
 	.macro source
 10:
-	.section __ex_table,"a"
+	.section __ex_table, "a"
 	.align 8
-	.quad 10b,.Lbad_source
+	.quad 10b, .Lbad_source
 	.previous
 	.endm
-		
+
 	.macro dest
 20:
-	.section __ex_table,"a"
+	.section __ex_table, "a"
 	.align 8
-	.quad 20b,.Lbad_dest
+	.quad 20b, .Lbad_dest
 	.previous
 	.endm
-			
+
 	.macro ignore L=.Lignore
 30:
-	.section __ex_table,"a"
+	.section __ex_table, "a"
 	.align 8
-	.quad 30b,\L
+	.quad 30b, \L
 	.previous
 	.endm
-	
-				
+
+
 ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
-	cmpl	 $3*64,%edx
-	jle	 .Lignore
+	cmpl	$3*64, %edx
+	jle	.Lignore
 
-.Lignore:		
-	subq  $7*8,%rsp
+.Lignore:
+	subq  $7*8, %rsp
 	CFI_ADJUST_CFA_OFFSET 7*8
-	movq  %rbx,2*8(%rsp)
+	movq  %rbx, 2*8(%rsp)
 	CFI_REL_OFFSET rbx, 2*8
-	movq  %r12,3*8(%rsp)
+	movq  %r12, 3*8(%rsp)
 	CFI_REL_OFFSET r12, 3*8
-	movq  %r14,4*8(%rsp)
+	movq  %r14, 4*8(%rsp)
 	CFI_REL_OFFSET r14, 4*8
-	movq  %r13,5*8(%rsp)
+	movq  %r13, 5*8(%rsp)
 	CFI_REL_OFFSET r13, 5*8
-	movq  %rbp,6*8(%rsp)
+	movq  %rbp, 6*8(%rsp)
 	CFI_REL_OFFSET rbp, 6*8
 
-	movq  %r8,(%rsp)
-	movq  %r9,1*8(%rsp)
-	
-	movl  %ecx,%eax
-	movl  %edx,%ecx
+	movq  %r8, (%rsp)
+	movq  %r9, 1*8(%rsp)
 
-	xorl  %r9d,%r9d
-	movq  %rcx,%r12
+	movl  %ecx, %eax
+	movl  %edx, %ecx
 
-	shrq  $6,%r12
-	jz    .Lhandle_tail       /* < 64 */
+	xorl  %r9d, %r9d
+	movq  %rcx, %r12
+
+	shrq  $6, %r12
+	jz	.Lhandle_tail       /* < 64 */
 
 	clc
-	
+
 	/* main loop. clear in 64 byte blocks */
 	/* r9: zero, r8: temp2, rbx: temp1, rax: sum, rcx: saved length */
 	/* r11:	temp3, rdx: temp4, r12 loopcnt */
@@ -94,156 +94,156 @@ ENTRY(csum_partial_copy_generic)
 	.p2align 4
 .Lloop:
 	source
-	movq  (%rdi),%rbx
+	movq  (%rdi), %rbx
 	source
-	movq  8(%rdi),%r8
+	movq  8(%rdi), %r8
 	source
-	movq  16(%rdi),%r11
+	movq  16(%rdi), %r11
 	source
-	movq  24(%rdi),%rdx
+	movq  24(%rdi), %rdx
 
 	source
-	movq  32(%rdi),%r10
+	movq  32(%rdi), %r10
 	source
-	movq  40(%rdi),%rbp
+	movq  40(%rdi), %rbp
 	source
-	movq  48(%rdi),%r14
+	movq  48(%rdi), %r14
 	source
-	movq  56(%rdi),%r13
-		
+	movq  56(%rdi), %r13
+
 	ignore 2f
 	prefetcht0 5*64(%rdi)
-2:							
-	adcq  %rbx,%rax
-	adcq  %r8,%rax
-	adcq  %r11,%rax
-	adcq  %rdx,%rax
-	adcq  %r10,%rax
-	adcq  %rbp,%rax
-	adcq  %r14,%rax
-	adcq  %r13,%rax
+2:
+	adcq  %rbx, %rax
+	adcq  %r8, %rax
+	adcq  %r11, %rax
+	adcq  %rdx, %rax
+	adcq  %r10, %rax
+	adcq  %rbp, %rax
+	adcq  %r14, %rax
+	adcq  %r13, %rax
 
 	decl %r12d
-	
+
 	dest
-	movq %rbx,(%rsi)
+	movq %rbx, (%rsi)
 	dest
-	movq %r8,8(%rsi)
+	movq %r8, 8(%rsi)
 	dest
-	movq %r11,16(%rsi)
+	movq %r11, 16(%rsi)
 	dest
-	movq %rdx,24(%rsi)
+	movq %rdx, 24(%rsi)
 
 	dest
-	movq %r10,32(%rsi)
+	movq %r10, 32(%rsi)
 	dest
-	movq %rbp,40(%rsi)
+	movq %rbp, 40(%rsi)
 	dest
-	movq %r14,48(%rsi)
+	movq %r14, 48(%rsi)
 	dest
-	movq %r13,56(%rsi)
-	
+	movq %r13, 56(%rsi)
+
 3:
-	
-	leaq 64(%rdi),%rdi
-	leaq 64(%rsi),%rsi
 
-	jnz   .Lloop
+	leaq 64(%rdi), %rdi
+	leaq 64(%rsi), %rsi
 
-	adcq  %r9,%rax
+	jnz	.Lloop
 
-	/* do last upto 56 bytes */
+	adcq  %r9, %rax
+
+	/* do last up to 56 bytes */
 .Lhandle_tail:
 	/* ecx:	count */
-	movl %ecx,%r10d
-	andl $63,%ecx
-	shrl $3,%ecx
-	jz 	 .Lfold
+	movl %ecx, %r10d
+	andl $63, %ecx
+	shrl $3, %ecx
+	jz	.Lfold
 	clc
 	.p2align 4
-.Lloop_8:	
+.Lloop_8:
 	source
-	movq (%rdi),%rbx
-	adcq %rbx,%rax
+	movq (%rdi), %rbx
+	adcq %rbx, %rax
 	decl %ecx
 	dest
-	movq %rbx,(%rsi)
-	leaq 8(%rsi),%rsi /* preserve carry */
-	leaq 8(%rdi),%rdi
+	movq %rbx, (%rsi)
+	leaq 8(%rsi), %rsi /* preserve carry */
+	leaq 8(%rdi), %rdi
 	jnz	.Lloop_8
-	adcq %r9,%rax	/* add in carry */
+	adcq %r9, %rax	/* add in carry */
 
 .Lfold:
 	/* reduce checksum to 32bits */
-	movl %eax,%ebx
-	shrq $32,%rax
-	addl %ebx,%eax
-	adcl %r9d,%eax
+	movl %eax, %ebx
+	shrq $32, %rax
+	addl %ebx, %eax
+	adcl %r9d, %eax
 
-	/* do last upto 6 bytes */	
+	/* do last up to 6 bytes */
 .Lhandle_7:
-	movl %r10d,%ecx
-	andl $7,%ecx
-	shrl $1,%ecx
+	movl %r10d, %ecx
+	andl $7, %ecx
+	shrl $1, %ecx
 	jz   .Lhandle_1
-	movl $2,%edx
-	xorl %ebx,%ebx
-	clc  
+	movl $2, %edx
+	xorl %ebx, %ebx
+	clc
 	.p2align 4
-.Lloop_1:	
+.Lloop_1:
 	source
-	movw (%rdi),%bx
-	adcl %ebx,%eax
+	movw (%rdi), %bx
+	adcl %ebx, %eax
 	decl %ecx
 	dest
-	movw %bx,(%rsi)
-	leaq 2(%rdi),%rdi
-	leaq 2(%rsi),%rsi
+	movw %bx, (%rsi)
+	leaq 2(%rdi), %rdi
+	leaq 2(%rsi), %rsi
 	jnz .Lloop_1
-	adcl %r9d,%eax	/* add in carry */
-	
+	adcl %r9d, %eax	/* add in carry */
+
 	/* handle last odd byte */
 .Lhandle_1:
-	testl $1,%r10d
+	testl $1, %r10d
 	jz    .Lende
-	xorl  %ebx,%ebx
+	xorl  %ebx, %ebx
 	source
-	movb (%rdi),%bl
+	movb (%rdi), %bl
 	dest
-	movb %bl,(%rsi)
-	addl %ebx,%eax
-	adcl %r9d,%eax		/* carry */
-			
+	movb %bl, (%rsi)
+	addl %ebx, %eax
+	adcl %r9d, %eax		/* carry */
+
 	CFI_REMEMBER_STATE
 .Lende:
-	movq 2*8(%rsp),%rbx
+	movq 2*8(%rsp), %rbx
 	CFI_RESTORE rbx
-	movq 3*8(%rsp),%r12
+	movq 3*8(%rsp), %r12
 	CFI_RESTORE r12
-	movq 4*8(%rsp),%r14
+	movq 4*8(%rsp), %r14
 	CFI_RESTORE r14
-	movq 5*8(%rsp),%r13
+	movq 5*8(%rsp), %r13
 	CFI_RESTORE r13
-	movq 6*8(%rsp),%rbp
+	movq 6*8(%rsp), %rbp
 	CFI_RESTORE rbp
-	addq $7*8,%rsp
+	addq $7*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -7*8
 	ret
 	CFI_RESTORE_STATE
 
 	/* Exception handlers. Very simple, zeroing is done in the wrappers */
 .Lbad_source:
-	movq (%rsp),%rax
-	testq %rax,%rax
+	movq (%rsp), %rax
+	testq %rax, %rax
 	jz   .Lende
-	movl $-EFAULT,(%rax)
+	movl $-EFAULT, (%rax)
 	jmp  .Lende
-	
+
 .Lbad_dest:
-	movq 8(%rsp),%rax
-	testq %rax,%rax
-	jz   .Lende	
-	movl $-EFAULT,(%rax)
+	movq 8(%rsp), %rax
+	testq %rax, %rax
+	jz   .Lende
+	movl $-EFAULT, (%rax)
 	jmp .Lende
 	CFI_ENDPROC
 ENDPROC(csum_partial_copy_generic)
diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index bf51144..9845371 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -84,7 +84,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
 				count64--;
 			}
 
-			/* last upto 7 8byte blocks */
+			/* last up to 7 8byte blocks */
 			count %= 8; 
 			while (count) { 
 				asm("addq %1,%0\n\t"
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 069ce7c..d420398 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -326,7 +326,7 @@ try_again:
 	if (mm->free_area_cache < len)
 		goto fail;
 
-	/* either no address requested or cant fit in requested address hole */
+	/* either no address requested or can't fit in requested address hole */
 	addr = (mm->free_area_cache - len) & huge_page_mask(h);
 	do {
 		/*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 73ad7eb..80088f9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -917,7 +917,7 @@ static void mark_nxdata_nx(void)
 {
 	/*
 	 * When this called, init has already been executed and released,
-	 * so everything past _etext sould be NX.
+	 * so everything past _etext should be NX.
 	 */
 	unsigned long start = PFN_ALIGN(_etext);
 	/*
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 9ec0f20..e8c00cc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -446,7 +446,7 @@ static int __init numa_alloc_distance(void)
  * @distance: NUMA distance
  *
  * Set the distance from node @from to @to to @distance.  If distance table
- * doesn't exist, one which is large enough to accomodate all the currently
+ * doesn't exist, one which is large enough to accommodate all the currently
  * known nodes will be created.
  *
  * If such table cannot be allocated, a warning is printed and further
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 90825f2..f9e5267 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -310,7 +310,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 		 * these shared mappings are made of small page mappings.
 		 * Thus this don't enforce !RW mapping for small page kernel
 		 * text mapping logic will help Linux Xen parvirt guest boot
-		 * aswell.
+		 * as well.
 		 */
 		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
 			pgprot_val(forbidden) |= _PAGE_RW;
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 0113d19..8573b83 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -168,8 +168,7 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 * section 8.1: in PAE mode we explicitly have to flush the
 	 * TLB via cr3 if the top-level pgd is changed...
 	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
+	flush_tlb_mm(mm);
 }
 #else  /* !CONFIG_X86_PAE */
 
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 72cbec1..2d49d4e 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -126,7 +126,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
 		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack,
+			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);
 		return;
 	}
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b1805b7..494f2e7 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -241,7 +241,7 @@ void __init pcibios_resource_survey(void)
 	e820_reserve_resources_late();
 	/*
 	 * Insert the IO APIC resources after PCI initialization has
-	 * occured to handle IO APICS that are mapped in on a BAR in
+	 * occurred to handle IO APICS that are mapped in on a BAR in
 	 * PCI space, but before trying to assign unassigned pci res.
 	 */
 	ioapic_insert_resources();
@@ -304,7 +304,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		/*
 		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
 		 * To avoid attribute conflicts, request UC MINUS here
-		 * aswell.
+		 * as well.
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3f6f334..a2d78ad 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1745,7 +1745,7 @@ static void convert_pfn_mfn(void *v)
 }
 
 /*
- * Set up the inital kernel pagetable.
+ * Set up the initial kernel pagetable.
  *
  * We can construct this by grafting the Xen provided pagetable into
  * head_64.S's preconstructed pagetables.  We copy the Xen L2's into
