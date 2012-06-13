Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2FMAGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:06:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2FMAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:06:01 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 2/3] eCryptfs: Remove unused messaging declarations and function
Date: Tue, 12 Jun 2012 17:05:39 -0700
Message-Id: <1339545940-11736-3-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
References: <1338061161.4284.16.camel@lappy>
 <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are no longer needed.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    6 ------
 fs/ecryptfs/messaging.c       |   31 -------------------------------
 2 files changed, 37 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 867b64c..01a1f85 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -385,8 +385,6 @@ struct ecryptfs_msg_ctx {
 	struct mutex mux;
 };
 
-struct ecryptfs_daemon;
-
 struct ecryptfs_daemon {
 #define ECRYPTFS_DAEMON_IN_READ      0x00000001
 #define ECRYPTFS_DAEMON_IN_POLL      0x00000002
@@ -621,10 +619,6 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
 int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
-int ecryptfs_process_helo(uid_t euid, struct user_namespace *user_ns,
-			  struct pid *pid);
-int ecryptfs_process_quit(uid_t euid, struct user_namespace *user_ns,
-			  struct pid *pid);
 int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 			      struct user_namespace *user_ns, struct pid *pid,
 			      u32 seq);
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index a750f95..c11911d 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -216,37 +216,6 @@ out:
 }
 
 /**
- * ecryptfs_process_quit
- * @euid: The user ID owner of the message
- * @user_ns: The namespace in which @euid applies
- * @pid: The process ID for the userspace program that sent the
- *       message
- *
- * Deletes the corresponding daemon for the given euid and pid, if
- * it is the registered that is requesting the deletion. Returns zero
- * after deleting the desired daemon; non-zero otherwise.
- */
-int ecryptfs_process_quit(uid_t euid, struct user_namespace *user_ns,
-			  struct pid *pid)
-{
-	struct ecryptfs_daemon *daemon;
-	int rc;
-
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, user_ns);
-	if (rc || !daemon) {
-		rc = -EINVAL;
-		printk(KERN_ERR "Received request from user [%d] to "
-		       "unregister unrecognized daemon [0x%p]\n", euid, pid);
-		goto out_unlock;
-	}
-	rc = ecryptfs_exorcise_daemon(daemon);
-out_unlock:
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
-	return rc;
-}
-
-/**
  * ecryptfs_process_reponse
  * @msg: The ecryptfs message received; the caller should sanity check
  *       msg->data_len and free the memory
-- 
1.7.9.5

