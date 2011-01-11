Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1AKFW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:22:58 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51175 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1AKFWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YxfyozolqJvf5TWaLwMEkMvgMHEMmJXkprdY/OVAgPi0DYqrWvXjwknbSEfjx5mwpl
         1XrfTX8rdXNaV2KBbeB3mZJQdZk3lRyQ/agjVi6Ls4r52/ivlXBVEqZcDBS3ifdPgEGn
         e7B00pQ8kSnhzNiznDpWbxRq89AIWWOeMkopI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        William Irwin <wli@holomorphy.com>
Subject: [PATCH v3 3/7] hugetlbfs: Change remove_from_page_cache
Date: Tue, 11 Jan 2011 14:22:07 +0900
Message-Id: <95582288aa619785893385ac5f5e2ded45e0cc28.1294723009.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1294723009.git.minchan.kim@gmail.com>
References: <cover.1294723009.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1294723009.git.minchan.kim@gmail.com>
References: <cover.1294723009.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. Page cache ref count is decreased in delete_from_page_cache.
So we don't need decreasing page reference by caller.

Cc: William Irwin <wli@holomorphy.com>
Acked-by: Hugh Dickins <hughd@google.com>
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
1.7.0.4

