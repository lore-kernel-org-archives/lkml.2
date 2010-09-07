Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0IGOeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:34:00 -0400
Received: from www.tglx.de ([62.245.132.106]:43898 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab0IGOdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:47 -0400
Message-Id: <20100907125056.607620827@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [patch 20/30] xfs: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=xfs-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -189,7 +189,7 @@ _xfs_buf_initialize(
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_hash_list);
-	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
+	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_file_offset = range_base;


