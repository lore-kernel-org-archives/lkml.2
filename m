Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2LBQN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 11:13:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2LBQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 11:13:26 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 0/2] numa/core updates
Date: Sun,  2 Dec 2012 17:13:14 +0100
Message-Id: <1354464796-14343-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing wider workloads and here's two more small and
obvious patches rounding up numa/core behavior around the edges.

The NUMA code should now be pretty unintrusive to all but the
long-running, memory-intense workloads where it's expected to
make a (positive) difference.

Short-run workloads like kbuild or hackbench don't trigger the
NUMA code now. The limits can be reconsidered later on,
iteratively - the goal now is to not regress.

Thanks,

	Ingo

-------------->
Ingo Molnar (2):
  sched: Exclude pinned tasks from the NUMA-balancing logic
  sched: Add RSS filter to NUMA-balancing

 include/linux/sched.h   |  1 +
 kernel/sched/core.c     |  6 ++++++
 kernel/sched/debug.c    |  1 +
 kernel/sched/fair.c     | 53 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/features.h |  1 +
 kernel/sysctl.c         |  7 +++++++
 6 files changed, 65 insertions(+), 4 deletions(-)

-- 
1.7.11.7

