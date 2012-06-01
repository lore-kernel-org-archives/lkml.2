Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2FAOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:18:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989Ab2FAOQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:16:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036868"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 1/5] reiserfs: cleanup reiserfs_fill_super a bit
Date: Fri,  1 Jun 2012 17:18:04 +0300
Message-Id: <1338560288-10727-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
References: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We have the reiserfs superblock pointer in the 'sbi' variable in this
function, no need to use the 'REISERFS_SB(s)' macro which is the same.
This is jut a small clean-up.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/reiserfs/super.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 8b7616e..92db34b 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1730,19 +1730,19 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 	s->s_fs_info = sbi;
 	/* Set default values for options: non-aggressive tails, RO on errors */
-	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
-	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_ERROR_RO);
-	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_BARRIER_FLUSH);
+	sbi->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
+	sbi->s_mount_opt |= (1 << REISERFS_ERROR_RO);
+	sbi->s_mount_opt |= (1 << REISERFS_BARRIER_FLUSH);
 	/* no preallocation minimum, be smart in
 	   reiserfs_file_write instead */
-	REISERFS_SB(s)->s_alloc_options.preallocmin = 0;
+	sbi->s_alloc_options.preallocmin = 0;
 	/* Preallocate by 16 blocks (17-1) at once */
-	REISERFS_SB(s)->s_alloc_options.preallocsize = 17;
+	sbi->s_alloc_options.preallocsize = 17;
 	/* setup default block allocator options */
 	reiserfs_init_alloc_options(s);
 
-	mutex_init(&REISERFS_SB(s)->lock);
-	REISERFS_SB(s)->lock_depth = -1;
+	mutex_init(&sbi->lock);
+	sbi->lock_depth = -1;
 
 	jdev_name = NULL;
 	if (reiserfs_parse_options
@@ -1751,8 +1751,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		goto error_unlocked;
 	}
 	if (jdev_name && jdev_name[0]) {
-		REISERFS_SB(s)->s_jdev = kstrdup(jdev_name, GFP_KERNEL);
-		if (!REISERFS_SB(s)->s_jdev) {
+		sbi->s_jdev = kstrdup(jdev_name, GFP_KERNEL);
+		if (!sbi->s_jdev) {
 			SWARN(silent, s, "", "Cannot allocate memory for "
 				"journal device name");
 			goto error;
@@ -1810,7 +1810,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	/* make data=ordered the default */
 	if (!reiserfs_data_log(s) && !reiserfs_data_ordered(s) &&
 	    !reiserfs_data_writeback(s)) {
-		REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_DATA_ORDERED);
+		sbi->s_mount_opt |= (1 << REISERFS_DATA_ORDERED);
 	}
 
 	if (reiserfs_data_log(s)) {
-- 
1.7.7.6

