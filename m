Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936215Ab1KJD7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:59:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965922Ab1KJDrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.553458261@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [229/264] blk-flush: fix invalid BUG_ON in blk_insert_flush
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 834f9f61a525d2f6d3d0c93894e26326c8d3ceed upstream.

A user reported a regression due to commit
4853abaae7e4a2af938115ce9071ef8684fb7af4 (block: fix flush
machinery for stacking drivers with differring flush flags).
Part of the problem is that blk_insert_flush required a
single bio be attached to the request.  In reality, having
no attached bio is also a valid case, as can be observed with
an empty flush.

[1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html

Reported-by: Christophe Saout <christophe@saout.de>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-flush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -320,7 +320,7 @@ void blk_insert_flush(struct request *rq
 		return;
 	}
 
-	BUG_ON(!rq->bio || rq->bio != rq->biotail);
+	BUG_ON(rq->bio != rq->biotail); /*assumes zero or single bio rq */
 
 	/*
 	 * If there's data but flush is not necessary, the request can be


