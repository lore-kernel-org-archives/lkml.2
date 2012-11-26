Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2KZRBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2KZRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 031/270] block: fix request_queue->flags initialization
Date: Mon, 26 Nov 2012 14:55:21 -0200
Message-Id: <1353949160-26803-32-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96335a7..e17ce4b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -686,7 +686,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->queue_flags		= QUEUE_FLAG_DEFAULT;
+	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)
-- 
1.7.9.5

