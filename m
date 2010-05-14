Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab0ENTs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:48:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab0ENTsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:48:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/37] lmb: Export LMB_ERROR again
Date: Fri, 14 May 2010 12:45:30 -0700
Message-Id: <1273866363-14249-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BEDA8D5.0093,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will used by x86 lmb_find_area_node and nobootmem replacement

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 lib/lmb.c           |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index d88c92d..d959d23 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -19,6 +19,7 @@
 #include <asm/lmb.h>
 
 #define INIT_LMB_REGIONS 128
+#define LMB_ERROR	(~(phys_addr_t)0)
 
 struct lmb_region {
 	phys_addr_t base;
diff --git a/lib/lmb.c b/lib/lmb.c
index 2bdbe87..3caf58c 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -26,8 +26,6 @@ int lmb_debug;
 static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1];
 struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
 
-#define LMB_ERROR	(~(phys_addr_t)0)
-
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *lmb_type_name(struct lmb_type *type)
 {
-- 
1.6.4.2

