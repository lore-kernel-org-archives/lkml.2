Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323Ab2EQRFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:05:07 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53783 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967512Ab2EQRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:05:01 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 5/5] cpusets: Remove/update outdated comments
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 17 May 2012 22:33:48 +0530
Message-ID: <20120517170340.3011.83286.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051717-4790-0000-0000-000002BFC17B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset_track_online_cpus() is no longer present. So remove the
outdated comment and replace it with reference to cpuset_update_active_cpus()
which is its equivalent.

Also, we don't lack memory hot-unplug anymore. And David Rientjes pointed
out how it is dealt with. So update that comment as well.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpuset.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e44db78..89ff649 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2046,9 +2046,8 @@ static struct cpuset *cpuset_next(struct list_head *queue)
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
@@ -2171,7 +2170,7 @@ void cpuset_update_active_cpus(bool cpu_online)
 /*
  * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
  * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
- * See also the previous routine cpuset_track_online_cpus().
+ * See cpuset_update_active_cpus() for CPU hotplug handling.
  */
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)

