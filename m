Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0GDHCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:02:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64038 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0GDHCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:02:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/23] lmb: Print new doubled array location info
Date: Sat,  3 Jul 2010 23:56:07 -0700
Message-Id: <1278226587-31213-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
References: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C30319B.00BD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so will have more idea where it is,  use lmb_debug to controll it

-v2: use lmb_dbg instead of " if (lmb_debug) "

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 lib/lmb.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index bbdb1ec..dde8d04 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -192,8 +192,6 @@ static int lmb_double_array(struct lmb_type *type)
 	if (!lmb_can_resize)
 		return -1;
 
-	pr_debug("lmb: %s array full, doubling...", lmb_type_name(type));
-
 	/* Calculate new doubled size */
 	old_size = type->max * sizeof(struct lmb_region);
 	new_size = old_size << 1;
@@ -221,6 +219,9 @@ static int lmb_double_array(struct lmb_type *type)
 	}
 	new_array = __va(addr);
 
+	lmb_dbg("lmb: %s array is doubled to %ld at [%#010llx - %#010llx]",
+		 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
+
 	/* Found space, we now need to move the array over before
 	 * we add the reserved region since it may be our reserved
 	 * array itself that is full.
@@ -637,8 +638,8 @@ static void lmb_dump(struct lmb_type *region, char *name)
 		base = region->regions[i].base;
 		size = region->regions[i].size;
 
-		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
-		    name, i, base, base + size - 1, size);
+		pr_info(" %s[%#x]\t[%#016llx - %#016llx], %#llx bytes\n",
+		    name, i, base, base + size, size);
 	}
 }
 
-- 
1.6.4.2

