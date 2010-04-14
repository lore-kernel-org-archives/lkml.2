Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0DNPAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:00:40 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42627 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab0DNPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SOtIMb3G5lIFuddyEShZQpcQibHLHJOcpBJhaDixW8bUpIuwDXe9h7KC1OO1DrXnaq
         qfmoThl66rll9tS4Vbq5/myHirj8cm4U/K88/tta31KiIusCRuCD9TmqZ9TOs1na27eu
         dhDqWYuKOKPrHqoFfD3DYKhVrSyxZO5NH/i9c=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH v2] change alloc function in __vmalloc_area_node
Date: Wed, 14 Apr 2010 23:58:38 +0900
Message-Id: <1271257119-30117-5-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
References: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
* Add some reviewed-by

__vmalloc_area_node never pass -1 to alloc_pages_node.
It means node's validity check is unnecessary.
So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..7abf423 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1499,7 +1499,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		if (node < 0)
 			page = alloc_page(gfp_mask);
 		else
-			page = alloc_pages_node(node, gfp_mask, 0);
+			page = alloc_pages_exact_node(node, gfp_mask, 0);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
-- 
1.7.0.5

