Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0GDHAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:00:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63428 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0GDHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:00:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/23] lmb: Export LMB_ERROR again
Date: Sat,  3 Jul 2010 23:56:08 -0700
Message-Id: <1278226587-31213-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
References: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C303143.00AF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will used by x86 lmb_x86_find_in_range_node and nobootmem replacement

-v2: use 0 instead -1ULL, Suggesed by Linus, so we don't need cast them later to unsigned long

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 lib/lmb.c           |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 5124fca..1a0ba7a 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -19,6 +19,7 @@
 #include <asm/lmb.h>
 
 #define INIT_LMB_REGIONS 128
+#define LMB_ERROR	 0
 
 struct lmb_region {
 	phys_addr_t base;
diff --git a/lib/lmb.c b/lib/lmb.c
index dde8d04..7f89468 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -27,8 +27,6 @@ int lmb_can_resize;
 static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1];
 struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
 
-#define LMB_ERROR	(~(phys_addr_t)0)
-
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *lmb_type_name(struct lmb_type *type)
 {
-- 
1.6.4.2

