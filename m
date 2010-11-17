Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab0KQRhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:37:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43761 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935053Ab0KQRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:37:10 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/2] overlayfs: handle missing lower inodes in ovl_is_same_inode
Date: Wed, 17 Nov 2010 17:37:03 +0000
Message-Id: <1290015424-5583-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290015424-5583-1-git-send-email-apw@canonical.com>
References: <1290015424-5583-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/overlayfs.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 63afa3d..6b8a7b9 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1948,19 +1948,25 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
 
 static bool ovl_is_same_inode(struct dentry *d1, struct dentry *d2)
 {
-	struct dentry *upperd1;
-	struct dentry *upperd2;
+	struct dentry *od1;
+	struct dentry *od2;
 
-	upperd1 = ovl_dentry_upper(d1);
-	upperd2 = ovl_dentry_upper(d2);
+	od1 = ovl_dentry_upper(d1);
+	od2 = ovl_dentry_upper(d2);
 
-	if (upperd1 && upperd2)
-		return vfs_is_same_inode(upperd1, upperd2);
+	if (od1 && od2)
+		return vfs_is_same_inode(od1, od2);
 
-	if (upperd1 || upperd2)
+	if (od1 || od2)
 		return false;
 
-	return vfs_is_same_inode(ovl_dentry_lower(d1), ovl_dentry_lower(d2));
+	od1 = ovl_dentry_lower(d1);
+	od2 = ovl_dentry_lower(d2);
+
+	if (od1 && od2)
+		return vfs_is_same_inode(od1, od2);
+
+	return false;
 }
 
 /**
-- 
1.7.0.4

