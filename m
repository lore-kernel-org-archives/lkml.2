Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0DNO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:59:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59977 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab0DNO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vshy+Haa97ETVYp8IccUvt872rH2wsUYXknjDp7qTq5mJt35q5MmvQwwoevORnIQT3
         FeVp2q7wZrBXlDU/rZHzd0Dtx+2d98qr/pSXOE1JbRpKIgt07q7l7VNI83vxk7+imi4i
         WLaY8n7nzeI7W839J1VLiAe1hfvCzAMZiQpCs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2] Remove node's validity check in alloc_pages
Date: Wed, 14 Apr 2010 23:58:34 +0900
Message-Id: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
 * Add some reviewed-by

alloc_pages calls alloc_pages_node with numa_node_id().
alloc_pages_node can't see nid < 0.

So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/gfp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4c6d413..b65f003 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -308,7 +308,7 @@ extern struct page *alloc_page_vma(gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr);
 #else
 #define alloc_pages(gfp_mask, order) \
-		alloc_pages_node(numa_node_id(), gfp_mask, order)
+		alloc_pages_exact_node(numa_node_id(), gfp_mask, order)
 #define alloc_page_vma(gfp_mask, vma, addr) alloc_pages(gfp_mask, 0)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
-- 
1.7.0.5

