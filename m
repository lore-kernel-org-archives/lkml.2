Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1CCArr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:47:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:46961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1CCAqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="893189405"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] Fix interleaving for transparent hugepages v2
Date: Wed,  2 Mar 2011 16:45:21 -0800
Message-Id: <1299113128-11349-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
References: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Bugfix, independent from the rest of the series.

The THP code didn't pass the correct interleaving shift to the memory
policy code. Fix this here by adjusting for the order.

v2: Use + (thanks Christoph)
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 368fc9d..49355a9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
+		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
 		put_mems_allowed();
-- 
1.7.4

