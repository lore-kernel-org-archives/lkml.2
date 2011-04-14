Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1DNGCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:02:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57578 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab1DNGBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:01:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] Blackfin: convert to asm-generic ptrace.h
Date: Thu, 14 Apr 2011 02:01:32 -0400
Message-Id: <1302760895-13459-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ptrace.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/ptrace.h b/arch/blackfin/include/asm/ptrace.h
index 681a92c..10d8641 100644
--- a/arch/blackfin/include/asm/ptrace.h
+++ b/arch/blackfin/include/asm/ptrace.h
@@ -102,9 +102,6 @@ struct pt_regs {
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
-#define instruction_pointer(regs) ((regs)->pc)
-#define user_stack_pointer(regs)  ((regs)->usp)
-#define profile_pc(regs) instruction_pointer(regs)
 
 #define arch_has_single_step()	(1)
 /* common code demands this function */
@@ -127,6 +124,8 @@ extern int is_user_addr_valid(struct task_struct *child,
 	    ((unsigned long)task_stack_page(task) + \
 	     (THREAD_SIZE - sizeof(struct pt_regs)))
 
+#include <asm-generic/ptrace.h>
+
 #endif  /*  __KERNEL__  */
 
 #endif				/* __ASSEMBLY__ */
-- 
1.7.5.rc1

