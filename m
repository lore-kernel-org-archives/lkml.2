Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1LOJ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:57:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1LOJ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:57:47 -0500
Date: Thu, 15 Dec 2011 01:56:45 -0800
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-abd63bc3a0f65ae9d85bc3b1bb067d3e3c2b2cc2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, keescook@chromium.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        mingo@elte.hu
In-Reply-To: <20111214223925.GA27578@www.outflux.net>
References: <20111214223925.GA27578@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Mark parent and real_parent as __rcu
Git-Commit-ID: abd63bc3a0f65ae9d85bc3b1bb067d3e3c2b2cc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 01:56:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abd63bc3a0f65ae9d85bc3b1bb067d3e3c2b2cc2
Gitweb:     http://git.kernel.org/tip/abd63bc3a0f65ae9d85bc3b1bb067d3e3c2b2cc2
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Wed, 14 Dec 2011 14:39:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Dec 2011 08:21:59 +0100

sched: Mark parent and real_parent as __rcu

The parent and real_parent pointers should be considered __rcu,
since they should be held under either tasklist_lock or
rcu_read_lock.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/20111214223925.GA27578@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cc8c620..5ef0901 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1330,8 +1330,8 @@ struct task_struct {
 	 * older sibling, respectively.  (p->father can be replaced with 
 	 * p->real_parent->pid)
 	 */
-	struct task_struct *real_parent; /* real parent process */
-	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	struct task_struct __rcu *real_parent; /* real parent process */
+	struct task_struct __rcu *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
 	 * children/sibling forms the list of my natural children
 	 */
