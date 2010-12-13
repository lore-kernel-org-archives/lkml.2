Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0LMGtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:49:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:5009 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab0LMGtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="360754642"
Message-Id: <20101213064839.406113721@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/47] writeback: use do_div in bw calculation
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-use-do_div.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
@@ -658,10 +658,10 @@ static void balance_dirty_pages(struct a
 		 */
 		bw = bdi->write_bandwidth;
 		bw = bw * (bdi_thresh - bdi_dirty);
-		bw = bw / (bdi_thresh / BDI_SOFT_DIRTY_LIMIT + 1);
+		do_div(bw, bdi_thresh / BDI_SOFT_DIRTY_LIMIT + 1);
 
 		bw = bw * (task_thresh - bdi_dirty);
-		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
+		do_div(bw, bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
 		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
 		pause = clamp_val(pause, 1, HZ/10);


