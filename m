Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1BCL3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:29:22 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22251 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab1BCL3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:29:21 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] fs: Correctly check d_alloc_name() return code in devpts_pty_new
Date: Thu,  3 Feb 2011 14:29:11 +0300
Message-Id: <1296732551-10235-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_alloc_name return NULL in case error, but we expect errno in
devpts_pty_new.

http://bugzilla.openvz.org/show_bug.cgi?id=1758

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/devpts/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 1bb547c..8392c8c 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -501,7 +501,7 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_alloc_name(root, s);
-	if (!IS_ERR(dentry)) {
+	if (dentry) {
 		d_add(dentry, inode);
 		fsnotify_create(root->d_inode, dentry);
 	}
-- 
1.7.2.1

