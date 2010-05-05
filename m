Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab0EENQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:16:12 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:61180 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934806Ab0EENQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bQG9v93CbWdGjcyxFAW4Ia5QDYg/nRV6b2uyMf2nv9JG2CTElfecdg/tQAaXURxCmR
         2ZvdRSOM5uVLo15u1dd2ehFHw66SNuwIMrt72UmSMfN1zA47lLfatrjBXJEkIqGdqa5Z
         /jR2BMkmjaT8f4lATHu+qpkZN1r29OcXVW2Kg=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu
Subject: [PATCH 2/6] coda: Clean-up whitespace problems in pioctl.c
Date: Wed,  5 May 2010 15:15:35 +0200
Message-Id: <1273065339-21669-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 fs/coda/pioctl.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index 96ace2c..ca25d96 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -1,6 +1,6 @@
 /*
  * Pioctl operations for Coda.
- * Original version: (C) 1996 Peter Braam 
+ * Original version: (C) 1996 Peter Braam
  * Rewritten for Linux 2.1: (C) 1997 Carnegie Mellon University
  *
  * Carnegie Mellon encourages users of this code to contribute improvements
@@ -31,8 +31,7 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 			unsigned long user_data);
 
 /* exported from this file */
-const struct inode_operations coda_ioctl_inode_operations =
-{
+const struct inode_operations coda_ioctl_inode_operations = {
 	.permission	= coda_ioctl_permission,
 	.setattr	= coda_setattr,
 };
@@ -52,28 +51,28 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 			unsigned long user_data)
 {
 	struct path path;
-        int error;
+	int error;
 	struct PioctlData data;
 	struct inode *inode = filp->f_dentry->d_inode;
-        struct inode *target_inode = NULL;
-        struct coda_inode_info *cnp;
+	struct inode *target_inode = NULL;
+	struct coda_inode_info *cnp;
 
 	lock_kernel();
 
-        /* get the Pioctl data arguments from user space */
-        if (copy_from_user(&data, (void __user *)user_data, sizeof(data))) {
+	/* get the Pioctl data arguments from user space */
+	if (copy_from_user(&data, (void __user *)user_data, sizeof(data))) {
 		error = -EINVAL;
 		goto out;
 	}
-       
-        /* 
-         * Look up the pathname. Note that the pathname is in 
-         * user memory, and namei takes care of this
-         */
+
+	/*
+	 * Look up the pathname. Note that the pathname is in
+	 * user memory, and namei takes care of this
+	 */
 	if (data.follow)
-                error = user_path(data.path, &path);
+		error = user_path(data.path, &path);
 	else
-	        error = user_lpath(data.path, &path);
+		error = user_lpath(data.path, &path);
 
 	if (error)
 		goto out;
@@ -81,14 +80,14 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 		target_inode = path.dentry->d_inode;
 
 	/* return if it is not a Coda inode */
-	if ( target_inode->i_sb != inode->i_sb ) {
+	if (target_inode->i_sb != inode->i_sb) {
 		path_put(&path);
 		error = -EINVAL;
 		goto out;
 	}
 
 	/* now proceed to make the upcall */
-        cnp = ITOC(target_inode);
+	cnp = ITOC(target_inode);
 
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
 
@@ -96,5 +95,5 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 
 out:
 	unlock_kernel();
-        return error;
+	return error;
 }
-- 
1.6.6.1

