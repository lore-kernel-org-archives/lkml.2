Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2HSC6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:59858 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2HSC51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="135817666"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/74] sections: Add __visible to x86 sections
Date: Sat, 18 Aug 2012 19:56:05 -0700
Message-Id: <1345345030-22211-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/alternative.c |    4 ++--
 arch/x86/kernel/vsyscall_64.c |    4 ++--
 arch/x86/power/hibernate_32.c |    2 +-
 arch/x86/um/vdso/vma.c        |    2 +-
 arch/x86/vdso/vma.c           |   10 +++++-----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..27ae345 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -252,8 +252,8 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 	}
 }
 
-extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern s32 __smp_locks[], __smp_locks_end[];
+extern __visible struct alt_instr __alt_instructions[], __alt_instructions_end[];
+extern __visible s32 __smp_locks[], __smp_locks_end[];
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8d141b3..70f25f2 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -355,9 +355,9 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 
 void __init map_vsyscall(void)
 {
-	extern char __vsyscall_page;
+	extern __visible char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
-	extern char __vvar_page;
+	extern __visible char __vvar_page;
 	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 74202c1..7b8d7df 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -18,7 +18,7 @@
 extern int restore_image(void);
 
 /* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
+extern __visible const void __nosave_begin, __nosave_end;
 
 /* Pointer to the temporary resume page tables */
 pgd_t *resume_pg_dir;
diff --git a/arch/x86/um/vdso/vma.c b/arch/x86/um/vdso/vma.c
index af91901..a09f903 100644
--- a/arch/x86/um/vdso/vma.c
+++ b/arch/x86/um/vdso/vma.c
@@ -16,7 +16,7 @@ unsigned int __read_mostly vdso_enabled = 1;
 unsigned long um_vdso_addr;
 
 extern unsigned long task_size;
-extern char vdso_start[], vdso_end[];
+extern __visible char vdso_start[], vdso_end[];
 
 static struct page **vdsop;
 
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 00aaf04..fe08e2b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -18,15 +18,15 @@
 
 unsigned int __read_mostly vdso_enabled = 1;
 
-extern char vdso_start[], vdso_end[];
-extern unsigned short vdso_sync_cpuid;
+extern __visible char vdso_start[], vdso_end[];
+extern __visible unsigned short vdso_sync_cpuid;
 
-extern struct page *vdso_pages[];
+extern __visible struct page *vdso_pages[];
 static unsigned vdso_size;
 
 #ifdef CONFIG_X86_X32_ABI
-extern char vdsox32_start[], vdsox32_end[];
-extern struct page *vdsox32_pages[];
+extern __visible char vdsox32_start[], vdsox32_end[];
+extern __visible struct page *vdsox32_pages[];
 static unsigned vdsox32_size;
 
 static void __init patch_vdsox32(void *vdso, size_t len)
-- 
1.7.7.6

