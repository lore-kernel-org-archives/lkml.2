Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2HZJAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:00:51 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50286 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2HZJAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:00:49 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] mm/memblock: rename get_allocated_memblock_reserved_regions_info()
Date: Sun, 26 Aug 2012 17:00:24 +0800
Message-Id: <1345971626-17090-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345971626-17090-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345971626-17090-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082609-5564-0000-0000-000004307DEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Rename get_allocated_memblock_reserved_regions_info() to
memblock_reserved_regions_info() so that the function name
looks more short and has prefix "memblock".

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/memblock.h |    2 +-
 mm/memblock.c            |    2 +-
 mm/nobootmem.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 569d67d..ab7b887 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -50,7 +50,7 @@ phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
-phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
+phys_addr_t memblock_reserved_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index c1fbb12..2feff8d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -160,7 +160,7 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
 	}
 }
 
-phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
+phys_addr_t __init_memblock memblock_reserved_regions_info(
 					phys_addr_t *addr)
 {
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index bd82f6b..7e95953 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -130,7 +130,7 @@ unsigned long __init free_low_memory_core_early(int nodeid)
 		count += __free_memory_core(start, end);
 
 	/* free range that is used for reserved array if we allocate it */
-	size = get_allocated_memblock_reserved_regions_info(&start);
+	size = memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
-- 
1.7.5.4

