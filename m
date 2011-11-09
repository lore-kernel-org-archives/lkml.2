Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193Ab1KJDa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:30:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935163Ab1KJDaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.410480851@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Theodore Tso" <tytso@mit.edu>
Subject: [157/262] ext2,ext3,ext4: dont inherit APPEND_FL or IMMUTABLE_FL for new inodes
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 1cd9f0976aa4606db8d6e3dc3edd0aca8019372a upstream.

This doesn't make much sense, and it exposes a bug in the kernel where
attempts to create a new file in an append-only directory using
O_CREAT will fail (but still leave a zero-length file).  This was
discovered when xfstests #79 was generalized so it could run on all
file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h          |    3 +--
 include/linux/ext2_fs.h |    4 ++--
 include/linux/ext3_fs.h |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -357,8 +357,7 @@ struct flex_groups {
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
-			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
 
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
 


