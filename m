Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2HXOei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:34:38 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:35881 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2HXOee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:34:34 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/5] mm/memblock: rename get_allocated_memblock_reserved_regions_info()
Date: Fri, 24 Aug 2012 22:33:37 +0800
Message-Id: <1345818820-12102-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082414-6102-0000-0000-0000021D5C79
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

