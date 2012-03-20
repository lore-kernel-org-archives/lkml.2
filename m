Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab2CTOlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:41:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:13019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235Ab2CTOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141907402"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v1 5/9] VFS: remove unused superblock helpers
Date: Tue, 20 Mar 2012 16:41:25 +0200
Message-Id: <1332254489-2300-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
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
Cc: Al Viro <viro@ZenIV.linux.org.uk>
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

