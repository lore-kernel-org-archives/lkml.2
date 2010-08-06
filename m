Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab0HFFRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:17:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33777 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab0HFFPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:37 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 43/43] memblock: Add memblock_find_in_range()
Date: Fri,  6 Aug 2010 15:15:24 +1000
Message-Id: <1281071724-28740-44-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

This is a wrapper for memblock_find_base() using slightly different
arguments (start,end instead of start,size for example) in order to
make it easier to convert existing arch/x86 code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 3978e6a..4df09bd 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -47,6 +47,8 @@ extern int memblock_can_resize;
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
+u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+
 extern void __init memblock_init(void);
 extern void __init memblock_analyze(void);
 extern long memblock_add(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index a17faea..b7ab10a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -162,6 +162,14 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
 	return MEMBLOCK_ERROR;
 }
 
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+{
+	return memblock_find_base(size, align, start, end);
+}
+
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
 	unsigned long i;
-- 
1.7.0.4

