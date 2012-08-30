Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2H3PDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:03:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2H3PD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:03:28 -0400
Message-ID: <503F7F31.10708@gmail.com>
Date: Thu, 30 Aug 2012 16:56:49 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/8] ext3: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lock/unlock super.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ext3/super.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 8c892e9..9b3d498 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2571,11 +2571,9 @@ out:
 static int ext3_unfreeze(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY)) {
-		lock_super(sb);
 		/* Reser the needs_recovery flag before the fs is unlocked. */
 		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
-		unlock_super(sb);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
 	return 0;
@@ -2595,7 +2593,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 #endif
 
 	/* Store the original options */
-	lock_super(sb);
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
 	old_opts.s_resuid = sbi->s_resuid;
@@ -2701,8 +2698,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
 			kfree(old_opts.s_qf_names[i]);
 #endif
-	unlock_super(sb);
-
 	if (enable_quota)
 		dquot_resume(sb, -1);
 	return 0;
@@ -2721,7 +2716,6 @@ restore_opts:
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
-	unlock_super(sb);
 	return err;
 }
 
-- 
1.7.3.4
