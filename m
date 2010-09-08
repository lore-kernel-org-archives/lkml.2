Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0IHIhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:37:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0IHIhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:37:02 -0400
Date: Wed, 8 Sep 2010 08:36:08 GMT
From: tip-bot for Christian Dietrich 
	<qy03fugy@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        efault@gmx.de, peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        qy03fugy@stud.informatik.uni-erlangen.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de, tj@kernel.org, tglx@linutronix.de,
        qy03fugy@stud.informatik.uni-erlangen.de, mingo@elte.hu
In-Reply-To: <7a3a39ef3f765a4473cb026b1f204059568a7098.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <7a3a39ef3f765a4473cb026b1f204059568a7098.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unnecessary #ifdef CONFIG_SMP
Message-ID: <tip-ed2d372c0738386b8a184a6a6bea9c16df6ffb68@git.kernel.org>
Git-Commit-ID: ed2d372c0738386b8a184a6a6bea9c16df6ffb68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:36:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed2d372c0738386b8a184a6a6bea9c16df6ffb68
Gitweb:     http://git.kernel.org/tip/ed2d372c0738386b8a184a6a6bea9c16df6ffb68
Author:     Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
AuthorDate: Mon, 6 Sep 2010 16:37:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Sep 2010 08:14:20 +0200

sched: Remove unnecessary #ifdef CONFIG_SMP

The CONFIG_SMP ifdef isn't necessary at this point, because it
is checked in an outer ifdef level already and has no effect
here.

Cleanup only, no functional effect.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <7a3a39ef3f765a4473cb026b1f204059568a7098.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..8eef8e5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -426,9 +426,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
-#ifdef CONFIG_SMP
 	struct cpupri cpupri;
-#endif
 };
 
 /*
@@ -437,7 +435,7 @@ struct root_domain {
  */
 static struct root_domain def_root_domain;
 
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * This is the main, per-CPU runqueue data structure.
