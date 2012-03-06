Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031379Ab2CFUvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:51:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55690 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031365Ab2CFUvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:51:32 -0500
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
Date: Tue, 06 Mar 2012 12:50:42 -0800
Message-ID: <20120306205041.1663.70894.stgit@elm3b70.beaverton.ibm.com>
In-Reply-To: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030620-8974-0000-0000-00000702DC7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Activate the metadata checksumming feature by adding it to ext4 and jbd2's
lists of supported features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h       |    3 ++-
 include/linux/jbd2.h |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 900d5c4..dd75078 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1486,7 +1486,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * Default values for user and/or group using reserved blocks
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f321226..40ceeff 100644
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
 

