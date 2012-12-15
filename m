Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2LOKzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:55:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61345 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2LOKzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:55:38 -0500
Message-ID: <50CC5590.5060803@gmail.com>
Date: Sat, 15 Dec 2012 11:48:48 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
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
index aa63d25..c88e14a 100644
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
index 701580d..1827d88 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -736,13 +736,6 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
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
