Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2I0Mwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2I0Mwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:41 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] fs/inode.c: remove outstanding spin lock prefetch
Date: Thu, 27 Sep 2012 20:51:55 +0800
Message-Id: <1348750316-4138-7-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we have particular reason to do this here?

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3a2cd41..e89d30c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -14,7 +14,6 @@
 #include <linux/fsnotify.h>
 #include <linux/mount.h>
 #include <linux/posix_acl.h>
-#include <linux/prefetch.h>
 #include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
 #include "internal.h"
@@ -919,8 +918,6 @@ struct inode *new_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_sb_list_lock);
-
 	inode = alloc_inode(sb);
 	if (inode) {
 		inode->i_state = 0;
-- 
1.7.9.5

