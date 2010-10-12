Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0JLNsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:48:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48957 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0JLNsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:48:30 -0400
From: Lin Ming <lin@ming.vg>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/inode.c cleanup: make destroy_inode static
Date: Tue, 12 Oct 2010 21:47:42 +0800
Message-Id: <1286891262-7325-1-git-send-email-lin@ming.vg>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

destroy_inode is only used in fs/inode.c

Signed-off-by: Lin Ming <lin@ming.vg>
---
 fs/inode.c         |    2 +-
 include/linux/fs.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..3368abd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -235,7 +235,7 @@ void __destroy_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(__destroy_inode);
 
-void destroy_inode(struct inode *inode)
+static void destroy_inode(struct inode *inode)
 {
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..2343eaf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2184,7 +2184,6 @@ extern void unlock_new_inode(struct inode *);
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
-extern void destroy_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
-- 
1.7.2.3

