Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0H0JqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:46:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44231 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0H0Jos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p8czifG+tlwMhHXHYDiIxz6SmPFdgPTJJDI/zj7sr2vH85jnSl8YeSnc6NwnPvD91R
         yVIPzufJQs93ELdLc0g9bc3VWgZ3Pdnzxc9Dn86/IUgNLHRfSC2kk91uuNOd+7hpLlSd
         Rti7UwVU6S555Bgp2fVpMOlfmQWOHWs8VEH0s=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [RFC PATCH 37/43] ptrace, sparc: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:23 +0900
Message-Id: <1282902149-12991-38-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/kernel/ptrace_32.c |    3 ++-
 arch/sparc/kernel/ptrace_64.c |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index e608f39..e08ba4a 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -323,7 +323,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sparc32_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
 	const struct user_regset_view *view;
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index aa90da0..d9db5a4 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -969,7 +969,8 @@ struct fps {
 	unsigned long fsr;
 };
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	const struct user_regset_view *view = task_user_regset_view(current);
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
@@ -977,8 +978,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	struct fps __user *fps;
 	int ret;
 
-	pregs = (struct pt_regs __user *) (unsigned long) addr;
-	fps = (struct fps __user *) (unsigned long) addr;
+	pregs = (struct pt_regs __user *) addr;
+	fps = (struct fps __user *) addr;
 
 	switch (request) {
 	case PTRACE_PEEKUSR:
-- 
1.7.2.2

