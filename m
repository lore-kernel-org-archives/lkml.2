Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2CBK54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:57:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab2CBK5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:57:55 -0500
Date: Fri, 2 Mar 2012 11:57:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20120302105749.GA21031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 8f2f748b0656257153bcf0941df8d6060acc5ca6 CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume

 Thanks,

	Ingo

------------------>
Srivatsa S. Bhat (1):
      CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume


 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..33a0676 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6728,7 +6728,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
@@ -6741,7 +6741,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
 		return NOTIFY_OK;
