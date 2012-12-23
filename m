Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2LWUQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:16:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42637 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2LWUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:16:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm, sparse: don't check return value of alloc_bootmem calls
Date: Sun, 23 Dec 2012 15:15:08 -0500
Message-Id: <1356293711-23864-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to check the result of alloc_bootmem() functions since
they'll panic if allocation fails.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/sparse.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 72a0db6..949fb38 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -497,8 +497,6 @@ void __init sparse_init(void)
 	 */
 	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
 	usemap_map = alloc_bootmem(size);
-	if (!usemap_map)
-		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		struct mem_section *ms;
@@ -538,8 +536,6 @@ void __init sparse_init(void)
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
 	map_map = alloc_bootmem(size2);
-	if (!map_map)
-		panic("can not allocate map_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		struct mem_section *ms;
-- 
1.8.0

