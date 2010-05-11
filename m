Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0EKXdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:33:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41155 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0EKXdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH RFC tip/core/rcu 05/11] block: remove all rcu head initializations
Date: Tue, 11 May 2010 16:33:00 -0700
Message-Id: <1273620786-20392-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    1 -
 block/genhd.c       |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5f127cf..702d006 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3743,7 +3743,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..27e85a2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -987,7 +987,6 @@ int disk_expand_part_tbl(struct gendisk *disk, int partno)
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
-- 
1.7.0.6

