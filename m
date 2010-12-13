Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0LMGw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:52:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:53133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0LMGtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523151"
Message-Id: <20101213064842.310150037@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 43/47] nfs: dont change wbc->nr_to_write in write_inode()
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-nfs-commit-remove-nr_to_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's introduced in commit 420e3646 ("NFS: Reduce the number of
unnecessary COMMIT calls") and seems not necessary.

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux-next.orig/fs/nfs/write.c	2010-12-09 12:20:20.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-09 12:20:30.000000000 +0800
@@ -1557,15 +1557,8 @@ static int nfs_commit_unstable_pages(str
 	}
 
 	ret = nfs_commit_inode(inode, flags);
-	if (ret >= 0) {
-		if (wbc->sync_mode == WB_SYNC_NONE) {
-			if (ret < wbc->nr_to_write)
-				wbc->nr_to_write -= ret;
-			else
-				wbc->nr_to_write = 0;
-		}
+	if (ret >= 0)
 		return 0;
-	}
 out_mark_dirty:
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	return ret;


