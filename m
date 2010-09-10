Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0IJOmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:42:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64985 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0IJOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JzoJYwo1vXkNQiNm4SvfdNIk2t3qt4QoGVGsYiqbLGSfO81TGxC8jjCkhFF1mRTNdk
         TYtF0feZdEcyxMbdeCj0yP6BwEe3nJPE4Gv4lsqUJHyha/Nz+0AtVo+JVhw3mVueG7Yo
         HiypvMtrjS4dPyKypUtk3KyPpqNh/aKVV/8Sk=
Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for using
 uninitialized variable
From: Frank Morales II <altf2o@gmail.com>
To: chris.mason@oracle.com, josef@redhat.com, zheng.yan@oracle.com,
        jens.axboe@oracle.com, tj@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 07:42:04 -0700
Message-ID: <1284129724.23418.27.camel@ubuntu1004pl>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1c304defc543738f82ccb18fe10b558dd2098d74 Mon Sep 17 00:00:00 2001
From: Frank Morales II <altf2o@gmail.com>
Date: Fri, 10 Sep 2010 07:34:23 -0700
Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for using uninitialized variable

In the function tree_search, the variable prev was used without first
being initialized, causing compiler warning messages. Initializing
prev to NULL resolved the issue.

Kernal patched against: 2.6.36-rc3 (df423dc7)

Signed-off-by: Frank Morales II <altf2o@gmail.com>
---
 fs/btrfs/ordered-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..fad2616 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -141,7 +141,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 					  u64 file_offset)
 {
 	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
+	struct rb_node *prev = NULL;
 	struct rb_node *ret;
 	struct btrfs_ordered_extent *entry;
 
-- 
1.7.0.4



