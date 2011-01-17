Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1AQDjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 22:39:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36617 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1AQDji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 22:39:38 -0500
Date: Sun, 16 Jan 2011 20:39:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] Move some REQ flags to bio area
Message-ID: <20110117033936.GD6262@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


REQ_SECURE, REQ_FLUSH and REQ_FUA may all be set on a bio as well as 
on a request, so relocate them to the shared part of the enum.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46ad519..c10bdc3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -125,7 +125,11 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+	__REQ_FUA,		/* forced unit access */
+	__REQ_FLUSH,		/* request for cache flush */
 
 	/* bio only flags */
 	__REQ_UNPLUG,		/* unplug the immediately after submission */
@@ -136,7 +140,6 @@ enum rq_flag_bits {
 	/* request only flags */
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
-	__REQ_FUA,		/* forced unit access */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
 	__REQ_DONTPREP,		/* don't call prep for this one */
@@ -147,10 +150,8 @@ enum rq_flag_bits {
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
-	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
-	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_NR_BITS,		/* stops here */
 };
 

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
