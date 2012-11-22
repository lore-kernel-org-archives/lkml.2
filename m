Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab2KVWYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:24:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2KVShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:37:04 -0500
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fs/buffer.c: remove redundant initialization in alloc_page_buffers()
Date: Thu, 22 Nov 2012 19:54:17 +0800
Message-Id: <1353585257-4415-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353585257-4415-1-git-send-email-clouds.yan@gmail.com>
References: <N>
 <1353585257-4415-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffer_head comes from kmem_cache_zalloc(), no need to zero
its field.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---

init_buffer() can be actually removed too, but I'm afraid someday its 
semantic will beyond initializing ->b_end_io and ->b_private.

 fs/buffer.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 69e83ee..ad87aa6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -849,13 +849,10 @@ try_again:
 		if (!bh)
 			goto no_grow;
 
-		bh->b_bdev = NULL;
 		bh->b_this_page = head;
 		bh->b_blocknr = -1;
 		head = bh;
 
-		bh->b_state = 0;
-		atomic_set(&bh->b_count, 0);
 		bh->b_size = size;
 
 		/* Link the buffer to its page */
-- 
1.7.9.5

