Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1GZRZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1GZRZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:25:09 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: document locking requirements for d_move and __d_move
Date: Tue, 26 Jul 2011 13:25:07 -0400
Message-Id: <1311701107-22971-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_move and __d_move have some pretty substantial locking requirements, but
they are not clearly documented. Add some comments spelling them out.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/dcache.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index be18598..759f167 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2138,8 +2138,9 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
  * @target: new dentry
  *
  * Update the dcache to reflect the move of a file name. Negative
- * dcache entries should not be moved in this way.  Caller hold
- * rename_lock.
+ * dcache entries should not be moved in this way. Caller must hold
+ * rename_lock, the i_mutex of the source and target directories,
+ * and the sb->s_vfs_rename_mutex if they differ. See lock_rename().
  */
 static void __d_move(struct dentry * dentry, struct dentry * target)
 {
@@ -2202,7 +2203,8 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
  * @target: new dentry
  *
  * Update the dcache to reflect the move of a file name. Negative
- * dcache entries should not be moved in this way.
+ * dcache entries should not be moved in this way. See the locking
+ * requirements for __d_move.
  */
 void d_move(struct dentry *dentry, struct dentry *target)
 {
-- 
1.7.1

