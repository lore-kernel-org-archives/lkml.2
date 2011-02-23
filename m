Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1BWBke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:40:34 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39502 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab1BWBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/11] rcu: Update documentation to reflect blocked_tasks[] merge
Date: Tue, 22 Feb 2011 17:39:39 -0800
Message-Id: <1298425183-21265-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index e731ad2..5a704ff 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -166,14 +166,14 @@ o	"gpnum" is the number of grace periods that have started.  It is
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
 c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
-1/1 .>. 0:127 ^0    
-3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
+1/1 ..>. 0:127 ^0
+3/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+3/3f ..>. 0:5 ^0    2/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 rcu_bh:
 c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
-0/1 .>. 0:127 ^0    
-0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
+0/1 ..>. 0:127 ^0
+0/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+0/3f ..>. 0:5 ^0    0/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 
 This is once again split into "rcu_sched" and "rcu_bh" portions,
 and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
@@ -232,13 +232,20 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		current grace period.
 
 	o	The characters separated by the ">" indicate the state
-		of the blocked-tasks lists.  A "T" preceding the ">"
+		of the blocked-tasks lists.  A "G" preceding the ">"
 		indicates that at least one task blocked in an RCU
 		read-side critical section blocks the current grace
-		period, while a "." preceding the ">" indicates otherwise.
-		The character following the ">" indicates similarly for
-		the next grace period.  A "T" should appear in this
-		field only for rcu-preempt.
+		period, while a "E" preceding the ">" indicates that
+		at least one task blocked in an RCU read-side critical
+		section blocks the current expedited grace period.
+		A "T" character following the ">" indicates that at
+		least one task is blocked within an RCU read-side
+		critical section, regardless of whether any current
+		grace period (expedited or normal) is inconvenienced.
+		A "." character appears if the corresponding condition
+		does not hold, so that "..>." indicates that no tasks
+		are blocked.  In contrast, "GE>T" indicates maximal
+		inconvenience from blocked tasks.
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
-- 
1.7.3.2

