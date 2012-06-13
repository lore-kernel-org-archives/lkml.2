Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2FMLhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:37:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:16557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab2FMLgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157039707"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] hfsplus: make hfsplus_sync_fs static
Date: Wed, 13 Jun 2012 14:37:48 +0300
Message-Id: <1339587471-2713-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

... because it is used only in fs/hfsplus/super.c.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfsplus/hfsplus_fs.h |    1 -
 fs/hfsplus/super.c      |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 4e75ac6..66a9365 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -428,7 +428,6 @@ int hfsplus_show_options(struct seq_file *, struct dentry *);
 
 /* super.c */
 struct inode *hfsplus_iget(struct super_block *, unsigned long);
-int hfsplus_sync_fs(struct super_block *sb, int wait);
 
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index a9bca4b..5df771e 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -161,7 +161,7 @@ static void hfsplus_evict_inode(struct inode *inode)
 	}
 }
 
-int hfsplus_sync_fs(struct super_block *sb, int wait)
+static int hfsplus_sync_fs(struct super_block *sb, int wait)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
-- 
1.7.7.6

