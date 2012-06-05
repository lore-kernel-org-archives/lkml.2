Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab2FEL1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:27:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:50403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761920Ab2FEL1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151777600"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] affs: introduce VFS superblock object back-reference
Date: Tue,  5 Jun 2012 14:28:14 +0300
Message-Id: <1338895695-10362-7-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Add an 'sb' VFS superblock back-reference to the 'struct affs_sb_info' data
structure - we will need to find the VFS superblock from a 'struct
affs_sb_info' object in the next patch, so this change is jut a preparation.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/affs.h  |    1 +
 fs/affs/super.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index b8af745..178d3a3 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -109,6 +109,7 @@ struct affs_sb_info {
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
 	spinlock_t symlink_lock;	/* protects the previous two */
 	struct mutex s_lock;		/* protects the SB's buffer-head */
+	struct super_block *sb;		/* the VFS superblock object */
 };
 
 #define SF_INTL		0x0001		/* International filesystem. */
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8674915..9acab34 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -299,6 +299,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
+	sbi->sb = sb;
 	mutex_init(&sbi->s_lock);
 	mutex_init(&sbi->s_bmlock);
 	spin_lock_init(&sbi->symlink_lock);
-- 
1.7.7.6

