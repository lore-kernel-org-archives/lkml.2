Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1CCIXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:23:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:40252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1CCIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="715563061"
Message-Id: <20110303074951.442429447@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/27] writeback: show bdi write bandwidth in debugfs
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-bandwidth-show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "BdiWriteBandwidth" entry (and indent others) in /debug/bdi/*/stats.

btw increase digital field width to 10, for keeping the possibly
huge BdiWritten number aligned at least for desktop systems.

This will break user space tools if they are dumb enough to depend on
the number of white spaces.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- linux-next.orig/mm/backing-dev.c	2011-03-02 17:40:05.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-03-02 17:40:41.000000000 +0800
@@ -87,24 +87,30 @@ static int bdi_debug_stats_show(struct s
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
-		   "BdiWriteback:     %8lu kB\n"
-		   "BdiReclaimable:   %8lu kB\n"
-		   "BdiDirtyThresh:   %8lu kB\n"
-		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n"
-		   "BdiDirtied:       %8lu kB\n"
-		   "BdiWritten:       %8lu kB\n"
-		   "b_dirty:          %8lu\n"
-		   "b_io:             %8lu\n"
-		   "b_more_io:        %8lu\n"
-		   "bdi_list:         %8u\n"
-		   "state:            %8lx\n",
+		   "BdiWriteback:       %10lu kB\n"
+		   "BdiReclaimable:     %10lu kB\n"
+		   "BdiDirtyThresh:     %10lu kB\n"
+		   "DirtyThresh:        %10lu kB\n"
+		   "BackgroundThresh:   %10lu kB\n"
+		   "BdiDirtied:         %10lu kB\n"
+		   "BdiWritten:         %10lu kB\n"
+		   "BdiWriteBandwidth:  %10lu kBps\n"
+		   "b_dirty:            %10lu\n"
+		   "b_io:               %10lu\n"
+		   "b_more_io:          %10lu\n"
+		   "bdi_list:           %10u\n"
+		   "state:              %10lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
+		   K(bdi_thresh),
+		   K(dirty_thresh),
+		   K(background_thresh),
 		   (unsigned long) K(bdi_stat(bdi, BDI_DIRTIED)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
-		   nr_dirty, nr_io, nr_more_io,
+		   (unsigned long) K(bdi->write_bandwidth),
+		   nr_dirty,
+		   nr_io,
+		   nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 


