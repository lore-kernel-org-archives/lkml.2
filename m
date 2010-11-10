Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0KJXrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:47:36 -0500
Received: from mail.perches.com ([173.55.12.10]:4946 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465Ab0KJXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:24 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] fs/adfs: Add printf format/argument verification and fix fallout
Date: Wed, 10 Nov 2010 15:46:13 -0800
Message-Id: <0225f04b4d546510012ed80507e2b9efafec618a.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__ ((format(printf, 3, 4))) to __adfs_error prototype
Change format string to match argument in adfs_dir_lookup_byname

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/adfs/adfs.h |    1 +
 fs/adfs/dir.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/adfs/adfs.h b/fs/adfs/adfs.h
index 2ff622f..fa078f1 100644
--- a/fs/adfs/adfs.h
+++ b/fs/adfs/adfs.h
@@ -129,6 +129,7 @@ extern int adfs_map_lookup(struct super_block *sb, unsigned int frag_id, unsigne
 extern unsigned int adfs_map_free(struct super_block *sb);
 
 /* Misc */
+__attribute__ ((format(printf, 3, 4)))
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
 #define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index f4287e4..6b74978 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -148,7 +148,7 @@ adfs_dir_lookup_byname(struct inode *inode, struct qstr *name, struct object_inf
 		goto out;
 
 	if (ADFS_I(inode)->parent_id != dir.parent_id) {
-		adfs_error(sb, "parent directory changed under me! (%lx but got %lx)\n",
+		adfs_error(sb, "parent directory changed under me! (%lx but got %x)\n",
 			   ADFS_I(inode)->parent_id, dir.parent_id);
 		ret = -EIO;
 		goto free_out;
-- 
1.7.3.1.g432b3.dirty

