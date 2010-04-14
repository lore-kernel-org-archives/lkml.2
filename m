Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0DNPAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:00:01 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38739 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0DNPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mugkGxrbK3KaJflRXe+tLppcWeaJEZHYb5tpGit5LLsefGfRclwIKy97Tg9C5mWFV6
         y2WfeYFZ9e8HPG6OkmeKj8Ln7QF0RVz8D3ivWHRdEC8rTutRg7/497jUjtb9mDnrJjcl
         QfuGeNMGYNOLz02zwzcWeG988Ni9MmK/ngyhI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v2] change alloc function in alloc_slab_page
Date: Wed, 14 Apr 2010 23:58:36 +0900
Message-Id: <1271257119-30117-3-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
References: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
* change changelog
* Add some reviewed-by 

alloc_slab_page always checks nid == -1, so alloc_page_node can't be
called with -1. 
It means node's validity check in alloc_pages_node is unnecessary. 
So we can use alloc_pages_exact_node instead of alloc_pages_node. 
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b364844..9984165 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1084,7 +1084,7 @@ static inline struct page *alloc_slab_page(gfp_t flags, int node,
 	if (node == -1)
 		return alloc_pages(flags, order);
 	else
-		return alloc_pages_node(node, flags, order);
+		return alloc_pages_exact_node(node, flags, order);
 }
 
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
-- 
1.7.0.5

