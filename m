Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1DSDKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:6529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1DSDKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911423207"
Message-Id: <20110419030532.902141228@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 6/6] NFS: return -EAGAIN when skipped commit in nfs_commit_unstable_pages()
References: <20110419030003.108796967@intel.com>
Content-Disposition: inline; filename=nfs-fix-write_inode-retval.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably not sane to return success while redirtying the inode at
the same time in ->write_inode().

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/nfs/write.c	2011-04-19 10:18:16.000000000 +0800
+++ linux-next/fs/nfs/write.c	2011-04-19 10:18:32.000000000 +0800
@@ -1519,7 +1519,7 @@ static int nfs_commit_unstable_pages(str
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int flags = FLUSH_SYNC;
-	int ret = 0;
+	int ret = -EAGAIN;
 
 	if (wbc->sync_mode == WB_SYNC_NONE) {
 		/* Don't commit yet if this is a non-blocking flush and there


