Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2GaTor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:44:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2GaTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:42 -0400
Message-Id: <20120731191204.540691987@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/19] sched-numa rewrite
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After having had a talk with Rik about all this NUMA nonsense where he proposed
the scheme implemented in the next to last patch, I came up with a related
means of doing the home-node selection.

I've also switched to (ab)using PROT_NONE for driving the migration faults.

These patches go on top of tip/master with origin/master (Linus' tree) merged in.

Since the posting of last week (which was private due to operator error and not
intention) Ingo dropped all the previous patches from tip and I did a complete
rebase of the series, making all the back and forth of old and new stuff go away.

---
 arch/x86/include/asm/pgtable.h |    1 +
 drivers/base/node.c            |    2 +-
 include/linux/huge_mm.h        |    3 +
 include/linux/init_task.h      |    9 +
 include/linux/mempolicy.h      |   30 ++-
 include/linux/migrate.h        |    7 +
 include/linux/migrate_mode.h   |    3 +
 include/linux/mm.h             |   12 +
 include/linux/mm_types.h       |   12 +
 include/linux/mmzone.h         |    1 -
 include/linux/sched.h          |   30 ++-
 include/linux/task_work.h      |    7 -
 kernel/exit.c                  |    5 +-
 kernel/sched/core.c            |   71 ++++++-
 kernel/sched/debug.c           |    3 +
 kernel/sched/fair.c            |  501 ++++++++++++++++++++++++++++++++++++++--
 kernel/sched/features.h        |   10 +
 kernel/sched/sched.h           |   37 +++
 kernel/sysctl.c                |   13 +-
 mm/huge_memory.c               |  165 +++++++++-----
 mm/memory.c                    |  125 ++++++++++-
 mm/mempolicy.c                 |  296 ++++++++++++++++++------
 mm/migrate.c                   |   85 ++++++-
 mm/mprotect.c                  |   24 ++-
 mm/vmstat.c                    |    1 -
 25 files changed, 1257 insertions(+), 196 deletions(-)


