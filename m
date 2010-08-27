Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0H0Joe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0H0Jo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H3zeQOa5cNGvM3eutjR7fD8pgRELxC4oXqLXGQAf/IKTZJv0SH6dZQrYMWrQ2sufGk
         Q0yQYobtShpBpSzEdkoqgDOAUfBv9hd+/cTdOJn6PjJFlZAjGwiuTy9Nu//krdQ0f52l
         HVuMtguZ+4+y4TkOsuZF1RRKEiSGDqukDX4Hg=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [RFC PATCH 31/43] ptrace, powerpc: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:17 +0900
Message-Id: <1282902149-12991-32-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/ptrace.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 11f3cd9..e4b6d75 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1406,8 +1406,8 @@ static long ppc_del_hwdebug(struct task_struct *child, long addr, long data)
  * Here are the old "legacy" powerpc specific getregs/setregs ptrace calls,
  * we mark them as obsolete now, they will be removed in a future version
  */
-static long arch_ptrace_old(struct task_struct *child, long request, long addr,
-			    long data)
+static long arch_ptrace_old(struct task_struct *child, long request,
+			    unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
@@ -1434,7 +1434,8 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 	return -EPERM;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
@@ -1446,11 +1447,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
@@ -1474,11 +1475,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
-- 
1.7.2.2

