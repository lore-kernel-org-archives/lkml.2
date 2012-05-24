Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2EXHpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:45:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4638 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2EXHpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:45:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6720"; a="194205770"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] memblock: Document memblock_is_region_{memory,reserved}()
Date: Thu, 24 May 2012 00:45:21 -0700
Message-Id: <1337845521-32755-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.2.552.gaa3bb87
In-Reply-To: <20120515151509.GC6119@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first glance one would think that memblock_is_region_memory()
and memblock_is_region_reserved() would be implemented in the
same way. Unfortunately they aren't and the former returns
whether the region specified is a subset of a memory bank while
the latter returns whether the region specified intersects with
reserved memory.

Document the two functions so that users aren't tempted to
make the implementation the same between them and to clarify the
purpose of the functions.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 mm/memblock.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index a44eab3..e35e39b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -855,6 +855,16 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+/**
+ * memblock_is_region_memory - check if a region is a subset of memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) is a subset of a memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
@@ -867,6 +877,16 @@ int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size
 		 memblock.memory.regions[idx].size) >= end;
 }
 
+/**
+ * memblock_is_region_reserved - check if a region intersects reserved memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) intersects a reserved memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
 	memblock_cap_size(base, &size);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

