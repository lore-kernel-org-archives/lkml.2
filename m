Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1EXFZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:25:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:22560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1EXFVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="3755222"
Message-Id: <20110524051859.591227629@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/18] writeback: add bdi_dirty_limit() kernel-doc
References: <20110524051411.924582719@intel.com>
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

--- linux-next.orig/mm/page-writeback.c	2011-05-24 11:17:14.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-24 11:17:23.000000000 +0800
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


