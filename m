Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab1KMSz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:55:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56432 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab1KMSzZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:55:25 -0500
Message-ID: <1321210507.18929.293.camel@deadeye>
Subject: [PATCH] block: Always check length of all iov entries in
 blk_rq_map_user_iov()
From: Ben Hutchings <ben@decadent.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xiaotian Feng <dfeng@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 13 Nov 2011 18:55:07 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even after commit 5478755616ae2ef1ce144dded589b62b2a50d575
("block: check for proper length of iov entries earlier ...")
we still won't check for zero-length entries after an unaligned
entry.  Remove the break-statement, so all entries are checked.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 block/blk-map.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index e663ac2..2e852a4 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -204,10 +204,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 		if (!iov[i].iov_len)
 			return -EINVAL;
 
-		if (uaddr & queue_dma_alignment(q)) {
+		if (uaddr & queue_dma_alignment(q))
 			unaligned = 1;
-			break;
-		}
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
-- 
1.7.7.2


