Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1APTOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:14:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50374 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1APTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=XXY2dGe9K5J9hTDlZcZjMbJ/a6qe4rt93LjONgLbOaQIlneOtY+4A9sacY578BVReJ
         dwAacEzLwNderOw3qucOkwl6EnEiD2rHNAAHbzOLfD71Wn/WWI5nsIYO234U5Rbd17Fz
         2y/HEVzoFhsfHyMRHIVoH+MIDPseydAKuu+D0=
Subject: [PATCH] smbfs: Fix mismatched declaratons in proto.h and dir.c
From: Benjamin <masterme120@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 14:16:58 -0500
Message-ID: <1295205418.7516.6.camel@benjamin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a mismatch of the declarations of
smbfs_dentry_operations_case and smbfs_dentry_operations in
drivers/staging/smbfs/dir.c and drivers/staging/smbfs/proto.h by making
them static in both files.

Signed-off-by: Benjamin Fair <masterme120@gmail.com>
---
diff --git a/drivers/staging/smbfs/proto.h
b/drivers/staging/smbfs/proto.h
index 3883cb1..314c4cf 100644
--- a/drivers/staging/smbfs/proto.h
+++ b/drivers/staging/smbfs/proto.h
@@ -38,8 +38,8 @@ extern void smb_install_null_ops(struct smb_ops *ops);
 extern const struct file_operations smb_dir_operations;
 extern const struct inode_operations smb_dir_inode_operations;
 extern const struct inode_operations smb_dir_inode_operations_unix;
-extern const struct dentry_operations smbfs_dentry_operations_case;
-extern const struct dentry_operations smbfs_dentry_operations;
+extern static const struct dentry_operations
smbfs_dentry_operations_case;
+extern static const struct dentry_operations smbfs_dentry_operations;
 extern void smb_new_dentry(struct dentry *dentry);
 extern void smb_renew_times(struct dentry *dentry);
 /* cache.c */


