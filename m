Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2JFIUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:20:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55916 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2JFIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:20:20 -0400
Message-ID: <506FE836.3040400@gmail.com>
Date: Sat, 06 Oct 2012 10:13:42 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 04/22] procfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/proc/base.c        |    3 ++-
 fs/proc/generic.c     |    3 ++-
 fs/proc/proc_sysctl.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d295af9..add0944 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -544,9 +544,10 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, attr->ia_size);
 	}
 
 	setattr_copy(inode, attr);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 0d80cef..6e7a8a7 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -263,9 +263,10 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, iattr->ia_size);
+		error = inode_newsize_ok(inode, iattr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, iattr->ia_size);
 	}
 
 	setattr_copy(inode, iattr);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index dcd56f8..69d495c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -738,9 +738,10 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
+		truncate_setsize(inode, attr->ia_size);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
