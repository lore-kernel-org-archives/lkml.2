Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1F2PKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:10:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:60439 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1F2PJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="21923346"
Message-Id: <20110629145554.034869356@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] writeback: show bdi write bandwidth in debugfs
References: <20110629145245.835998321@intel.com>
Content-Disposition: inline; filename=writeback-bandwidth-show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "BdiWriteBandwidth" entry and indent others in /debug/bdi/*/stats.

btw, increase digital field width to 10, for keeping the possibly
huge BdiWritten number aligned at least for desktop systems.

Impact: this could break user space tools if they are dumb enough to
depend on the number of white spaces.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- linux-next.orig/mm/backing-dev.c	2011-06-12 20:57:03.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-06-12 20:58:28.000000000 +0800
@@ -92,23 +92,25 @@ static int bdi_debug_stats_show(struct s
 
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
 		   K(bdi_thresh),
 		   K(dirty_thresh),
 		   K(background_thresh),
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
+		   (unsigned long) K(bdi->write_bandwidth),
 		   nr_dirty,
 		   nr_io,
 		   nr_more_io,


