Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2ADHZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:25:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45745 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2ADHZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:25:33 -0500
Date: Wed, 4 Jan 2012 10:25:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] procfs: update proc_show_options() to new API
Message-ID: <20120104072522.GG30978@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F03FEEB.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs to be updated to take a dentry pointer after 79744e695a "vfs:
switch ->show_options() to struct dentry *"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
