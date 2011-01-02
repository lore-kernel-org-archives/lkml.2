Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1ABPpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 10:45:15 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1ABPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 10:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ByrE50IgJHZOwr8vomivvHPI1qAlhplb6xyjYl25I1POoUJHXC13f+RtUiLmePUOHZ
         z00EZ3xDj6VPBcskrRFm9pA3w9zs7gpXdi66iSDIWtM6gEqz+wLLJniLKc8NueJTI1Xt
         1UMhqn51h6IydEXSZAsKwo1CcTrIG5RuWvygI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        William Irwin <wli@holomorphy.com>
Subject: [PATCH v2 3/7] tlbfs: Change remove_from_page_cache
Date: Mon,  3 Jan 2011 00:44:32 +0900
Message-Id: <fea353f42f47f0be44f460275f6ad0a4d436b702.1293982522.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. Page cache ref count is decreased in delete_from_page_cache.
So we don't need decreasing page reference by caller.

Cc: William Irwin <wli@holomorphy.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

