Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0DBTMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:12:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0DBTLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:11:55 -0400
Date: Fri, 2 Apr 2010 19:11:26 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, serue@us.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, serue@us.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4BA9A07E.8070508@cn.fujitsu.com>
References: <4BA9A07E.8070508@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove USER_SCHED from documentation
Message-ID: <tip-25c2d55c00c6097e6792ebf21e31342f23b9b768@git.kernel.org>
Git-Commit-ID: 25c2d55c00c6097e6792ebf21e31342f23b9b768
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:11:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25c2d55c00c6097e6792ebf21e31342f23b9b768
Gitweb:     http://git.kernel.org/tip/25c2d55c00c6097e6792ebf21e31342f23b9b768
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Mar 2010 13:17:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:01 +0200

sched: Remove USER_SCHED from documentation

USER_SCHED has been removed, so update the documentation
accordingly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
LKML-Reference: <4BA9A07E.8070508@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/scheduler/sched-design-CFS.txt |   54 +------------------------
 Documentation/scheduler/sched-rt-group.txt   |   20 ++--------
 2 files changed, 7 insertions(+), 67 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 6f33593..8239ebb 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -211,7 +211,7 @@ provide fair CPU time to each such task group.  For example, it may be
 desirable to first provide fair CPU time to each user on the system and then to
 each task belonging to a user.
 
-CONFIG_GROUP_SCHED strives to achieve exactly that.  It lets tasks to be
+CONFIG_CGROUP_SCHED strives to achieve exactly that.  It lets tasks to be
 grouped and divides CPU time fairly among such groups.
 
 CONFIG_RT_GROUP_SCHED permits to group real-time (i.e., SCHED_FIFO and
@@ -220,38 +220,11 @@ SCHED_RR) tasks.
 CONFIG_FAIR_GROUP_SCHED permits to group CFS (i.e., SCHED_NORMAL and
 SCHED_BATCH) tasks.
 
-At present, there are two (mutually exclusive) mechanisms to group tasks for
-CPU bandwidth control purposes:
-
- - Based on user id (CONFIG_USER_SCHED)
-
-   With this option, tasks are grouped according to their user id.
-
- - Based on "cgroup" pseudo filesystem (CONFIG_CGROUP_SCHED)
-
-   This options needs CONFIG_CGROUPS to be defined, and lets the administrator
+   These options need CONFIG_CGROUPS to be defined, and let the administrator
    create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
    Documentation/cgroups/cgroups.txt for more information about this filesystem.
 
-Only one of these options to group tasks can be chosen and not both.
-
-When CONFIG_USER_SCHED is defined, a directory is created in sysfs for each new
-user and a "cpu_share" file is added in that directory.
-
-	# cd /sys/kernel/uids
-	# cat 512/cpu_share		# Display user 512's CPU share
-	1024
-	# echo 2048 > 512/cpu_share	# Modify user 512's CPU share
-	# cat 512/cpu_share		# Display user 512's CPU share
-	2048
-	#
-
-CPU bandwidth between two users is divided in the ratio of their CPU shares.
-For example: if you would like user "root" to get twice the bandwidth of user
-"guest," then set the cpu_share for both the users such that "root"'s cpu_share
-is twice "guest"'s cpu_share.
-
-When CONFIG_CGROUP_SCHED is defined, a "cpu.shares" file is created for each
+When CONFIG_FAIR_GROUP_SCHED is defined, a "cpu.shares" file is created for each
 group created using the pseudo filesystem.  See example steps below to create
 task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
@@ -273,24 +246,3 @@ task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
 	# #Launch gmplayer (or your favourite movie player)
 	# echo <movie_player_pid> > multimedia/tasks
-
-8. Implementation note: user namespaces
-
-User namespaces are intended to be hierarchical.  But they are currently
-only partially implemented.  Each of those has ramifications for CFS.
-
-First, since user namespaces are hierarchical, the /sys/kernel/uids
-presentation is inadequate.  Eventually we will likely want to use sysfs
-tagging to provide private views of /sys/kernel/uids within each user
-namespace.
-
-Second, the hierarchical nature is intended to support completely
-unprivileged use of user namespaces.  So if using user groups, then
-we want the users in a user namespace to be children of the user
-who created it.
-
-That is currently unimplemented.  So instead, every user in a new
-user namespace will receive 1024 shares just like any user in the
-initial user namespace.  Note that at the moment creation of a new
-user namespace requires each of CAP_SYS_ADMIN, CAP_SETUID, and
-CAP_SETGID.
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 86eabe6..605b0d4 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -126,23 +126,12 @@ priority!
 2.3 Basis for grouping tasks
 ----------------------------
 
-There are two compile-time settings for allocating CPU bandwidth. These are
-configured using the "Basis for grouping tasks" multiple choice menu under
-General setup > Group CPU Scheduler:
-
-a. CONFIG_USER_SCHED (aka "Basis for grouping tasks" =  "user id")
-
-This lets you use the virtual files under
-"/sys/kernel/uids/<uid>/cpu_rt_runtime_us" to control he CPU time reserved for
-each user .
-
-The other option is:
-
-.o CONFIG_CGROUP_SCHED (aka "Basis for grouping tasks" = "Control groups")
+Enabling CONFIG_RT_GROUP_SCHED lets you explicitly allocate real
+CPU bandwidth to task groups.
 
 This uses the /cgroup virtual file system and
 "/cgroup/<cgroup>/cpu.rt_runtime_us" to control the CPU time reserved for each
-control group instead.
+control group.
 
 For more information on working with control groups, you should read
 Documentation/cgroups/cgroups.txt as well.
@@ -161,8 +150,7 @@ For now, this can be simplified to just the following (but see Future plans):
 ===============
 
 There is work in progress to make the scheduling period for each group
-("/sys/kernel/uids/<uid>/cpu_rt_period_us" or
-"/cgroup/<cgroup>/cpu.rt_period_us" respectively) configurable as well.
+("/cgroup/<cgroup>/cpu.rt_period_us") configurable as well.
 
 The constraint on the period is that a subgroup must have a smaller or
 equal period to its parent. But realistically its not very useful _yet_
