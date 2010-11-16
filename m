Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0KPWUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:20:24 -0500
Received: from www.tglx.de ([62.245.132.106]:38283 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0KPWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:20:22 -0500
Date: Tue, 16 Nov 2010 23:20:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] futex fix for 2.6.37
Message-ID: <alpine.LFD.2.00.1011162318470.2900@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

Thanks,

	tglx

------------------>
Darren Hart (1):
      futex: Address compiler warnings in exit_robust_list


 kernel/futex.c        |    3 ++-
 kernel/futex_compat.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c683b3..40a8777 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	unsigned int uninitialized_var(next_pi);
 	unsigned long futex_offset;
 	int rc;
 
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 06da4df..a7934ac 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -49,7 +49,8 @@ void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	unsigned int uninitialized_var(next_pi);
 	compat_uptr_t uentry, next_uentry, upending;
 	compat_long_t futex_offset;
 	int rc;
