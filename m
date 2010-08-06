Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363Ab0HFFX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:23:56 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50349 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 17/43] memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
Date: Fri,  6 Aug 2010 15:14:58 +1000
Message-Id: <1281071724-28740-18-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 include/linux/memblock.h        |    1 +
 mm/memblock.c                   |    2 --
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 4072b87..a542ff5 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -625,7 +625,7 @@ static void __init htab_initialize(void)
 		if (machine_is(cell))
 			limit = 0x80000000;
 		else
-			limit = 0;
+			limit = MEMBLOCK_ALLOC_ANYWHERE;
 
 		table = memblock_alloc_base(htab_size_bytes, htab_size_bytes, limit);
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 367dea6..3cf3304 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -50,6 +50,7 @@ extern u64 __init memblock_alloc_nid(u64 size, u64 align, int nid);
 extern u64 __init memblock_alloc(u64 size, u64 align);
 extern u64 __init memblock_alloc_base(u64 size,
 		u64, u64 max_addr);
+#define MEMBLOCK_ALLOC_ANYWHERE	0
 extern u64 __init __memblock_alloc_base(u64 size,
 		u64 align, u64 max_addr);
 extern u64 __init memblock_phys_mem_size(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index e264e8c..0131684 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -15,8 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/memblock.h>
 
-#define MEMBLOCK_ALLOC_ANYWHERE	0
-
 struct memblock memblock;
 
 static int memblock_debug;
-- 
1.7.0.4

