Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab1DMJH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:07:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:43854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998Ab1DMJHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="908938843"
Message-Id: <20110413090415.389888354@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 16:59:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/4] writeback: add bdi_dirty_limit() kernel-doc
References: <20110413085937.981293444@intel.com>
Content-Disposition: inline; filename=writeback-task_dirty_limit-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify the bdi_dirty_limit() comment.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-03-03 14:38:12.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-03 14:40:52.000000000 +0800
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


