Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1AHMHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 07:07:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:58332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1AHMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 07:07:21 -0500
Date: Sat, 8 Jan 2011 12:06:49 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        sandmann@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rakib.mullick@gmail.com, a.p.zijlstra@chello.nl,
        sandmann@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
References: <AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86, dumpstack: Fix unused variable warning
Message-ID: <tip-39a6eebda253aa34d659ca9436e3c32ef60473f1@git.kernel.org>
Git-Commit-ID: 39a6eebda253aa34d659ca9436e3c32ef60473f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 Jan 2011 12:06:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39a6eebda253aa34d659ca9436e3c32ef60473f1
Gitweb:     http://git.kernel.org/tip/39a6eebda253aa34d659ca9436e3c32ef60473f1
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Fri, 7 Jan 2011 16:59:49 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 7 Jan 2011 16:59:49 +0100

x86, dumpstack: Fix unused variable warning

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
