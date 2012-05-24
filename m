Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab2EXOax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:30:53 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42621 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2EXOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:30:52 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 4/4] cpusets: Remove/update outdated comments
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 24 May 2012 19:47:03 +0530
Message-ID: <20120524141700.3692.98192.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
References: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052414-5564-0000-0000-000002EF4DF9
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

