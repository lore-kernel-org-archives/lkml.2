Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BFKtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:49:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35628 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BFKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZFWCJRu6TRSVY69odYfCXLzoExZGxPWdF8NE9ltlWuh61asmOgYJZswuaxs076werl
         2HnXMAMjZOVgOGeh+Bw0JtJ77CjwLIEfbCa+wJE2TCodygZKFPKTBPCYDL2zJsKgWkt4
         C8St1iKQyEvIC6SWH4C379gBXZtZ+4oj+sPow=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        William Irwin <wli@holomorphy.com>
Subject: [PATCH v4 2/6] hugetlbfs: Change remove_from_page_cache
Date: Sun,  6 Feb 2011 19:48:01 +0900
Message-Id: <181a91bedeefb055e0fc88f16a340aa0c58ad34a.1296987110.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1296987110.git.minchan.kim@gmail.com>
References: <cover.1296987110.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1296987110.git.minchan.kim@gmail.com>
References: <cover.1296987110.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. Page cache ref count is decreased in delete_from_page_cache.
So we don't need decreasing page reference by caller.

Cc: William Irwin <wli@holomorphy.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/hugetlbfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9885082..b9eeb1c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -332,8 +332,7 @@ static void truncate_huge_page(struct page *page)
 {
 	cancel_dirty_page(page, /* No IO accounting for huge pages? */0);
 	ClearPageUptodate(page);
-	remove_from_page_cache(page);
-	put_page(page);
+	delete_from_page_cache(page);
 }
 
 static void truncate_hugepages(struct inode *inode, loff_t lstart)
-- 
1.7.1

