Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab2DXXiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:38:20 -0400
Received: from longford.logfs.org ([213.229.74.203]:56613 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab2DXXiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:38:17 -0400
X-Greylist: delayed 2469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2012 19:38:17 EDT
Date: Tue, 24 Apr 2012 16:57:40 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] do_mounts: Make name_to_dev_t parameter const
Message-ID: <20120424205740.GG20610@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, would you be a good person to take this patch?

Prevents annoying and unnecessary compiler warnings elsewhere.

Signed-off-by: Joern Engel <joern@logfs.org>

diff --git a/include/linux/mount.h b/include/linux/mount.h
index 604f122..10d5323 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -111,6 +111,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index c0851a8..5378145 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -93,7 +93,7 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(const char *uuid_str)
 {
 	dev_t res = 0;
 	struct device *dev = NULL;
@@ -133,7 +133,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
-- 
1.7.9.1

