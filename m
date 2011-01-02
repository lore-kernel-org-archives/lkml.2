Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1ABIHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:07:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:34437 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1ABHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 004/260] ext4: check missed return value in ext4_sync_file()
Date: Sun,  2 Jan 2011 02:15:00 -0500
Message-Id: <1293952756-15010-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:11.0178 (UTC) FILETIME=[7DE870A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 0671e704658b9f26f85e78d51176daa861f955c7 upstream.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/fsync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..42bd94a 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -101,7 +101,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-		jbd2_log_wait_commit(journal, commit_tid);
+		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
-- 
1.7.3.3

