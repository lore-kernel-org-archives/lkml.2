Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2LTTN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:13:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21358 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2LTTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:38 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] debugfs: remove redundant initialization of dentry
Date: Thu, 20 Dec 2012 14:11:22 -0500
Message-Id: <1356030701-16284-14-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already initialize it to NULL when declaring it, no need to do
that twice.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/debugfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 153bb1e..d329f9c 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -322,7 +322,6 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	if (!parent)
 		parent = debugfs_mount->mnt_root;
 
-	dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (!IS_ERR(dentry)) {
-- 
1.8.0

