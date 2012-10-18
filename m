Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2JRUaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:30:08 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56798 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2JRU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 04/21] TTY: devpts, document devpts inode operations
Date: Thu, 18 Oct 2012 22:26:30 +0200
Message-Id: <1350592007-9216-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel-doc texts for some devpts functions, i.e. document them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/devpts/inode.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 7a20d67..472e6be 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -545,6 +545,15 @@ void devpts_kill_index(struct inode *ptmx_inode, int idx)
 	mutex_unlock(&allocated_ptys_lock);
 }
 
+/**
+ * devpts_pty_new -- create a new inode in /dev/pts/
+ * @ptmx_inode: inode of the master
+ * @device: major+minor of the node to be created
+ * @index: used as a name of the node
+ * @priv: what's given back by devpts_get_priv
+ *
+ * The created inode is returned. Remove it from /dev/pts/ by devpts_pty_kill.
+ */
 struct inode *devpts_pty_new(struct inode *ptmx_inode, dev_t device, int index,
 		void *priv)
 {
@@ -585,6 +594,12 @@ struct inode *devpts_pty_new(struct inode *ptmx_inode, dev_t device, int index,
 	return inode;
 }
 
+/**
+ * devpts_get_priv -- get private data for a slave
+ * @pts_inode: inode of the slave
+ *
+ * Returns whatever was passed as priv in devpts_pty_new for a given inode.
+ */
 void *devpts_get_priv(struct inode *pts_inode)
 {
 	struct dentry *dentry;
@@ -605,6 +620,12 @@ void *devpts_get_priv(struct inode *pts_inode)
 	return priv;
 }
 
+/**
+ * devpts_pty_kill -- remove inode form /dev/pts/
+ * @inode: inode of the slave to be removed
+ *
+ * This is an inverse operation of devpts_pty_new.
+ */
 void devpts_pty_kill(struct inode *inode)
 {
 	struct super_block *sb = pts_sb_from_inode(inode);
-- 
1.7.12.3


