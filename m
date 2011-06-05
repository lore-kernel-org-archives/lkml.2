Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1FEQbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:31:09 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59486 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1FEQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:31:08 -0400
Subject: [PATCH 4/5] block: rename the return of two functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Date: Sun, 05 Jun 2011 18:26:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307291197.8545.45.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we rename the return of alloc_io_context() and get_io_context() from
"ret" to "ioc" the code get's (a bit) more readable and (a lot) more
grepable.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/blk-ioc.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 998fa67..79c543f 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -82,23 +82,23 @@ void exit_io_context(struct task_struct *task)
 
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 {
-	struct io_context *ret;
+	struct io_context *ioc;
 
-	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
-	if (ret) {
-		atomic_long_set(&ret->refcount, 1);
-		atomic_set(&ret->nr_tasks, 1);
-		spin_lock_init(&ret->lock);
-		ret->ioprio_changed = 0;
-		ret->ioprio = 0;
-		ret->last_waited = 0; /* doesn't matter... */
-		ret->nr_batch_requests = 0; /* because this is 0 */
-		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
-		INIT_HLIST_HEAD(&ret->cic_hlist);
-		ret->last_cic = NULL;
+	ioc = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
+	if (ioc) {
+		atomic_long_set(&ioc->refcount, 1);
+		atomic_set(&ioc->nr_tasks, 1);
+		spin_lock_init(&ioc->lock);
+		ioc->ioprio_changed = 0;
+		ioc->ioprio = 0;
+		ioc->last_waited = 0; /* doesn't matter... */
+		ioc->nr_batch_requests = 0; /* because this is 0 */
+		INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
+		INIT_HLIST_HEAD(&ioc->cic_hlist);
+		ioc->last_cic = NULL;
 	}
 
-	return ret;
+	return ioc;
 }
 
 /*
@@ -136,19 +136,19 @@ struct io_context *current_io_context(gfp_t gfp_flags, int node)
  */
 struct io_context *get_io_context(gfp_t gfp_flags, int node)
 {
-	struct io_context *ret = NULL;
+	struct io_context *ioc = NULL;
 
 	/*
 	 * Check for unlikely race with exiting task. ioc ref count is
 	 * zero when ioc is being detached.
 	 */
 	do {
-		ret = current_io_context(gfp_flags, node);
-		if (unlikely(!ret))
+		ioc = current_io_context(gfp_flags, node);
+		if (unlikely(!ioc))
 			break;
-	} while (!atomic_long_inc_not_zero(&ret->refcount));
+	} while (!atomic_long_inc_not_zero(&ioc->refcount));
 
-	return ret;
+	return ioc;
 }
 EXPORT_SYMBOL(get_io_context);
 
-- 
1.7.5.2




