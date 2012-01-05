Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2AEOhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:37:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441Ab2AEOhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:37:10 -0500
Date: Thu, 5 Jan 2012 15:35:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanup changes for v3.3
Message-ID: <20120105143503.GA4316@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, CPU: Drop superfluous get_cpu_cap() prototype

Ferenc Wagner (1):
      x86: Replace the EVT_TO_HPET_DEV() macro with an inline function

H Hartley Sweeten (2):
      arch/x86/kernel/ptrace.c: Quiet sparse noise
      arch/x86/mm/pageattr.c: Quiet sparse noise; local functions should be static

Jesper Juhl (2):
      x86: Use "do { } while(0)" for empty flush_tlb_fix_spurious_fault() macro
      x86: Use "do { } while(0)" for empty lock_cmos()/unlock_cmos() macros

Thomas Meyer (1):
      x86: Use kmemdup() in copy_thread(), rather than duplicating its implementation


 arch/x86/include/asm/mc146818rtc.h |    4 ++--
 arch/x86/include/asm/pgtable.h     |    2 +-
 arch/x86/kernel/cpu/cpu.h          |    5 +----
 arch/x86/kernel/hpet.c             |    7 +++++--
 arch/x86/kernel/process_64.c       |    5 ++---
 arch/x86/kernel/ptrace.c           |    3 ++-
 arch/x86/mm/pageattr.c             |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index 01fdf56..0e8e85b 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -81,8 +81,8 @@ static inline unsigned char current_lock_cmos_reg(void)
 #else
 #define lock_cmos_prefix(reg) do {} while (0)
 #define lock_cmos_suffix(reg) do {} while (0)
-#define lock_cmos(reg)
-#define unlock_cmos()
+#define lock_cmos(reg) do { } while (0)
+#define unlock_cmos() do { } while (0)
 #define do_i_have_lock_cmos() 0
 #define current_lock_cmos_reg() 0
 #endif
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 18601c8..49afb3f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -703,7 +703,7 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
-#define flush_tlb_fix_spurious_fault(vma, address)
+#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
 
 #define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 1b22dcc..8bacc78 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -1,5 +1,4 @@
 #ifndef ARCH_X86_CPU_H
-
 #define ARCH_X86_CPU_H
 
 struct cpu_model_info {
@@ -35,6 +34,4 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
-extern void get_cpu_cap(struct cpuinfo_x86 *c);
-
-#endif
+#endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b946a9e..52aae9a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -32,8 +32,6 @@
 #define HPET_MIN_CYCLES			128
 #define HPET_MIN_PROG_DELTA		(HPET_MIN_CYCLES + (HPET_MIN_CYCLES >> 1))
 
-#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
-
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
@@ -55,6 +53,11 @@ struct hpet_dev {
 	char				name[10];
 };
 
+inline struct hpet_dev *EVT_TO_HPET_DEV(struct clock_event_device *evtdev)
+{
+	return container_of(evtdev, struct hpet_dev, evt);
+}
+
 inline unsigned int hpet_readl(unsigned int a)
 {
 	return readl(hpet_virt_address + a);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3bd7e6e..d2c1f62 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -293,13 +293,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
-		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
+		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
+						  IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
 			p->thread.io_bitmap_max = 0;
 			return -ENOMEM;
 		}
-		memcpy(p->thread.io_bitmap_ptr, me->thread.io_bitmap_ptr,
-				IO_BITMAP_BYTES);
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
 	}
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8252879..89a04c7 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -749,7 +749,8 @@ put:
 /*
  * Handle PTRACE_POKEUSR calls for the debug register area.
  */
-int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+static int ptrace_set_debugreg(struct task_struct *tsk, int n,
+			       unsigned long val)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	int rc = 0;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..eda2acb 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -998,7 +998,7 @@ out_err:
 }
 EXPORT_SYMBOL(set_memory_uc);
 
-int _set_memory_array(unsigned long *addr, int addrinarray,
+static int _set_memory_array(unsigned long *addr, int addrinarray,
 		unsigned long new_type)
 {
 	int i, j;
