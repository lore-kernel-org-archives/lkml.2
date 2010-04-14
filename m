Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0DNPAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:00:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53841 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0DNPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xhuTZDl4BKsgjv0WPgSc6BdAETTXdCr41d7Few57DbC2gle6pmCvj3/CACi0L8eHj1
         g1n6NMvvza36CYpqqmG1FsrooNAQrnNSNN3Ppb2xQ2CcOEeagqxhHWdfsZH4f7oJrroM
         JcgpDVFSsECJeETVKVPzEU38+6FC1Ubrq88w4=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v2] change alloc function in vmemmap_alloc_block
Date: Wed, 14 Apr 2010 23:58:37 +0900
Message-Id: <1271257119-30117-4-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
References: <1271257119-30117-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
* Add some reviewed-by

if node_state is N_HIGH_MEMORY, node doesn't have -1.
It means node's validity check is unnecessary.
So we can use alloc_pages_exact_node instead of alloc_pages_node.
It could avoid comparison and branch as 6484eb3e2a81807722 tried.

Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/sparse-vmemmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 392b9bb..7710ebc 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -53,7 +53,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		struct page *page;
 
 		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(node,
+			page = alloc_pages_exact_node(node,
 				GFP_KERNEL | __GFP_ZERO, get_order(size));
 		else
 			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-- 
1.7.0.5

