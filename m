Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2LWUQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:16:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2LWUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:16:40 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm, sparse: allocate bootmem without panicing in sparse_mem_maps_populate_node
Date: Sun, 23 Dec 2012 15:15:06 -0500
Message-Id: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_bootmem_node_high() would panic if it failed allocating, so the fallback
would never get reached. Switch to using __alloc_bootmem_node_high_nopanic().

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/sparse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 6b5fb76..72a0db6 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -401,7 +401,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 	}
 
 	size = PAGE_ALIGN(size);
-	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
+	map = __alloc_bootmem_node_high_nopanic(NODE_DATA(nodeid), size * map_count,
 					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
-- 
1.8.0

