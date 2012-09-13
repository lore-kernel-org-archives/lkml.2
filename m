Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2IMSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:11:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2IMSL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:11:29 -0400
Date: Thu, 13 Sep 2012 11:11:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] fs: add missing documentation to simple_xattr
 functions
Message-ID: <20120913181124.GD7677@google.com>
References: <20120911202809.988739953@napanee.usersys.redhat.com>
 <20120911202810.725043407@napanee.usersys.redhat.com>
 <50521FA6.7040900@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50521FA6.7040900@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:02:14AM -0700, Randy Dunlap wrote:
> On 09/11/2012 01:28 PM, Aristeu Rozanski wrote:
> 
> 
> +/**
> + * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems
> 
> The format for the function name/description uses '-', not ':', as:
> 
>  * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems
> 
> + * @xattrs: simple_xattr list
> + * @name: name of the new extended attribute
> + * @value: value of the new extended attribute. If NULL, will remove the
> + *	   attribute
> 
> Missing @size parameter description.

Updated the patch in place accordingly.  Thanks.

>From 4895768b6aab55bbdbebcf2da090cb1a5ccf5463 Mon Sep 17 00:00:00 2001
From: Aristeu Rozanski <aris@redhat.com>
Date: Tue, 11 Sep 2012 16:28:11 -0400
Subject: [PATCH] fs: add missing documentation to simple_xattr functions

v2: add function documentation instead of adding a separate file under
    Documentation/

tj: Updated comment a bit and rolled in Randy's suggestions.

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/xattr.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index e17e773..f053c11 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -892,8 +892,19 @@ out:
 
 }
 
-/*
- * xattr SET operation for in-memory/pseudo filesystems
+/**
+ * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems
+ * @xattrs: target simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new xattr. If %NULL, will remove the attribute
+ * @size: size of the new xattr
+ * @flags: %XATTR_{CREATE|REPLACE}
+ *
+ * %XATTR_CREATE is set, the xattr shouldn't exist already; otherwise fails
+ * with -EEXIST.  If %XATTR_REPLACE is set, the xattr should exist;
+ * otherwise, fails with -ENODATA.
+ *
+ * Returns 0 on success, -errno on failure.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)
@@ -950,6 +961,9 @@ ssize_t simple_xattr_list(struct simple_xattrs *xattrs, char *buffer,
 	return used;
 }
 
+/*
+ * Adds an extended attribute to the list
+ */
 void simple_xattr_list_add(struct simple_xattrs *xattrs,
 			   struct simple_xattr *new_xattr)
 {
-- 
1.7.7.3

