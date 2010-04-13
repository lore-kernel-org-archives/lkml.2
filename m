Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0DMP2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:28:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61006 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0DMP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tFmoHoTgebH965J61rYjNap5JiZWrEYcQj4laEgfzNmnDZvfuaAy7IaORA8xSAt94A
         Gvq5LvNcHIrui/VOQGgJH/e+jT4Vh3pIR/boIFsI4PvlkNJle41UDbJPBfOVIwpvuiD4
         HFuz8srhhm3IZCaZp6Xmo9vHC+8shdVExL0uo=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 5/6] change alloc function in __vmalloc_area_node
Date: Wed, 14 Apr 2010 00:25:02 +0900
Message-Id: <2cb77846a9523201588c5dbf94b23d6ea737ce65.1271171877.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
In-Reply-To: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc_area_node never pass -1 to alloc_pages_node.
It means node's validity check is unnecessary.
So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Nick Piggin <npiggin@suse.de>
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

