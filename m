Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0FVMtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 08:49:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:39380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0FVMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:49:18 -0400
Date: Tue, 22 Jun 2010 12:48:43 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tj@kernel.org, tony.luck@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
       tony.luck@intel.com, mingo@elte.hu
In-Reply-To: <4C1FDF5B.1040301@kernel.org>
References: <4C1FDF5B.1040301@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, cpuset: Drop __cpuexit from cpu hotplug callbacks
Message-ID: <tip-0b2e918aa99fe6c3b8f163aa323a275ad8577828@git.kernel.org>
Git-Commit-ID: 0b2e918aa99fe6c3b8f163aa323a275ad8577828
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Jun 2010 12:48:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b2e918aa99fe6c3b8f163aa323a275ad8577828
Gitweb:     http://git.kernel.org/tip/0b2e918aa99fe6c3b8f163aa323a275ad8577828
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 21 Jun 2010 23:53:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Jun 2010 08:07:39 +0200

sched, cpuset: Drop __cpuexit from cpu hotplug callbacks

Commit 3a101d05 (sched: adjust when cpu_active and cpuset
configurations are updated during cpu on/offlining) added
hotplug notifiers marked with __cpuexit; however, ia64 drops
text in __cpuexit during link unlike x86.

This means that functions which are referenced during init but used
only for cpu hot unplugging afterwards shouldn't be marked with
__cpuexit. Drop __cpuexit from those functions.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4C1FDF5B.1040301@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpuset.c |    2 +-
 kernel/sched.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 05727dc..7146793 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2118,7 +2118,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
  */
-void __cpuexit cpuset_update_active_cpus(void)
+void cpuset_update_active_cpus(void)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
diff --git a/kernel/sched.c b/kernel/sched.c
index b4427cc..9064e7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7477,8 +7477,8 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
  * around partition_sched_domains().
  */
-static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
-				       unsigned long action, void *hcpu)
+static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
+			     void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
@@ -7490,8 +7490,8 @@ static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
 	}
 }
 
-static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
-					 unsigned long action, void *hcpu)
+static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
+			       void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
