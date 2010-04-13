Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0DMPZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:25:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44602 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0DMPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tKiOKb6i9GLo9ZTq27RjpO7aC3dYqmm42fdVwsy8x+OO0siAosUwE6pJ0ZNdJ86dYZ
         XCQ3HZXlzxghQcvz+Z/eToLU9Y/HyywutF/SFPqD+tKC/Yo9dSTtTswZYhf/MiiWNr9q
         lWuLC8/sgP823XJwp+El1S3eHxlnCcPbVanXk=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 1/6] Remove node's validity check in alloc_pages
Date: Wed, 14 Apr 2010 00:24:58 +0900
Message-Id: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pages calls alloc_pages_node with numa_node_id().
alloc_pages_node can't see nid < 0.

So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

