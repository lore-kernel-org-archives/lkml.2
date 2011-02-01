Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1BAGso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:48:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38338 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1BAGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jFidL1FvYpQCb/5RpOpIbqAOa6neFbs9XX4Jme1KPcOPtNib2PDeztyIYKLq3qoEKF
         qbhzEw16yyPQiJ7w0D8LwHWgY44dV+3bYeWkVwxiqYiTmt067V5/PcoFQdF/l5wAZsNr
         AcAQfQgVtAjtHnn6k4Q0RHL09NlwPkFbMpvZs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:staging:pohmelfs Fix some typos, and comments.
Date: Mon, 31 Jan 2011 22:48:25 -0800
Message-Id: <1296542905-27118-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes some typos, and makes some comments sound more proper.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/pohmelfs/config.c |    2 +-
 drivers/staging/pohmelfs/inode.c  |   10 +++++-----
 drivers/staging/pohmelfs/netfs.h  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index 89279ba..ed91330 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -134,7 +134,7 @@ int pohmelfs_copy_config(struct pohmelfs_sb *psb)
 		goto out_unlock;
 
 	/*
-	 * Run over all entries in given config group and try to crate and
+	 * Run over all entries in given config group and try to create and
 	 * initialize those, which do not exist in superblock list.
 	 * Skip all existing entries.
 	 */
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 56d3a4e..c93ef20 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -834,7 +834,7 @@ static void pohmelfs_i_callback(struct rcu_head *head)
 }
 
 /*
- * ->detroy_inode() callback. Deletes inode from the caches
+ * ->destroy_inode() callback. Deletes inode from the caches
  *  and frees private data.
  */
 static void pohmelfs_destroy_inode(struct inode *inode)
@@ -1127,18 +1127,18 @@ static ssize_t pohmelfs_getxattr(struct dentry *dentry, const char *name,
 
 		/*
 		 * This loop is a bit ugly, since it waits until reference counter
-		 * hits 1 and then put object here. Main goal is to prevent race with
-		 * network thread, when it can start processing given request, i.e.
+		 * hits 1 and then puts the object here. Main goal is to prevent race with
+		 * the network thread, when it can start processing the given request, i.e.
 		 * increase its reference counter but yet not complete it, while
 		 * we will exit from ->getxattr() with timeout, and although request
 		 * will not be freed (its reference counter was increased by network
 		 * thread), data pointer provided by user may be released, so we will
-		 * overwrite already freed area in network thread.
+		 * overwrite an already freed area in the network thread.
 		 *
 		 * Now after timeout we remove request from the cache, so it can not be
 		 * found by network thread, and wait for its reference counter to hit 1,
 		 * i.e. if network thread already started to process this request, we wait
-		 * it to finish, and then free object locally. If reference counter is
+		 * for it to finish, and then free object locally. If reference counter is
 		 * already 1, i.e. request is not used by anyone else, we can free it without
 		 * problem.
 		 */
diff --git a/drivers/staging/pohmelfs/netfs.h b/drivers/staging/pohmelfs/netfs.h
index 63391d2..985b6b7 100644
--- a/drivers/staging/pohmelfs/netfs.h
+++ b/drivers/staging/pohmelfs/netfs.h
@@ -191,7 +191,7 @@ enum {
 /*
  * POHMELFS capabilities: information about supported
  * crypto operations (hash/cipher, modes, key sizes and so on),
- * root informaion (used/available size, number of objects, permissions)
+ * root information (used/available size, number of objects, permissions)
  */
 enum pohmelfs_capabilities {
 	POHMELFS_CRYPTO_CAPABILITIES = 0,
-- 
1.6.5.GIT

