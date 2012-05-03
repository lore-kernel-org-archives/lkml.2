Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab2ECRPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:15:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab2ECRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:15:50 -0400
From: rajman mekaco <rajman.mekaco@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rajman mekaco <rajman.mekaco@gmail.com>
Subject: [PATCH 1/1] page_alloc.c: remove argument to pageblock_default_order
Date: Thu,  3 May 2012 22:45:12 +0530
Message-Id: <1336065312-2891-1-git-send-email-rajman.mekaco@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not defined, then
pageblock_default_order has an argument to it.

However, free_area_init_core will call it without any argument
anyway.

Remove the argument to pageblock_default_order when
CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not defined.

Signed-off-by: rajman mekaco <rajman.mekaco@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a712fb9..4b95412 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4274,7 +4274,7 @@ static inline void __init set_pageblock_order(unsigned int order)
  * at compile-time. See include/linux/pageblock-flags.h for the values of
  * pageblock_order based on the kernel config
  */
-static inline int pageblock_default_order(unsigned int order)
+static inline int pageblock_default_order(void)
 {
 	return MAX_ORDER-1;
 }
-- 
1.7.5.4

