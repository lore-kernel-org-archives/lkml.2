Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1G2QNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:13:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65409 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1G2QNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:13:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/8 v3] cgroups: Task counter subsystem (was: New max number of tasks subsystem)
Date: Fri, 29 Jul 2011 18:13:22 +0200
Message-Id: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reminder:

This patchset is aimed at reducing the impact of a forkbomb to a
cgroup boundaries, thus minimizing the consequences of such an attack
against the rest of the system.

This can be useful when cgroups are used to stage some processes or run
untrustees.


changes in v3:

- acks added
- simplify resource counter inheritance (patch 2/8)
- rename "max_tasks" into "tasks" subsystem (patch 7/8)
- general renaming of "max tasks" into "task counter" for filename and config (patch 7/8)
- simplification in accessors (patch 7/8)
- drop root task counter object, only keep a root task counter css (patch 7/8)
- rename cgroup files into "usage" and "limit" (patch 7/8)
- drop need for that limit_fail_at pointer on charge (patch 8/8)

This can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	cgroup/nr_proc-v2

Frederic Weisbecker (8):
  cgroups: Add res_counter_write_u64() API
  cgroups: New resource counter inheritance API
  cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
  cgroups: New cancel_attach_task subsystem callback
  cgroups: Ability to stop res charge propagation on bounded ancestor
  cgroups: Add res counter common ancestor searching
  cgroups: Add a task counter subsystem
  res_counter: Allow charge failure pointer to be null

 block/blk-cgroup.c            |   10 ++-
 include/linux/cgroup.h        |   15 +++-
 include/linux/cgroup_subsys.h |    8 ++
 include/linux/res_counter.h   |   12 +++
 init/Kconfig                  |    7 ++
 kernel/Makefile               |    1 +
 kernel/cgroup.c               |   25 ++++--
 kernel/cgroup_freezer.c       |    3 +-
 kernel/cgroup_task_counter.c  |  176 +++++++++++++++++++++++++++++++++++++++++
 kernel/cpuset.c               |    6 +-
 kernel/events/core.c          |    5 +-
 kernel/fork.c                 |    4 +
 kernel/res_counter.c          |   81 ++++++++++++++++---
 kernel/sched.c                |    6 +-
 14 files changed, 326 insertions(+), 33 deletions(-)
 create mode 100644 kernel/cgroup_task_counter.c

-- 
1.7.5.4

