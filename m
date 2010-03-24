Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0CXVtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:49:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab0CXVtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:49:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Xm78CX4mTqkgCDkNUu5nwhlXxxkdoAAwWt3TVxs5wrAAgohkmcIBwYHJruz05EX5c
	3HDdm96sJkmPL1claabxw==
From: Greg Thelen <gthelen@google.com>
To: Paul Menage <menage@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jiri Kosina <jkosina@suse.cz>, Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geunsik Lim <geunsik.lim@samsung.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] cpuset: Fix documentation punctuation
Date: Wed, 24 Mar 2010 14:48:30 -0700
Message-Id: <1269467310-27685-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cpusets.txt documentation punctuation.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Documentation/cgroups/cpusets.txt |   38 ++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 4160df8..51682ab 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -42,7 +42,7 @@ Nodes to a set of tasks.   In this document "Memory Node" refers to
 an on-line node that contains memory.
 
 Cpusets constrain the CPU and Memory placement of tasks to only
-the resources within a tasks current cpuset.  They form a nested
+the resources within a task's current cpuset.  They form a nested
 hierarchy visible in a virtual file system.  These are the essential
 hooks, beyond what is already present, required to manage dynamic
 job placement on large systems.
@@ -53,11 +53,11 @@ Documentation/cgroups/cgroups.txt.
 Requests by a task, using the sched_setaffinity(2) system call to
 include CPUs in its CPU affinity mask, and using the mbind(2) and
 set_mempolicy(2) system calls to include Memory Nodes in its memory
-policy, are both filtered through that tasks cpuset, filtering out any
+policy, are both filtered through that task's cpuset, filtering out any
 CPUs or Memory Nodes not in that cpuset.  The scheduler will not
 schedule a task on a CPU that is not allowed in its cpus_allowed
 vector, and the kernel page allocator will not allocate a page on a
-node that is not allowed in the requesting tasks mems_allowed vector.
+node that is not allowed in the requesting task's mems_allowed vector.
 
 User level code may create and destroy cpusets by name in the cgroup
 virtual file system, manage the attributes and permissions of these
@@ -121,9 +121,9 @@ Cpusets extends these two mechanisms as follows:
  - Each task in the system is attached to a cpuset, via a pointer
    in the task structure to a reference counted cgroup structure.
  - Calls to sched_setaffinity are filtered to just those CPUs
-   allowed in that tasks cpuset.
+   allowed in that task's cpuset.
  - Calls to mbind and set_mempolicy are filtered to just
-   those Memory Nodes allowed in that tasks cpuset.
+   those Memory Nodes allowed in that task's cpuset.
  - The root cpuset contains all the systems CPUs and Memory
    Nodes.
  - For any cpuset, one can define child cpusets containing a subset
@@ -141,11 +141,11 @@ into the rest of the kernel, none in performance critical paths:
  - in init/main.c, to initialize the root cpuset at system boot.
  - in fork and exit, to attach and detach a task from its cpuset.
  - in sched_setaffinity, to mask the requested CPUs by what's
-   allowed in that tasks cpuset.
+   allowed in that task's cpuset.
  - in sched.c migrate_live_tasks(), to keep migrating tasks within
    the CPUs allowed by their cpuset, if possible.
  - in the mbind and set_mempolicy system calls, to mask the requested
-   Memory Nodes by what's allowed in that tasks cpuset.
+   Memory Nodes by what's allowed in that task's cpuset.
  - in page_alloc.c, to restrict memory to allowed nodes.
  - in vmscan.c, to restrict page recovery to the current cpuset.
 
@@ -155,7 +155,7 @@ new system calls are added for cpusets - all support for querying and
 modifying cpusets is via this cpuset file system.
 
 The /proc/<pid>/status file for each task has four added lines,
-displaying the tasks cpus_allowed (on which CPUs it may be scheduled)
+displaying the task's cpus_allowed (on which CPUs it may be scheduled)
 and mems_allowed (on which Memory Nodes it may obtain memory),
 in the two formats seen in the following example:
 
@@ -323,17 +323,17 @@ stack segment pages of a task.
 
 By default, both kinds of memory spreading are off, and memory
 pages are allocated on the node local to where the task is running,
-except perhaps as modified by the tasks NUMA mempolicy or cpuset
+except perhaps as modified by the task's NUMA mempolicy or cpuset
 configuration, so long as sufficient free memory pages are available.
 
 When new cpusets are created, they inherit the memory spread settings
 of their parent.
 
 Setting memory spreading causes allocations for the affected page
-or slab caches to ignore the tasks NUMA mempolicy and be spread
+or slab caches to ignore the task's NUMA mempolicy and be spread
 instead.    Tasks using mbind() or set_mempolicy() calls to set NUMA
 mempolicies will not notice any change in these calls as a result of
-their containing tasks memory spread settings.  If memory spreading
+their containing task's memory spread settings.  If memory spreading
 is turned off, then the currently specified NUMA mempolicy once again
 applies to memory page allocations.
 
@@ -357,7 +357,7 @@ pages from the node returned by cpuset_mem_spread_node().
 
 The cpuset_mem_spread_node() routine is also simple.  It uses the
 value of a per-task rotor cpuset_mem_spread_rotor to select the next
-node in the current tasks mems_allowed to prefer for the allocation.
+node in the current task's mems_allowed to prefer for the allocation.
 
 This memory placement policy is also known (in other contexts) as
 round-robin or interleave.
@@ -594,7 +594,7 @@ is attached, is subtle.
 If a cpuset has its Memory Nodes modified, then for each task attached
 to that cpuset, the next time that the kernel attempts to allocate
 a page of memory for that task, the kernel will notice the change
-in the tasks cpuset, and update its per-task memory placement to
+in the task's cpuset, and update its per-task memory placement to
 remain within the new cpusets memory placement.  If the task was using
 mempolicy MPOL_BIND, and the nodes to which it was bound overlap with
 its new cpuset, then the task will continue to use whatever subset
@@ -603,13 +603,13 @@ was using MPOL_BIND and now none of its MPOL_BIND nodes are allowed
 in the new cpuset, then the task will be essentially treated as if it
 was MPOL_BIND bound to the new cpuset (even though its NUMA placement,
 as queried by get_mempolicy(), doesn't change).  If a task is moved
-from one cpuset to another, then the kernel will adjust the tasks
+from one cpuset to another, then the kernel will adjust the task's
 memory placement, as above, the next time that the kernel attempts
 to allocate a page of memory for that task.
 
 If a cpuset has its 'cpuset.cpus' modified, then each task in that cpuset
 will have its allowed CPU placement changed immediately.  Similarly,
-if a tasks pid is written to another cpusets 'cpuset.tasks' file, then its
+if a task's pid is written to another cpusets 'cpuset.tasks' file, then its
 allowed CPU placement is changed immediately.  If such a task had been
 bound to some subset of its cpuset using the sched_setaffinity() call,
 the task will be allowed to run on any CPU allowed in its new cpuset,
@@ -626,16 +626,16 @@ cpusets memory placement policy 'cpuset.mems' subsequently changes.
 If the cpuset flag file 'cpuset.memory_migrate' is set true, then when
 tasks are attached to that cpuset, any pages that task had
 allocated to it on nodes in its previous cpuset are migrated
-to the tasks new cpuset. The relative placement of the page within
+to the task's new cpuset. The relative placement of the page within
 the cpuset is preserved during these migration operations if possible.
 For example if the page was on the second valid node of the prior cpuset
 then the page will be placed on the second valid node of the new cpuset.
 
-Also if 'cpuset.memory_migrate' is set true, then if that cpusets
+Also if 'cpuset.memory_migrate' is set true, then if that cpuset's
 'cpuset.mems' file is modified, pages allocated to tasks in that
 cpuset, that were on nodes in the previous setting of 'cpuset.mems',
 will be moved to nodes in the new setting of 'mems.'
-Pages that were not in the tasks prior cpuset, or in the cpusets
+Pages that were not in the task's prior cpuset, or in the cpuset's
 prior 'cpuset.mems' setting, will not be moved.
 
 There is an exception to the above.  If hotplug functionality is used
@@ -655,7 +655,7 @@ There is a second exception to the above.  GFP_ATOMIC requests are
 kernel internal allocations that must be satisfied, immediately.
 The kernel may drop some request, in rare cases even panic, if a
 GFP_ATOMIC alloc fails.  If the request cannot be satisfied within
-the current tasks cpuset, then we relax the cpuset, and look for
+the current task's cpuset, then we relax the cpuset, and look for
 memory anywhere we can find it.  It's better to violate the cpuset
 than stress the kernel.
 
-- 
1.7.0.1

