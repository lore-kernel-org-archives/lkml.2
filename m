Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2IEMRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:17:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61780 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab2IEMRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:17:42 -0400
From: yan <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 v2] proc : no need to initialize proc_inode->fd in proc_get_inode
Date: Wed,  5 Sep 2012 20:17:16 +0800
Message-Id: <1346847437-3308-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
References: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_get_inode() obtains the inode via a call to iget_locked().
iget_locked() calls alloc_inode() which will call proc_alloc_inode() which
clears proc_inode.fd, so there is no need to clear this field in
proc_get_inode().

If iget_locked() instead found the inode via find_inode_fast(), that inode
will not have I_NEW set so this change has no effect.

Signed-off-by: yan <clouds.yan@gmail.com>
---
 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..3b22bbd 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -450,7 +450,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 		return NULL;
 	if (inode->i_state & I_NEW) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
 
 		if (de->mode) {
-- 
1.7.9.5

