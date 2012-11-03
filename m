Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2KCJbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:31:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42964 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2KCJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:31:07 -0400
Message-ID: <5094E2CF.2020002@gmail.com>
Date: Sat, 03 Nov 2012 10:24:31 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 04/21] procfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/proc/base.c        |    7 -------
 fs/proc/generic.c     |    9 +--------
 fs/proc/proc_sysctl.c |    7 -------
 3 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 144a967..6f009a3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -542,13 +542,6 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
 	return 0;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 0d80cef..0c00b63 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -261,16 +261,9 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 	if (error)
 		return error;
 
-	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, iattr->ia_size);
-		if (error)
-			return error;
-	}
-
 	setattr_copy(inode, iattr);
 	mark_inode_dirty(inode);
-	
+
 	de->uid = inode->i_uid;
 	de->gid = inode->i_gid;
 	de->mode = inode->i_mode;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index a781bdf..4b354c0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -735,13 +735,6 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
 	return 0;
-- 
1.7.3.4
