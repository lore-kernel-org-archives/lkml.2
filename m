Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249Ab2EWPeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:34:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2EWPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:34:17 -0400
Date: Wed, 23 May 2012 08:34:01 -0700
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <tip-b51b94a599239de4e3cf769e257a7e87928f20be@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        ebiederm@xmission.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        ebiederm@xmission.com
In-Reply-To: <20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au>
References: <20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa, userns: Fix user_ns move to '
 struct cred'
Git-Commit-ID: b51b94a599239de4e3cf769e257a7e87928f20be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:34:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b51b94a599239de4e3cf769e257a7e87928f20be
Gitweb:     http://git.kernel.org/tip/b51b94a599239de4e3cf769e257a7e87928f20be
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Mon, 21 May 2012 17:50:09 +1000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 23 May 2012 16:30:55 +0200

sched/numa, userns: Fix user_ns move to 'struct cred'

Eliminate obsolete (and to be removed) cred->user-> use.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Link: http://lkml.kernel.org/r/20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index fdf737d..de66256 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -1268,7 +1268,7 @@ static int ng_allowed(struct numa_group *ng, struct task_struct *p)
 
 	rcu_read_lock();
 	tcred = __task_cred(p);
-	if (cred->user->user_ns == tcred->user->user_ns &&
+	if (cred->user_ns == tcred->user_ns &&
 	    (cred->uid == tcred->euid &&
 	     cred->uid == tcred->suid &&
 	     cred->uid == tcred->uid  &&
@@ -1276,7 +1276,7 @@ static int ng_allowed(struct numa_group *ng, struct task_struct *p)
 	     cred->gid == tcred->sgid &&
 	     cred->gid == tcred->gid))
 		goto ok;
-	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (ns_capable(tcred->user_ns, CAP_SYS_PTRACE))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
