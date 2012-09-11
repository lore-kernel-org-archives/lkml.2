Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2IKU2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2IKU2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:28:20 -0400
Message-Id: <20120911202810.725043407@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 11 Sep 2012 16:28:11 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH v2 2/2] fs: add missing documentation to simple_xattr functions
References: <20120911202809.988739953@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=simple_xattr_doc.txt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: add function documentation instead of adding a separate file under
    Documentation/

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 fs/xattr.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: github/fs/xattr.c
===================================================================
--- github.orig/fs/xattr.c	2012-09-11 14:48:12.648072176 -0400
+++ github/fs/xattr.c	2012-09-11 15:33:14.502770685 -0400
@@ -892,8 +892,19 @@
 
 }
 
-/*
- * xattr SET operation for in-memory/pseudo filesystems
+/**
+ * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems
+ * @xattrs: simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new extended attribute. If NULL, will remove the
+ *	   attribute
+ * @flags: if XATTR_CREATE is set, no already existing extended attribute may
+ *	   exist. If XATTR_REPLACE is set, the extended attribute should exist.
+ *
+ * returns -ENOMEM for allocation failures, -EEXIST in case XATTR_CREATE is
+ *	   set in flags and an extended attribute with the same name exists,
+ *	   -ENODATA if XATTR_REPLACE is set in flags but no entry with the
+ *	   specified name exists.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)
@@ -950,6 +961,9 @@
 	return used;
 }
 
+/*
+ * Adds an extended attribute to the list
+ */
 void simple_xattr_list_add(struct simple_xattrs *xattrs,
 			   struct simple_xattr *new_xattr)
 {

