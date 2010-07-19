Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967201Ab0GSX7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:59:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64381 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761012Ab0GSX6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 29/49] memblock: Print new doubled array location info
Date: Mon, 19 Jul 2010 16:56:38 -0700
Message-Id: <1279583818-14249-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C44E68D.01E9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so will have more idea where it is,  use memblock_debug to controll it

-v2: use memblock_dbg instead of " if (memblock_debug) "

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c16d4c6..796ef8c 100644
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
@@ -646,7 +647,7 @@ static void memblock_dump(struct memblock_type *region, char *name)
 		base = region->regions[i].base;
 		size = region->regions[i].size;
 
-		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
+		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes\n",
 		    name, i, base, base + size - 1, size);
 	}
 }
-- 
1.6.4.2

