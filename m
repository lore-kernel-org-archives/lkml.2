Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2J2Hcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:32:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50862 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2J2Hcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:32:51 -0400
Message-ID: <508E30F8.3090606@gmail.com>
Date: Mon, 29 Oct 2012 15:32:08 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: tytso@mit.edu
CC: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: get rid of the duplicate code on ext4_fill_super
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Clean the duplicate code on ext4_fill_super cause the bellow
also have it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/ext4/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..d21b985 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3272,9 +3272,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb = sb;
-	sbi->s_mount_opt = 0;
-	sbi->s_resuid = make_kuid(&init_user_ns, EXT4_DEF_RESUID);
-	sbi->s_resgid = make_kgid(&init_user_ns, EXT4_DEF_RESGID);
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
 	sbi->s_sb_block = sb_block;
 	if (sb->s_bdev->bd_part)
-- 1.7.1
