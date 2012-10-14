Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2JNOtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:49:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46763 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423Ab2JNOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:15 -0400
Message-Id: <20121014143538.966779793@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 038/147] block: fix request_queue->flags initialization
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.

A queue newly allocated with blk_alloc_queue_node() has only
QUEUE_FLAG_BYPASS set.  For request-based drivers,
blk_init_allocated_queue() is called and q->queue_flags is overwritten
with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
initial bypass is still in effect.

In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
instead of overwriting.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 80e29c9..a17869f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -696,7 +696,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->queue_flags		= QUEUE_FLAG_DEFAULT;
+	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)


