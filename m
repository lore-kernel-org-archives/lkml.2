Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1JLMON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:14:13 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:58745 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1JLMOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:14:12 -0400
Subject: [PATCH] [TRIVIAL] cifs: Fix typo 'CIFS_NFSD_EXPORT'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Steve French <sfrench@samba.org>, Steve French <sfrench@samba.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:14:04 +0200
Message-ID: <1318421644.2336.10.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be 'CONFIG_CIFS_NFSD_EXPORT'. No-one noticed because that
symbol depends on BROKEN.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
It is once again clear what was intended. But perhaps maintainer
approval is still needed. (I've only eyeball-tested this.)

 fs/cifs/cifsfs.c |    4 ++--
 fs/cifs/cifsfs.h |    4 ++--
 fs/cifs/export.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 54b8f1e..5dd83ef 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -132,12 +132,12 @@ cifs_read_super(struct super_block *sb)
 	else
 		sb->s_d_op = &cifs_dentry_ops;
 
-#ifdef CIFS_NFSD_EXPORT
+#ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cFYI(1, "export ops supported");
 		sb->s_export_op = &cifs_export_ops;
 	}
-#endif /* CIFS_NFSD_EXPORT */
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
 
 	return 0;
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 95da802..d9dbaf8 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -121,9 +121,9 @@ extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
-#ifdef CIFS_NFSD_EXPORT
+#ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
-#endif /* CIFS_NFSD_EXPORT */
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
 
 #define CIFS_VERSION   "1.75"
 #endif				/* _CIFSFS_H */
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 55d87ac..9c7ecdc 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -45,7 +45,7 @@
 #include "cifs_debug.h"
 #include "cifsfs.h"
 
-#ifdef CIFS_NFSD_EXPORT
+#ifdef CONFIG_CIFS_NFSD_EXPORT
 static struct dentry *cifs_get_parent(struct dentry *dentry)
 {
 	/* BB need to add code here eventually to enable export via NFSD */
@@ -63,5 +63,5 @@ const struct export_operations cifs_export_ops = {
 	.encode_fs =  */
 };
 
-#endif /* CIFS_NFSD_EXPORT */
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
 
-- 
1.7.4.4



