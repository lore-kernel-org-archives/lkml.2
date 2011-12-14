Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1LNAtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:49:13 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37099 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab1LNAtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:49:05 -0500
Subject: [PATCH 23/23] ext4/jbd2: Add metadata checksumming to the list of
	supported features
To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Date: Tue, 13 Dec 2011 16:48:54 -0800
Message-ID: <20111214004854.28243.32973.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121400-6148-0000-0000-000001F10C07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Activate the metadata checksumming feature by adding it to ext4 and jbd2's
lists of supported features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h       |    6 ++++--
 include/linux/jbd2.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f6bf9d0..ca30846 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1461,7 +1461,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP| \
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -1469,7 +1470,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * Default values for user and/or group using reserved blocks
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 51d4a0b..b1c5857 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -296,7 +296,8 @@ typedef struct journal_superblock_s
 #define JBD2_KNOWN_ROCOMPAT_FEATURES	0
 #define JBD2_KNOWN_INCOMPAT_FEATURES	(JBD2_FEATURE_INCOMPAT_REVOKE | \
 					JBD2_FEATURE_INCOMPAT_64BIT | \
-					JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)
+					JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT | \
+					JBD2_FEATURE_INCOMPAT_CSUM_V2)
 
 #ifdef __KERNEL__
 

