Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1AGRJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:09:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab1AGRJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YAmen+3fjcQ/pwJot2KVgCNqx02aTnVZVY0Pqig59qPmuhjnSv2KLs/XHZkmfCCYqy
         oQwvbqpkLaSsghc70To2Sa4a3OEEjpF/NU9ECfZqDu92iJjkUHHXkInpGbjPW2AVqeGb
         xUcXVwLqj1sxWYx9ep4Sxn3dFXQxwuNuksWuI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Soeren Sandmann <sandmann@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] x86, dumpstack: Fix unused variable warning
Date: Fri,  7 Jan 2011 18:08:59 +0100
Message-Id: <1294420140-6090-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294420140-6090-1-git-send-email-fweisbec@gmail.com>
References: <1294420140-6090-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

In dump_stack function, bp isn't used anymore, which is introduced by
commit 9c0729dc8062bed96189bd14ac6d4920f3958743. This patch removes bp
completely.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Soeren Sandmann <sandmann@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 8474c99..d6fb146 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -197,14 +197,8 @@ void show_stack(struct task_struct *task, unsigned long *sp)
  */
 void dump_stack(void)
 {
-	unsigned long bp = 0;
 	unsigned long stack;
 
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		get_bp(bp);
-#endif
-
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
-- 
1.7.3.2

