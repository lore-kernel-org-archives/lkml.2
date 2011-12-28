Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1L1NRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 08:17:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab1L1NRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 08:17:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] proc: Update for change of ->show_options() to struct dentry *
Date: Wed, 28 Dec 2011 13:17:21 +0000
Message-Id: <1325078242-25601-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change "vfs: switch ->show_options() to struct dentry *" in -next
updated the filesystems to use a struct dentry * as the second paremeter
for show_options() but procfs wasn't converted. Do the conversion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 fs/proc/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index e80cb5a..d839bfd 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -106,9 +106,9 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
-static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
-	struct super_block *sb = vfs->mnt_sb;
+	struct super_block *sb = root->d_sb;
 	struct pid_namespace *pid = sb->s_fs_info;
 
 	if (pid->pid_gid)
-- 
1.7.7.3

