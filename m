Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2GBGd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:33:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:62463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2GBGdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:33:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187378145"
From: Feng Tang <feng.tang@intel.com>
To: penberg@kernel.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, sfr@canb.auug.org.au,
        linux-mm@kvack.org, Feng Tang <feng.tang@intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH] slab: Fix a tpyo in commit 8c138b "slab: Get rid of obj_size macro"
Date: Mon,  2 Jul 2012 14:29:10 +0800
Message-Id: <1341210550-11038-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit  8c138b only sits in Pekka's and linux-next tree now, which tries
to replace obj_size(cachep) with cachep->object_size, but has a typo in
kmem_cache_free() by using "size" instead of "object_size", which casues
some regressions.

Reported-and-tested-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Christoph Lameter <cl@linux.com>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 64c3d03..605b3b7 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3890,7 +3890,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	debug_check_no_locks_freed(objp, cachep->size);
+	debug_check_no_locks_freed(objp, cachep->object_size);
 	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(objp, cachep->object_size);
 	__cache_free(cachep, objp, __builtin_return_address(0));
-- 
1.7.10

