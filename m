Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0EUAhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 20:37:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50903 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0EUAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 20:37:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
Cc: kosaki.motohiro@jp.fujitsu.com, "Li, Shaohua" <shaohua.li@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100520010032.GC4089@localhost>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com> <20100520010032.GC4089@localhost>
Message-Id: <20100521093629.1E44.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 21 May 2010 09:36:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> The preceding comment "they need to go on the active_anon lru below"
> also needs update.
> 

Thanks. incremental patch is here.


---
 include/linux/swap.h |   10 ----------
 mm/filemap.c         |    2 +-
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 18420a9..4bfd932 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,21 +224,11 @@ static inline void lru_cache_add_anon(struct page *page)
 	__lru_cache_add(page, LRU_INACTIVE_ANON);
 }
 
-static inline void lru_cache_add_active_anon(struct page *page)
-{
-	__lru_cache_add(page, LRU_ACTIVE_ANON);
-}
-
 static inline void lru_cache_add_file(struct page *page)
 {
 	__lru_cache_add(page, LRU_INACTIVE_FILE);
 }
 
-static inline void lru_cache_add_active_file(struct page *page)
-{
-	__lru_cache_add(page, LRU_ACTIVE_FILE);
-}
-
 /* LRU Isolation modes. */
 #define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
 #define ISOLATE_ACTIVE 1	/* Isolate active pages. */
diff --git a/mm/filemap.c b/mm/filemap.c
index 023ef61..a57931a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -441,7 +441,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 	/*
 	 * Splice_read and readahead add shmem/tmpfs pages into the page cache
 	 * before shmem_readpage has a chance to mark them as SwapBacked: they
-	 * need to go on the active_anon lru below, and mem_cgroup_cache_charge
+	 * need to go on the anon lru below, and mem_cgroup_cache_charge
 	 * (called in add_to_page_cache) needs to know where they're going too.
 	 */
 	if (mapping_cap_swap_backed(mapping))
-- 
1.6.5.2





