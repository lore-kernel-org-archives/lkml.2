Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2KVS6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2KVS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:00 -0500
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fs/buffer.c: do not inline exported function
Date: Thu, 22 Nov 2012 19:54:16 +0800
Message-Id: <1353585257-4415-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <N>
References: <N>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes no sense to inlines exported function.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---

init_buffer() is trivial and only get two module users. Maybe we 
can move it to buffer_head.h. 

Remove inline is much more simple to make it clean though.

 fs/buffer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b5f0442..69e83ee 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -46,8 +46,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
-inline void
-init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
+void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 {
 	bh->b_end_io = handler;
 	bh->b_private = private;
-- 
1.7.9.5

