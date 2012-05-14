Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab2ENVEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:04:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44678 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab2ENVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:04:22 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] ipc/mqueue: use correct gfp flags in msg_insert
Date: Mon, 14 May 2012 23:05:25 +0200
Message-Id: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msg_insert() tries to allocate using GFP_KERNEL, while in both cases when it's called,
it's coming from an atomic context. Introduced by 7dd7edf ("ipc/mqueue: improve
performance of send/recv").

Use GFP_ATOMIC instead.

Also, fix up coding style in the kzalloc while we're there.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 ipc/mqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 30f6f8f..9ec6896 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -133,7 +133,7 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
 		else
 			p = &(*p)->rb_right;
 	}
-	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
+	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
 	if (!leaf)
 		return -ENOMEM;
 	rb_init_node(&leaf->rb_node);
-- 
1.7.8.6

