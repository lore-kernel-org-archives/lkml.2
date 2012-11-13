Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2KMPcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:32:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2KMPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:32:20 -0500
Date: Tue, 13 Nov 2012 07:31:44 -0800
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-0c4a966d7968363c833e58068da58a121095b075@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20121018171928.24d06af4@cuia.bos.redhat.com>
References: <20121018171928.24d06af4@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm: Add credits for NUMA placement
Git-Commit-ID: 0c4a966d7968363c833e58068da58a121095b075
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 07:31:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c4a966d7968363c833e58068da58a121095b075
Gitweb:     http://git.kernel.org/tip/0c4a966d7968363c833e58068da58a121095b075
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 18 Oct 2012 17:19:28 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 13 Nov 2012 14:11:50 +0100

sched, numa, mm: Add credits for NUMA placement

The NUMA placement code has been rewritten several times, but
the basic ideas took a lot of work to develop. The people who
put in the work deserve credit for it. Thanks Andrea & Peter :)

[ The Documentation/scheduler/numa-problem.txt file should
  probably be rewritten once we figure out the final details of
  what the NUMA code needs to do, and why. ]

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20121018171928.24d06af4@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
----
This is against tip.git numa/core
---
 CREDITS             |    1 +
 kernel/sched/fair.c |    3 +++
 mm/memory.c         |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/CREDITS b/CREDITS
index d8fe12a..b4cdc8f 100644
--- a/CREDITS
+++ b/CREDITS
@@ -125,6 +125,7 @@ D: Author of pscan that helps to fix lp/parport bugs
 D: Author of lil (Linux Interrupt Latency benchmark)
 D: Fixed the shm swap deallocation at swapoff time (try_to_unuse message)
 D: VM hacker
+D: NUMA task placement
 D: Various other kernel hacks
 S: Imola 40026
 S: Italy
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 93f4de4..309a254 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -18,6 +18,9 @@
  *
  *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ *  NUMA placement, statistics and algorithm by Andrea Arcangeli,
+ *  CFS balancing changes by Peter Zijlstra. Copyright (C) 2012 Red Hat, Inc.
  */
 
 #include <linux/latencytop.h>
diff --git a/mm/memory.c b/mm/memory.c
index 1b9108c..ebd18fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -36,6 +36,8 @@
  *		(Gerhard.Wichert@pdb.siemens.de)
  *
  * Aug/Sep 2004 Changed to four level page tables (Andi Kleen)
+ *
+ * 2012 - NUMA placement page faults (Andrea Arcangeli, Peter Zijlstra)
  */
 
 #include <linux/kernel_stat.h>
