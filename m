Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1BUTIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:08:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:24888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1BUTIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:08:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,201,1297065600"; 
   d="scan'208";a="605050283"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] Fix interleaving for transparent hugepages
Date: Mon, 21 Feb 2011 11:07:43 -0800
Message-Id: <1298315270-10434-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Bugfix, independent from the rest of the series.

The THP code didn't pass the correct interleaving shift to the memory
policy code. Fix this here by adjusting for the order.

Cc: aarcange@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 368fc9d..76c51b7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
+		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT << order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
 		put_mems_allowed();
-- 
1.7.4

