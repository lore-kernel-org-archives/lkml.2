Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2H3PFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:05:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2H3PFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:05:13 -0400
Message-ID: <503F7F9A.3070402@gmail.com>
Date: Thu, 30 Aug 2012 16:58:34 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/8] hpfs: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lock/unlock super.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hpfs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..8af2cdc 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -389,7 +389,6 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	*flags |= MS_NOATIME;
 	
 	hpfs_lock(s);
-	lock_super(s);
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
 	umask = 0777 & ~sbi->sb_mode;
 	lowercase = sbi->sb_lowercase;
@@ -422,12 +421,10 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 
 	replace_mount_options(s, new_opts);
 
-	unlock_super(s);
 	hpfs_unlock(s);
 	return 0;
 
 out_err:
-	unlock_super(s);
 	hpfs_unlock(s);
 	kfree(new_opts);
 	return -EINVAL;
-- 
1.7.3.4
