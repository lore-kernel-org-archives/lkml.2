Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2HaN7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:59:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53849 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2HaN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:59:41 -0400
Message-ID: <5040C1BC.4080102@gmail.com>
Date: Fri, 31 Aug 2012 15:53:00 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>, Luca Tettamanti <kronos.it@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/21] procfs: drop vmtruncate
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
index 1b6c84c..36fa9dd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -545,9 +545,10 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
 
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
index b3647fe..d471d2f 100644
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
index dfafeb2..5c484f8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -740,9 +740,10 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 
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
