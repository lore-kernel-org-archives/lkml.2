Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2ACRZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:25:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47445 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2ACRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:25:04 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][linux-next] procfs: fix proc_show_option after dentry switch
Date: Tue,  3 Jan 2012 17:25:03 +0000
Message-Id: <1325611503-31485-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.7.1
X-OriginalArrivalTime: 03 Jan 2012 17:24:59.0745 (UTC) FILETIME=[9EC4D510:01CCCA3C]
X-MC-Unique: 112010317250104901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q03HPNWX008093

Commit 79744e6 (vfs: switch ->show_options() to struct dentry *)
has changed the show_options prototype.

Fix the proc_show_option to use struct dentry instead of
struct vfs.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
This appears at least in next-20120103.

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
1.7.7.1


