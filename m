Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2GXORy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:17:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab2GXORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:17:52 -0400
Date: Tue, 24 Jul 2012 07:17:27 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-a1cd2b13f754b2c56fb87b8c4912c015f8f57c0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20120524141700.3692.98192.stgit@srivatsabhat.in.ibm.com>
References: <20120524141700.3692.98192.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpusets: Remove/update outdated comments
Git-Commit-ID: a1cd2b13f754b2c56fb87b8c4912c015f8f57c0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:17:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1cd2b13f754b2c56fb87b8c4912c015f8f57c0c
Gitweb:     http://git.kernel.org/tip/a1cd2b13f754b2c56fb87b8c4912c015f8f57c0c
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 24 May 2012 19:47:03 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Jul 2012 13:53:28 +0200

cpusets: Remove/update outdated comments

cpuset_track_online_cpus() is no longer present. So remove the
outdated comment and replace it with reference to cpuset_update_active_cpus()
which is its equivalent.

Also, we don't lack memory hot-unplug anymore. And David Rientjes pointed
out how it is dealt with. So update that comment as well.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120524141700.3692.98192.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpuset.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ba0a4d7..f33c715 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2034,9 +2034,8 @@ static struct cpuset *cpuset_next(struct list_head *queue)
  * before dropping down to the next.  It always processes a node before
  * any of its children.
  *
- * For now, since we lack memory hot unplug, we'll never see a cpuset
- * that has tasks along with an empty 'mems'.  But if we did see such
- * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
+ * In the case of memory hot-unplug, it will remove nodes from N_HIGH_MEMORY
+ * if all present pages from a node are offlined.
  */
 static void
 scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
@@ -2137,7 +2136,7 @@ void cpuset_update_active_cpus(bool cpu_online)
 /*
  * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
  * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
- * See also the previous routine cpuset_track_online_cpus().
+ * See cpuset_update_active_cpus() for CPU hotplug handling.
  */
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
