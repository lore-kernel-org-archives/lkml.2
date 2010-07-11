Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0GKCiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:38:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:41016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0GKCiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,182,1278313200"; 
   d="scan'208";a="816867797"
Message-Id: <20100711021748.594522648@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 11 Jul 2010 10:06:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: <linux-fsdevel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] writeback: take account of NR_WRITEBACK_TEMP in balance_dirty_pages()
References: <20100711020656.340075560@intel.com>
Content-Disposition: inline; filename=writeback-temp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-07-11 08:41:37.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-07-11 08:42:14.000000000 +0800
@@ -503,11 +503,12 @@ static void balance_dirty_pages(struct a
 		};
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
-				&bdi_thresh, bdi);
+				 &bdi_thresh, bdi);
 
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+				 global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK) +
+			       global_page_state(NR_WRITEBACK_TEMP);
 
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);


