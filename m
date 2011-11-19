Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1KSALT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:11:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab1KSAKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:30 2011
Message-Id: <20111119000330.232673035@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:03:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [26/26] block: Always check length of all iov entries in blk_rq_map_user_iov()
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6b76106d8ef31111d6fc469564b83b5f5542794f upstream.

Even after commit 5478755616ae2ef1ce144dded589b62b2a50d575
("block: check for proper length of iov entries earlier ...")
we still won't check for zero-length entries after an unaligned
entry.  Remove the break-statement, so all entries are checked.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-map.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -204,10 +204,11 @@ int blk_rq_map_user_iov(struct request_q
 		if (!iov[i].iov_len)
 			return -EINVAL;
 
-		if (uaddr & queue_dma_alignment(q)) {
+		/*
+		 * Keep going so we check length of all segments
+		 */
+		if (uaddr & queue_dma_alignment(q))
 			unaligned = 1;
-			break;
-		}
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)


