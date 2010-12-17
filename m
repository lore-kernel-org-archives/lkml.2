Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0LQROM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:14:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62680 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab0LQROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cFdFkWjGFbfQg+uW5UhdQO2phxKFx8b90hTOb1JsPaS9JyvCK0UuathDHbOQ5s3YtD
         2sFlfNGZLKFpl6coJ5dGPbbiUmX1gaGZQcPWqDHp7DvxNOxgjKQDMn09IOFwA0bmmobP
         UPTs3rh/6Y9kJtVLMduMYU58HtE4FPKeMjcI8=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [RFC 4/5] swap: Remove unnecessary page release
Date: Sat, 18 Dec 2010 02:13:39 +0900
Message-Id: <7b8f65cb0e08556bdb48c459cb1f72500f6aa61d.1292604746.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. page cache ref count is decreased in remove_from_page_cache.
So we don't need call again in caller context.

Cc:Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/shmem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fa9acc9..16800f2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1091,7 +1091,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 		spin_unlock(&info->lock);
 		swap_shmem_alloc(swap);
 		BUG_ON(page_mapped(page));
-		page_cache_release(page);	/* pagecache ref */
 		swap_writepage(page, wbc);
 		if (inode) {
 			mutex_lock(&shmem_swaplist_mutex);
-- 
1.7.0.4

