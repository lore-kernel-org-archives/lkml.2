Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2HOTvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63000 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2HOTvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 105/165] ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes
Date: Wed, 15 Aug 2012 15:47:29 -0400
Message-ID: <1345060109-9187-106-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1cd9f0976aa4606db8d6e3dc3edd0aca8019372a upstream.

This doesn't make much sense, and it exposes a bug in the kernel where
attempts to create a new file in an append-only directory using
O_CREAT will fail (but still leave a zero-length file).  This was
discovered when xfstests #79 was generalized so it could run on all
file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/ext4.h          | 3 +--
 include/linux/ext2_fs.h | 4 ++--
 include/linux/ext3_fs.h | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 650ef37..f842e7d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -302,8 +302,7 @@ struct flex_groups {
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
-			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
 
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2dfa707..0bfcb76 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -196,8 +196,8 @@ struct ext2_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT2_FL_INHERITED (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
-			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
-			   EXT2_NODUMP_FL | EXT2_NOATIME_FL | EXT2_COMPRBLK_FL|\
+			   EXT2_SYNC_FL | EXT2_NODUMP_FL |\
+			   EXT2_NOATIME_FL | EXT2_COMPRBLK_FL |\
 			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
 			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 5f494b4..2d861bc 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -180,8 +180,8 @@ struct ext3_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT3_FL_INHERITED (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
-			   EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
-			   EXT3_NODUMP_FL | EXT3_NOATIME_FL | EXT3_COMPRBLK_FL|\
+			   EXT3_SYNC_FL | EXT3_NODUMP_FL |\
+			   EXT3_NOATIME_FL | EXT3_COMPRBLK_FL |\
 			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
 			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
 
-- 
1.7.12.rc2

