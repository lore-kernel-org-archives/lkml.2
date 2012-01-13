Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2AMLuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:50:08 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34705 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2AMLuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:50:05 -0500
Message-ID: <4F1019B0.5080503@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 19:46:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] mm: do not reset cached_hole_size when vma is unmapped
References: <4F101904.8090405@linux.vnet.ibm.com>
In-Reply-To: <4F101904.8090405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-1396-0000-0000-000000872B81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, cached_hole_size is set to the maximal value if the unmapped
vma is under free_area_cache, next search will search from the base addr

Actually, we can keep cached_hole_size so that if next required size is more
that cached_hole_size, it can search from free_area_cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/mmap.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3f758c7..970f572 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1423,10 +1423,8 @@ void arch_unmap_area(struct mm_struct *mm, unsigned long addr)
 	/*
 	 * Is this a new hole at the lowest possible address?
 	 */
-	if (addr >= TASK_UNMAPPED_BASE && addr < mm->free_area_cache) {
+	if (addr >= TASK_UNMAPPED_BASE && addr < mm->free_area_cache)
 		mm->free_area_cache = addr;
-		mm->cached_hole_size = ~0UL;
-	}
 }

 /*
-- 
1.7.7.5

