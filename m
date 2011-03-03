Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1CCUCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:02:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:5720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758495Ab1CCUAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:00:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,259,1297065600"; 
   d="scan'208";a="893504098"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/8] Add alloc_page_vma_node
Date: Thu,  3 Mar 2011 11:59:46 -0800
Message-Id: <1299182391-6061-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299182391-6061-1-git-send-email-andi@firstfloor.org>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a alloc_page_vma_node that allows passing the "local" node in.
Used in a followon patch.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/gfp.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 782e74a..814d50e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -343,6 +343,8 @@ extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
+#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
+	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
-- 
1.7.4

