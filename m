Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1DNGCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:02:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57603 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab1DNGBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:01:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] x86: convert to asm-generic ptrace.h
Date: Thu, 14 Apr 2011 02:01:33 -0400
Message-Id: <1302760895-13459-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/x86/include/asm/ptrace.h |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 78cd1ea..98a5e97 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -136,6 +136,7 @@ struct cpuinfo_x86;
 struct task_struct;
 
 extern unsigned long profile_pc(struct pt_regs *regs);
+#define profile_pc profile_pc
 
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
@@ -202,20 +203,11 @@ static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 #endif
 }
 
-static inline unsigned long instruction_pointer(struct pt_regs *regs)
-{
-	return regs->ip;
-}
-
-static inline unsigned long frame_pointer(struct pt_regs *regs)
-{
-	return regs->bp;
-}
+#define GET_IP(regs) ((regs)->ip)
+#define GET_FP(regs) ((regs)->bp)
+#define GET_USP(regs) ((regs)->sp)
 
-static inline unsigned long user_stack_pointer(struct pt_regs *regs)
-{
-	return regs->sp;
-}
+#include <asm-generic/ptrace.h>
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-- 
1.7.5.rc1

