Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2ITOYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:24:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40237 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2ITOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:23:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: [PATCH v2 02/10] vfs: make dir_name arg to do_mount a const char *
Date: Thu, 20 Sep 2012 10:23:11 -0400
Message-Id: <1348150999-13028-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
References: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing changes it, so it should be safe to do.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namespace.c     | 2 +-
 include/linux/fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4d31f73..8e52b1c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2185,7 +2185,7 @@ int copy_mount_string(const void __user *data, char **where)
  * Therefore, if this magic number is present, it carries no information
  * and must be discarded.
  */
-long do_mount(char *dev_name, char *dir_name, char *type_page,
+long do_mount(char *dev_name, const char *dir_name, char *type_page,
 		  unsigned long flags, void *data_page)
 {
 	struct path path;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69513a7..b6ce6fc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2072,7 +2072,7 @@ extern struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
 extern void kern_unmount(struct vfsmount *mnt);
 extern int may_umount_tree(struct vfsmount *);
 extern int may_umount(struct vfsmount *);
-extern long do_mount(char *, char *, char *, unsigned long, void *);
+extern long do_mount(char *, const char *, char *, unsigned long, void *);
 extern struct vfsmount *collect_mounts(struct path *);
 extern void drop_collected_mounts(struct vfsmount *);
 extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
-- 
1.7.11.4

