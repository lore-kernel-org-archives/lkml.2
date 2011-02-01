Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1BAIKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:10:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1BAIKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:10:21 -0500
Date: Tue, 1 Feb 2011 08:09:44 GMT
From: tip-bot for Javi Merino <cibervicho@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, cibervicho@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        cibervicho@gmail.com, mingo@elte.hu
In-Reply-To: <1296515496-8229-1-git-send-email-cibervicho@gmail.com>
References: <1296515496-8229-1-git-send-email-cibervicho@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, docs: Update schedstats documentation to version 15
Message-ID: <tip-1e1dbb259c79b38a542c1c4c00fd8dfe936b183b@git.kernel.org>
Git-Commit-ID: 1e1dbb259c79b38a542c1c4c00fd8dfe936b183b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Feb 2011 08:09:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e1dbb259c79b38a542c1c4c00fd8dfe936b183b
Gitweb:     http://git.kernel.org/tip/1e1dbb259c79b38a542c1c4c00fd8dfe936b183b
Author:     Javi Merino <cibervicho@gmail.com>
AuthorDate: Mon, 31 Jan 2011 23:11:36 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Feb 2011 09:07:13 +0100

sched, docs: Update schedstats documentation to version 15

Version 15 of schedstats was introduced in:

   67aa0f767af4: sched: remove unused fields from struct rq

and removed three unused counters in sched_yield(). Update
the documentation.

Signed-off-by: Javi Merino <cibervicho@gmail.com>
Cc: henrix@sapo.pt
Cc: rdunlap@xenotime.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1296515496-8229-1-git-send-email-cibervicho@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/scheduler/sched-stats.txt |   33 ++++++++++++++----------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 01e6940..1cd5d51 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -1,3 +1,7 @@
+Version 15 of schedstats dropped counters for some sched_yield:
+yld_exp_empty, yld_act_empty and yld_both_empty. Otherwise, it is
+identical to version 14.
+
 Version 14 of schedstats includes support for sched_domains, which hit the
 mainline kernel in 2.6.20 although it is identical to the stats from version
 12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
@@ -28,32 +32,25 @@ to write their own scripts, the fields are described here.
 
 CPU statistics
 --------------
-cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12
-
-NOTE: In the sched_yield() statistics, the active queue is considered empty
-    if it has only one process in it, since obviously the process calling
-    sched_yield() is that process.
+cpu<N> 1 2 3 4 5 6 7 8 9
 
-First four fields are sched_yield() statistics:
-     1) # of times both the active and the expired queue were empty
-     2) # of times just the active queue was empty
-     3) # of times just the expired queue was empty
-     4) # of times sched_yield() was called
+First field is a sched_yield() statistic:
+     1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     5) # of times we switched to the expired queue and reused it
-     6) # of times schedule() was called
-     7) # of times schedule() left the processor idle
+     2) # of times we switched to the expired queue and reused it
+     3) # of times schedule() was called
+     4) # of times schedule() left the processor idle
 
 Next two are try_to_wake_up() statistics:
-     8) # of times try_to_wake_up() was called
-     9) # of times try_to_wake_up() was called to wake up the local cpu
+     5) # of times try_to_wake_up() was called
+     6) # of times try_to_wake_up() was called to wake up the local cpu
 
 Next three are statistics describing scheduling latency:
-    10) sum of all time spent running by tasks on this processor (in jiffies)
-    11) sum of all time spent waiting to run by tasks on this processor (in
+     7) sum of all time spent running by tasks on this processor (in jiffies)
+     8) sum of all time spent waiting to run by tasks on this processor (in
         jiffies)
-    12) # of timeslices run on this cpu
+     9) # of timeslices run on this cpu
 
 
 Domain statistics
