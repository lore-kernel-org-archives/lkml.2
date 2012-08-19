Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2HSDBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:36894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422062"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 31/74] x86, lto: Make various variables used by assembler code __visible
Date: Sat, 18 Aug 2012 19:56:27 -0700
Message-Id: <1345345030-22211-32-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 arch/x86/kernel/process_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786..8f12e8c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1075,7 +1075,7 @@ EXPORT_PER_CPU_SYMBOL(kernel_stack);
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
-DEFINE_PER_CPU(unsigned int, irq_count) = -1;
+DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
@@ -1114,7 +1114,7 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
+unsigned long kernel_eflags __visible;
 
 /*
  * Copies of the original ist values from the tss are only accessed during
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a5720ed..34435e2 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -52,7 +52,7 @@
 
 asmlinkage extern void ret_from_fork(void);
 
-DEFINE_PER_CPU(unsigned long, old_rsp);
+asmlinkage DEFINE_PER_CPU(unsigned long, old_rsp);
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
-- 
1.7.7.6

