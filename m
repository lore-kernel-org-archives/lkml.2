Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0LMG6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:58:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:4695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab0LMGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111642"
Message-Id: <20101213064838.908880749@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Li Shaohua <shaohua.li@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Rik van Riel <riel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/47] writeback: make-nr_to_write-a-per-file-limit fix
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-make-nr_to_write-a-per-file-limit-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

older gcc's are dumb:

fs/fs-writeback.c: In function 'writeback_single_inode':
fs/fs-writeback.c:334: warning: 'nr_to_write' may be used uninitialized in this function

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <201011180023.oAI0NXFl014362@imap1.linux-foundation.org>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2010-12-08 22:44:26.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-12-08 22:44:27.000000000 +0800
@@ -331,7 +331,7 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	long per_file_limit = wbc->per_file_limit;
-	long nr_to_write;
+	long uninitialized_var(nr_to_write);
 	unsigned dirty;
 	int ret;
 


