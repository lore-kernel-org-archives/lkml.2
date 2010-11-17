Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab0KQEbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:31:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:17287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934136Ab0KQEba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:31:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="627558216"
Message-Id: <20101117042850.122583518@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 12:27:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/13] writeback: show bdi write bandwidth in debugfs
References: <20101117042720.033773013@intel.com>
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
 mm/backing-dev.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- linux-next.orig/mm/backing-dev.c	2010-11-15 12:52:34.000000000 +0800
+++ linux-next/mm/backing-dev.c	2010-11-15 12:52:44.000000000 +0800
@@ -87,21 +87,23 @@ static int bdi_debug_stats_show(struct s
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
-		   "BdiWriteback:     %8lu kB\n"
-		   "BdiReclaimable:   %8lu kB\n"
-		   "BdiDirtyThresh:   %8lu kB\n"
-		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n"
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
+		   "BdiWritten:         %10lu kB\n"
+		   "BdiWriteBandwidth:  %10lu kBps\n"
+		   "b_dirty:            %10lu\n"
+		   "b_io:               %10lu\n"
+		   "b_more_io:          %10lu\n"
+		   "bdi_list:           %10u\n"
+		   "state:              %10lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
+		   (unsigned long) bdi->write_bandwidth >> 10,
 		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K


