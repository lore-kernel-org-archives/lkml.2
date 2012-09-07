Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615Ab2IGNi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:38:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37872 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2IGNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:17 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 02/10] vfs: make dir_name arg to do_mount a const char *
Date: Fri,  7 Sep 2012 09:37:57 -0400
Message-Id: <1347025085-20285-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
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

