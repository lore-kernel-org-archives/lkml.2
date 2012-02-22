Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2BVQMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:12:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BVQMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:12:31 -0500
Date: Wed, 22 Feb 2012 08:11:30 -0800
From: "tip-bot for Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Message-ID: <tip-62f6536a630affe3176deb48554d27ee58b65077@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, nikunj@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, nikunj@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120217030409.11748.12491.stgit@abhimanyu>
References: <20120217030409.11748.12491.stgit@abhimanyu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove rcu_read_lock/unlock()
  from select_idle_sibling()
Git-Commit-ID: 62f6536a630affe3176deb48554d27ee58b65077
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:11:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62f6536a630affe3176deb48554d27ee58b65077
Gitweb:     http://git.kernel.org/tip/62f6536a630affe3176deb48554d27ee58b65077
Author:     Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
AuthorDate: Fri, 17 Feb 2012 08:34:30 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 12:28:28 +0100

sched: Remove rcu_read_lock/unlock() from select_idle_sibling()

select_idle_sibling() is called from select_task_rq_fair(), which
already has the RCU read lock held.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120217030409.11748.12491.stgit@abhimanyu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4ab60a2..6ce9992 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2670,8 +2670,6 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	rcu_read_lock();
-
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
@@ -2693,8 +2691,6 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
-	rcu_read_unlock();
-
 	return target;
 }
 
