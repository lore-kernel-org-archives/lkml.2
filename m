Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0H0JpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:45:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0H0Jo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gc9A2/2EbHlJH+kB9h9azwhMc1jxPvsyAuEFw+7TW7yV6i4WNw141vRZOPC49bALAt
         iqLcD9XTep0sK3Ej8BySFnwvOIBecLJYrxBP6pVICEVscGBlS4ADzwM5CNr8cgjtxg6l
         hJusNJ6hqoU+rAFy++kdYCUqU0LkcV8EVKK2s=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: [RFC PATCH 40/43] ptrace, um: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:26 +0900
Message-Id: <1282902149-12991-41-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/ptrace.c     |    5 +++--
 arch/um/sys-i386/ptrace.c   |    4 ++--
 arch/um/sys-x86_64/ptrace.c |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index e051049..963d82b 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -42,10 +42,11 @@ void ptrace_disable(struct task_struct *child)
 extern int peek_user(struct task_struct * child, long addr, long data);
 extern int poke_user(struct task_struct * child, long addr, long data);
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int i, ret;
-	unsigned long __user *p = (void __user *)(unsigned long)data;
+	unsigned long __user *p = (void __user *)data;
 
 	switch (request) {
 	/* read word at location addr. */
diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-i386/ptrace.c
index c9b1765..d23b2d3 100644
--- a/arch/um/sys-i386/ptrace.c
+++ b/arch/um/sys-i386/ptrace.c
@@ -203,8 +203,8 @@ int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 				     (unsigned long *) &fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	return -EIO;
 }
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index f3458d7..67e6368 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -175,8 +175,8 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
 
-- 
1.7.2.2

