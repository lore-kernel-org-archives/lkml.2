Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1DMJH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:07:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:43854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994Ab1DMJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="908938847"
Message-Id: <20110413090415.763161169@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 16:59:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Jan Kara <jack@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
cc: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/4] writeback: reduce per-bdi dirty threshold ramp up time
References: <20110413085937.981293444@intel.com>
Content-Disposition: inline; filename=writeback-speedup-per-bdi-threshold-ramp-up.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the dampening for the control system, yielding faster
convergence. The change is a bit conservative, as smaller values may
lead to noticeable bdi threshold fluctuates in low memory JBOD setup.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2011-03-02 14:52:19.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-02 15:00:17.000000000 +0800
@@ -145,7 +145,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return ilog2(dirty_total - 1);
 }
 
 /*


