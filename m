Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172Ab1EOWVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:21:52 -0400
Received: from mout.perfora.net ([74.208.4.195]:57598 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761151Ab1EOWVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:21:39 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v2 3/9] mm: remove MPOL_MF_STATS
Date: Sun, 15 May 2011 18:20:23 -0400
Message-Id: <1305498029-11677-4-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305498029-11677-1-git-send-email-wilsons@start.ca>
References: <1305498029-11677-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:vNe0PD6EECs5j5TdMmm7lOsMPtT3/oGykl4wruJfnKo
 V+6jNHNGja9u4Roi5Ct32imliuJeMm1eUjbkhINQftGc/U4v5x
 AlwUreSSBz891ehuwQ8OabidLw95urgSO7v1yksIeNJGwUKT+h
 K0fY9PRmslEldrVa60tmUUiyEP6VYuzVXD+eVyr8HAlTBTVqQc
 2J0H1kUGEbnINgyVeO/JPsYjEMqvD9XowAvbjiGLQE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mapping statistics in a NUMA environment is now computed using the
generic walk_page_range() logic.  Remove the old/equivalent
functionality.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/mempolicy.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c894671..d43d05e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -100,7 +100,6 @@
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
 #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
-#define MPOL_MF_STATS (MPOL_MF_INTERNAL << 2)		/* Gather statistics */
 
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
@@ -493,9 +492,7 @@ static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
 			continue;
 
-		if (flags & MPOL_MF_STATS)
-			gather_stats(page, private, pte_dirty(*pte));
-		else if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 			migrate_page_add(page, private, flags);
 		else
 			break;
-- 
1.7.4.4

