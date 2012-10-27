Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2J0IGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:06:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2J0IF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:05:57 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] debugfs: remove redundant initialization in __create_file()
Date: Sat, 27 Oct 2012 16:05:27 +0800
Message-Id: <1351325129-10097-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'dentry' has been set to NULL at the beginning of the function.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 11f6514..12f1282 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -321,7 +321,6 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	if (!parent)
 		parent = debugfs_mount->mnt_root;
 
-	dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (!IS_ERR(dentry)) {
-- 
1.7.9.5

