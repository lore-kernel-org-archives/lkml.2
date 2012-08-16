Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2HPKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:10:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63686 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2HPKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:10:50 -0400
Message-ID: <502CC5A6.4080606@gmail.com>
Date: Thu, 16 Aug 2012 12:04:22 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 6/8] hpfs: remove lock/unlock super
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Rmoved lock and unlock super functions.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/hpfs/super.c linux-3.6-rc1/fs/hpfs/super.c
--- linux-3.6-rc1-orig/fs/hpfs/super.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/hpfs/super.c	2012-08-16 11:14:41.000000000 +0200
@@ -389,7 +389,6 @@ static int hpfs_remount_fs(struct super_
 	*flags |= MS_NOATIME;
 	
 	hpfs_lock(s);
-	lock_super(s);
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
 	umask = 0777 & ~sbi->sb_mode;
 	lowercase = sbi->sb_lowercase;
@@ -422,12 +421,10 @@ static int hpfs_remount_fs(struct super_
 
 	replace_mount_options(s, new_opts);
 
-	unlock_super(s);
 	hpfs_unlock(s);
 	return 0;
 
 out_err:
-	unlock_super(s);
 	hpfs_unlock(s);
 	kfree(new_opts);
 	return -EINVAL;


