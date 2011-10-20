Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1JTPil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:38:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:27426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab1JTPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588855"
Message-Id: <20111020153706.265653153@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] writeback: requeue_io_wait() on pages_skipped inode
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=writeback-more_io_wait-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use requeue_io_wait() if some pages were skipped due to locked buffers.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:42:24.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-20 22:42:25.000000000 +0800
@@ -618,11 +618,11 @@ static long writeback_sb_inodes(struct s
 		if (wbc.pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode, wb);
+			requeue_io_wait(inode, wb);
 		}
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
 		iput(inode);
 		cond_resched();


