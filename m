Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0J1Pms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:42:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33639 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab0J1Pmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:42:43 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, namhyung@gmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: fix ptrace build error
Date: Thu, 28 Oct 2010 17:42:30 +0200
Message-Id: <1288280550-26997-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both 0a3d763 and 9b05a69 broke the um build.
This patch fixes the issues.

0a3d763 introduced the undeclared variable "datavp".
The patch seems completely untested. :-(

9b05a69 changed arch_ptrace()'s signature but did not
update um/include/asm/ptrace-generic.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/ptrace-generic.h |    4 ++--
 arch/um/kernel/ptrace.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 2cd899f..b7c5bab 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -38,8 +38,8 @@ struct pt_regs {
 
 struct task_struct;
 
-extern long subarch_ptrace(struct task_struct *child, long request, long addr,
-			   long data);
+extern long subarch_ptrace(struct task_struct *child, long request,
+	unsigned long addr, unsigned long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
 extern int get_fpregs(struct user_i387_struct __user *buf,
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index a5e33f2..701b672 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -122,7 +122,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr, datavp);
+		ret = ptrace_set_thread_area(child, addr, vp);
 		break;
 
 	case PTRACE_FAULTINFO: {
-- 
1.6.6.1

