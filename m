Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0ERSgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:36:17 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58497 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0ERSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:36:16 -0400
Date: Tue, 18 May 2010 11:36:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@efficios.com
Subject: [PATCH] block: remove all rcu head initializations
Message-ID: <20100518183603.GA6238@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens,

Would you like to carry this patch, or should I push it up -tip?  If I
don't hear otherwise from you, I will push it up -tip.  The
INIT_RCU_HEAD() primitive is going away in favor of debugobjects.

							Thanx, Paul

------------------------------------------------------------------------

block: remove all rcu head initializations

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>

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
