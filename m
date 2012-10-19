Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2JSCrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:51233 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab2JSCrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 24/62] block: fix request_queue->flags initialization
Date: Thu, 18 Oct 2012 19:44:52 -0700
Message-Id: <20121019024259.865881073@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -601,7 +601,7 @@ blk_init_allocated_queue(struct request_
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->queue_flags		= QUEUE_FLAG_DEFAULT;
+	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)


