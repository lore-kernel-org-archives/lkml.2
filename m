Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab2GLO1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:27:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:18972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933910Ab2GLO1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167258343"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 5/6] hfs: introduce VFS superblock object back-reference
Date: Thu, 12 Jul 2012 17:28:48 +0300
Message-Id: <1342103329-17526-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342103329-17526-1-git-send-email-dedekind1@gmail.com>
References: <1342103329-17526-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Add an 'sb' VFS superblock back-reference to the 'struct hfs_sb_info' data
structure - we will need to find the VFS superblock from a
'struct hfs_sb_info' object in the next patch, so this change is jut a
preparation.

Remove few useless newlines while on it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfs/hfs_fs.h |    6 +-----
 fs/hfs/super.c  |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 1bf967c..3515612 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -137,16 +137,12 @@ struct hfs_sb_info {
 	gid_t s_gid;				/* The gid of all files */
 
 	int session, part;
-
 	struct nls_table *nls_io, *nls_disk;
-
 	struct mutex bitmap_lock;
-
 	unsigned long flags;
-
 	u16 blockoffset;
-
 	int fs_div;
+	struct super_block *sb;
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 0730135..99c6239 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -380,6 +380,7 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 
+	sbi->sb = sb;
 	sb->s_fs_info = sbi;
 
 	res = -EINVAL;
-- 
1.7.7.6

