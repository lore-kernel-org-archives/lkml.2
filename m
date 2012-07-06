Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2GFNrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:47:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GFNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:47:08 -0400
Date: Fri, 6 Jul 2012 06:46:24 -0700
From: tip-bot for Johannes Weiner <hannes@cmpxchg.org>
Message-ID: <tip-1d349dc80b3191fb654a04e3648e025258e80d46@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        efault@gmx.de, riel@redhat.com, aarcange@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, pjt@google.com,
        hannes@cmpxchg.org, paulmck@linux.vnet.ibm.com, bharata.rao@gmail.com,
        Lee.Schermerhorn@hp.com, danms@us.ibm.com
Reply-To: mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, efault@gmx.de, riel@redhat.com,
        aarcange@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        pjt@google.com, hannes@cmpxchg.org, paulmck@linux.vnet.ibm.com,
        bharata.rao@gmail.com, Lee.Schermerhorn@hp.com, danms@us.ibm.com
In-Reply-To: <20120706103255.GA23680@cmpxchg.org>
References: <20120706103255.GA23680@cmpxchg.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: Fix vmstat names-values off-by-one
Git-Commit-ID: 1d349dc80b3191fb654a04e3648e025258e80d46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 06:46:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d349dc80b3191fb654a04e3648e025258e80d46
Gitweb:     http://git.kernel.org/tip/1d349dc80b3191fb654a04e3648e025258e80d46
Author:     Johannes Weiner <hannes@cmpxchg.org>
AuthorDate: Fri, 6 Jul 2012 12:32:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 12:52:09 +0200

mm: Fix vmstat names-values off-by-one

Commit e975d6ac08f3 (""mm/mpol: Remove NUMA_INTERLEAVE_HIT") removed
the NUMA_INTERLEAVE_HIT item from the zone_stat_item enum, but left
the corresponding name string for it in the vmstat_text array.

As a result, all counters that follow it have their name offset
by one from their value.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Turner <pjt@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/20120706103255.GA23680@cmpxchg.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/vmstat.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..e4db312 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -717,7 +717,6 @@ const char * const vmstat_text[] = {
 	"numa_hit",
 	"numa_miss",
 	"numa_foreign",
-	"numa_interleave",
 	"numa_local",
 	"numa_other",
 #endif
