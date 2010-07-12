Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab0GLUvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:51:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0GLUvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:00 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Subject: [PATCH 26/36] fs/ext4: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:18 -0700
Message-Id: <57404f1380cc8d0609b5bd7ce178a8e9eddd2a06.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/dir.c     |    2 +-
 fs/ext4/mballoc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index ea5e6cb..737bf12 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -343,7 +343,7 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	struct dir_private_info *info;
 	int len;
 
-	info = (struct dir_private_info *) dir_file->private_data;
+	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..204588d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2221,7 +2221,7 @@ static int ext4_mb_seq_groups_open(struct inode *inode, struct file *file)
 
 	rc = seq_open(file, &ext4_mb_seq_groups_ops);
 	if (rc == 0) {
-		struct seq_file *m = (struct seq_file *)file->private_data;
+		struct seq_file *m = file->private_data;
 		m->private = sb;
 	}
 	return rc;
-- 
1.7.1.337.g6068.dirty

