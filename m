Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab2JRVVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab2JRVVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:21:11 -0400
Date: Thu, 18 Oct 2012 17:19:28 -0400
From: Rik van Riel <riel@redhat.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, a.p.zijlstra@chello.nl
Subject: [PATCH 1/2] add credits for NUMA placement
Message-ID: <20121018171928.24d06af4@cuia.bos.redhat.com>
In-Reply-To: <20121018171821.7f1b1683@cuia.bos.redhat.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NUMA placement code has been rewritten several times, but
the basic ideas took a lot of work to develop. The people who
put in the work deserve credit for it. Thanks Andrea & Peter :)

The Documentation/scheduler/numa-problem.txt file should
probably be rewritten once we figure out the final details of
what the NUMA code needs to do, and why.

Signed-off-by: Rik van Riel <riel@redhat.com>

----
This is against tip.git numa/core

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
index 1e24aa1..e93032d 100644
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
index fc48fe8..9e56a44 100644
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
