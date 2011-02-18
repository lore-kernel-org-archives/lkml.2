Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1BRMrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:47:17 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45461 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1BRMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:47:14 -0500
Message-ID: <4D5E6A54.4090901@linux.vnet.ibm.com>
Date: Fri, 18 Feb 2011 18:17:16 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 2/2 v3.0]sched: Updating the sched-stat documentation
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D5E6970.1000105@linux.vnet.ibm.com>
In-Reply-To: <4D5E6970.1000105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Date: Fri, 18 Feb 2011 16:29:14 +0530
Subject: [PATCH 2/2 v3.0] sched: Updating the sched-stat documentation

Some of the unused fields are removed from /proc/schedstat.
This is the documentation changes reflecting the same.

Signed-off-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
---
 Documentation/scheduler/sched-stats.txt |  144 ++++++++++++-------------------
 1 files changed, 55 insertions(+), 89 deletions(-)

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..de47562 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -1,3 +1,4 @@
+Version 16 of schedstats removed some of the unused fields.
 Version 15 of schedstats dropped counters for some sched_yield:
 yld_exp_empty, yld_act_empty and yld_both_empty. Otherwise, it is
 identical to version 14.
@@ -30,112 +31,77 @@ Note that any such script will necessarily be version-specific, as the main
 reason to change versions is changes in the output format.  For those wishing
 to write their own scripts, the fields are described here.
 
+The first two fields of /proc/schedstat indicates the version (current
+version is 16) and jiffies values. The following values are from 
+cpu & domain statistics.
+
 CPU statistics
 --------------
-cpu<N> 1 2 3 4 5 6 7 8 9
-
-First field is a sched_yield() statistic:
-     1) # of times sched_yield() was called
-
-Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
-     3) # of times schedule() was called
-     4) # of times schedule() left the processor idle
-
-Next two are try_to_wake_up() statistics:
-     5) # of times try_to_wake_up() was called
-     6) # of times try_to_wake_up() was called to wake up the local cpu
-
-Next three are statistics describing scheduling latency:
-     7) sum of all time spent running by tasks on this processor (in jiffies)
-     8) sum of all time spent waiting to run by tasks on this processor (in
-        jiffies)
-     9) # of timeslices run on this cpu
-
+The format is like this:
+
+cpu<N> 1 2 3 4 5 6 7 8
+
+     1) # of times sched_yield() was called on this CPU
+     2) # of times scheduler runs on this CPU
+     3) # of times scheduler picks idle task as next task on this CPU
+     4) # of times try_to_wake_up() is run on this CPU 
+        (Number of times task wakeup is attempted from this CPU)
+     5) # of times try_to_wake_up() wakes up a task on the same CPU 
+        (local wakeup)
+     6) Time(ns) for which tasks have run on this CPU
+     7) Time(ns) for which tasks on this CPU's runqueue have waited 
+        before getting to run on the CPU
+     8) # of tasks that have run on this CPU
 
 Domain statistics
 -----------------
-One of these is produced per domain for each cpu described. (Note that if
-CONFIG_SMP is not defined, *no* domains are utilized and these lines
-will not appear in the output.)
+One of these is produced per domain for each cpu described. 
+(Note that if CONFIG_SMP is not defined, *no* domains are utilized
+and these lines will not appear in the output.)
 
-domain<N> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
+domain<N> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
 
 The first field is a bit mask indicating what cpus this domain operates over.
 
 The next 24 are a variety of load_balance() statistics in grouped into types
 of idleness (idle, busy, and newly idle):
 
-     1) # of times in this domain load_balance() was called when the
-        cpu was idle
-     2) # of times in this domain load_balance() checked but found
-        the load did not require balancing when the cpu was idle
-     3) # of times in this domain load_balance() tried to move one or
-        more tasks and failed, when the cpu was idle
-     4) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was idle
-     5) # of times in this domain pull_task() was called when the cpu
-        was idle
-     6) # of times in this domain pull_task() was called even though
-        the target task was cache-hot when idle
-     7) # of times in this domain load_balance() was called but did
-        not find a busier queue while the cpu was idle
-     8) # of times in this domain a busier queue was found while the
-        cpu was idle but no busier group was found
-
-     9) # of times in this domain load_balance() was called when the
-        cpu was busy
-    10) # of times in this domain load_balance() checked but found the
-        load did not require balancing when busy
-    11) # of times in this domain load_balance() tried to move one or
-        more tasks and failed, when the cpu was busy
-    12) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was busy
-    13) # of times in this domain pull_task() was called when busy
-    14) # of times in this domain pull_task() was called even though the
-        target task was cache-hot when busy
-    15) # of times in this domain load_balance() was called but did not
-        find a busier queue while the cpu was busy
-    16) # of times in this domain a busier queue was found while the cpu
-        was busy but no busier group was found
-
-    17) # of times in this domain load_balance() was called when the
-        cpu was just becoming idle
-    18) # of times in this domain load_balance() checked but found the
-        load did not require balancing when the cpu was just becoming idle
-    19) # of times in this domain load_balance() tried to move one or more
-        tasks and failed, when the cpu was just becoming idle
-    20) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was just becoming idle
-    21) # of times in this domain pull_task() was called when newly idle
-    22) # of times in this domain pull_task() was called even though the
-        target task was cache-hot when just becoming idle
-    23) # of times in this domain load_balance() was called but did not
-        find a busier queue while the cpu was just becoming idle
-    24) # of times in this domain a busier queue was found while the cpu
-        was just becoming idle but no busier group was found
-
+CPU_NOT_IDLE:      Load balancer is being run on a CPU when it is 
+                   not in IDLE state (busy times)
+CPU_NEWLY_IDLE:    Load balancer is being run on a CPU which is 
+                   about to enter IDLE state
+
+There are eight stats available for each of the above three states:
+     - # of times in this domain load_balance() was called
+     - # of times in this domain load_balance() checked but found
+        the load did not require balancing
+     - # of times in this domain load_balance() tried to move one or
+        more tasks and failed
+     - sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain
+     - # of times in this domain pull_task() was called
+     - # of times in this domain pull_task() was called even though
+        the target task was cache-hot
+     - # of times in this domain load_balance() was called but did
+        not find a busier queue
+     - # of times in this domain a busier queue was found but no 
+        busier group was found
+
+   The first 1-8) fields are the stats when cpu was idle (CPU_IDLE),
+   the next 9-15) fields are the stats when cpu was busy (CPU_NOT_IDLE),
+   and the next 16-24) fields are the stats when cpu  was just 
+   becoming idle (CPU_NEWLY_IDLE)
+ 
    Next three are active_load_balance() statistics:
     25) # of times active_load_balance() was called
     26) # of times active_load_balance() tried to move a task and failed
     27) # of times active_load_balance() successfully moved a task
 
-   Next three are sched_balance_exec() statistics:
-    28) sbe_cnt is not used
-    29) sbe_balanced is not used
-    30) sbe_pushed is not used
-
-   Next three are sched_balance_fork() statistics:
-    31) sbf_cnt is not used
-    32) sbf_balanced is not used
-    33) sbf_pushed is not used
-
-   Next three are try_to_wake_up() statistics:
-    34) # of times in this domain try_to_wake_up() awoke a task that
-        last ran on a different cpu in this domain
-    35) # of times in this domain try_to_wake_up() moved a task to the
-        waking cpu because it was cache-cold on its own cpu anyway
-    36) # of times in this domain try_to_wake_up() started passive balancing
+   Next two are try_to_wake_up() statistics:
+    28) # of times in this domain try_to_wake_up() awoke a task that
+         last ran on a different cpu in this domain
+    29) # of times in this domain try_to_wake_up() moved a task to the
+         waking cpu because it was cache-cold on its own cpu anyway
 
 /proc/<pid>/schedstat
 ----------------
