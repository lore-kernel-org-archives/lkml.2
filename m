Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1AKFXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:23:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1AKFWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dQouvSAbYQ7YfIQo9Zj72gaGxwA37xx/3tdDOyxvXj6iUmVlYzBhFpdBKOLDn3N10w
         JbLHz2WV+ygv1b7KE+Nmfiv2s2rVo8Budbg5zKOkVf4g2FjNEAN71wAKHmk/gRVN01Gm
         RUQ5he0RRb5oJT8wwFpfRzhgN+10Nhm6QeHAY=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [PATCH v3 2/7] fuse: Change remove_from_page_cache
Date: Tue, 11 Jan 2011 14:22:06 +0900
Message-Id: <a41d3be39d5ecf7549ae7cfb7fc63807fe07a394.1294723009.git.minchan.kim@gmail.com>
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

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/fuse/dev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index cf8d28d..1ef24fb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -737,8 +737,7 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	if (WARN_ON(PageMlocked(oldpage)))
 		goto out_fallback_unlock;
 
-	remove_from_page_cache(oldpage);
-	page_cache_release(oldpage);
+	delete_from_page_cache(oldpage);
 
 	err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
 	if (err) {
-- 
1.7.0.4

