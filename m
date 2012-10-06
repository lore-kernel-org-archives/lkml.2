Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2JFKrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 06:47:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54209 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JFKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 06:47:45 -0400
Message-ID: <50700AC1.50207@gmail.com>
Date: Sat, 06 Oct 2012 12:41:05 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
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
Acked-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
---
 fs/hpfs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index bc28bf0..a307622 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -398,7 +398,6 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	*flags |= MS_NOATIME;
 	
 	hpfs_lock(s);
-	lock_super(s);
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
 	umask = 0777 & ~sbi->sb_mode;
 	lowercase = sbi->sb_lowercase;
@@ -431,12 +430,10 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 
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
