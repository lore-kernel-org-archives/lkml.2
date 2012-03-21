Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab2CUQPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:15:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:3084 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2CUQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121560017"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] VFS: remove unused superblock helpers
Date: Wed, 21 Mar 2012 18:14:29 +0200
Message-Id: <1332346475-1441-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Remove the 'sb_mark_dirty()', 'sb_mark_clean()' and 'sb_is_dirty()' helpers
which are not used. I introduced them 2 years and the intention was to make
all file-systems use them in order to be able to optimize 'sync_supers()'.
However, Al Viro vetoed my patches at the end and asked me to push superblock
management down to file-systems and get rid of the 's_dirt' flag completely,
as well as kill 'sync_supers()' altogether. Thus, remove the helpers.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 include/linux/fs.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69cd5bb..68387e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1870,19 +1870,6 @@ extern struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct dentry_operations *dops,
 	unsigned long);
 
-static inline void sb_mark_dirty(struct super_block *sb)
-{
-	sb->s_dirt = 1;
-}
-static inline void sb_mark_clean(struct super_block *sb)
-{
-	sb->s_dirt = 0;
-}
-static inline int sb_is_dirty(struct super_block *sb)
-{
-	return sb->s_dirt;
-}
-
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.7.7.6

