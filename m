Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102Ab1ESV6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:58:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:38412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935002Ab1ESVyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="4877264"
Message-Id: <20110519214745.660153803@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 May 2011 05:45:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/18] writeback: add bdi_dirty_limit() kernel-doc
References: <20110519214530.939830917@intel.com>
Content-Disposition: inline; filename=writeback-task_dirty_limit-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify the bdi_dirty_limit() comment.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-05-20 05:08:25.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-20 05:12:43.000000000 +0800
@@ -437,10 +437,17 @@ void global_dirty_limits(unsigned long *
 	*pdirty = dirty;
 }
 
-/*
+/**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
+ * @bdi: the backing_dev_info to query
+ * @dirty: global dirty limit in pages
+ *
+ * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
+ * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
+ * And the "limit" in the name is not seriously taken as hard limit in
+ * balance_dirty_pages().
  *
- * Allocate high/low dirty limits to fast/slow devices, in order to prevent
+ * It allocates high/low dirty limits to fast/slow devices, in order to prevent
  * - starving fast devices
  * - piling up dirty pages (that will take long time to sync) on slow devices
  *


