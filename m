Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2CGChY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:37:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45287 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2CGChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:37:20 -0500
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
To: gregkh@linuxfoundation.org, arve@android.com, chris+android@zenthought.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 v2] Staging:android: Initialise buffer and buffer_size before used
Date: Wed,  7 Mar 2012 10:36:58 +0800
Message-Id: <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, and
'buffer' is used as returned value, and 'buffer_size' is initialized using
uninitialized_var to clear warning.

Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
---
v2: added a subsystem prefix to the subject
---
 drivers/staging/android/binder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4350425..6caebeb 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -716,8 +716,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 					      size_t offsets_size, int is_async)
 {
 	struct rb_node *n = proc->free_buffers.rb_node;
-	struct binder_buffer *buffer;
-	size_t buffer_size;
+	struct binder_buffer *buffer = NULL;
+	size_t uninitialized_var(buffer_size);
 	struct rb_node *best_fit = NULL;
 	void *has_page_addr;
 	void *end_page_addr;
-- 
1.6.0.4

