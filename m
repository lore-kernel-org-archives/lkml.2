Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab0HFFSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:18:16 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43319 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793Ab0HFFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:36 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 38/43] memblock: Improve debug output when resizing the reserve array
Date: Fri,  6 Aug 2010 15:15:19 +1000
Message-Id: <1281071724-28740-39-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Print out the location info in addition to which array is being
resized. Also use memblocK_dbg() to put that under control of
the memblock_debug flag.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 5499ab1..c3703ab 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -192,8 +192,6 @@ static int memblock_double_array(struct memblock_type *type)
 	if (!memblock_can_resize)
 		return -1;
 
-	pr_debug("memblock: %s array full, doubling...", memblock_type_name(type));
-
 	/* Calculate new doubled size */
 	old_size = type->max * sizeof(struct memblock_region);
 	new_size = old_size << 1;
@@ -221,6 +219,9 @@ static int memblock_double_array(struct memblock_type *type)
 	}
 	new_array = __va(addr);
 
+	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
+		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);
+
 	/* Found space, we now need to move the array over before
 	 * we add the reserved region since it may be our reserved
 	 * array itself that is full.
@@ -672,7 +673,7 @@ static void memblock_dump(struct memblock_type *region, char *name)
 		base = region->regions[i].base;
 		size = region->regions[i].size;
 
-		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
+		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes\n",
 		    name, i, base, base + size - 1, size);
 	}
 }
-- 
1.7.0.4

