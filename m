Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1ABPq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 10:46:27 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1ABPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 10:44:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KZFYNcDx2//hrqqt2T05SrnDfBqtIVYqfC7UXQKiRsu/aQyXVK+BkjRqksPYyHk2No
         4VVGHyE4Fuo4ggagpikdbGk17dMt/zM1M6wBF/LAuhDvLn6rErjTUloMAHF8zbSG9Wof
         uX9gAPTL4uocTKXqkfKMMeu1ep2doJ9MDYuws=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [PATCH v2 2/7] fuse: Change remove_from_page_cache
Date: Mon,  3 Jan 2011 00:44:31 +0900
Message-Id: <f5a696e5b34566a2942d655f6b7e29ee63c5a12a.1293982522.git.minchan.kim@gmail.com>
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

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

