Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0LQROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:14:47 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:57880 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0LQRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DaYQthOEOYdzcuEtr9//3e9T3N6Ddsl3oDO3Go1A61vnpPpW1WNss+ZMhKzrvZpor6
         iKUsw/EwXN190vz7lYyzyQSz98qOxddEl1xL91Nc+VlfV4HwUzDVkZcO9qbN00H0L2vD
         SA4eiX/SkwVsrgWdCQP8sGWQ95PukapdX7BhA=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [RFC 2/5] fuse: Remove unnecessary page release
Date: Sat, 18 Dec 2010 02:13:37 +0900
Message-Id: <16cfab4a6cb77f47f9a632a774d8bd04b4fe9ff2.1292604745.git.minchan.kim@gmail.com>
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

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/fuse/dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index cf8d28d..4adaf4b 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -738,7 +738,6 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 		goto out_fallback_unlock;
 
 	remove_from_page_cache(oldpage);
-	page_cache_release(oldpage);
 
 	err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
 	if (err) {
-- 
1.7.0.4

