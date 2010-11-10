Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0KJKXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:23:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754069Ab0KJKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:23:31 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19CLmkXtG9C4mGHqbkJfVmuy9zTD64TaHVf6Ormrq
	PY6/t6LlL331Av
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>, joe@perches.com,
        hirofumi@mail.parknet.co.jp
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 4/4] Report each FAT mount and mount options.
Date: Wed, 10 Nov 2010 11:23:12 +0100
Message-Id: <1289384592-4881-4-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289331805.28590.17.camel@Joe-Laptop>
References: <1289331805.28590.17.camel@Joe-Laptop>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report each mount and mount options. Example:
FAT-fs (sdc1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a85adf8..75d936f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -552,6 +552,8 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+
+	fat_msg(sb, KERN_INFO, "re-mounted. Opts: %s", data);
 	return 0;
 }
 
@@ -1249,6 +1251,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	unsigned int media;
 	long error;
 	char buf[50];
+	char *orig_data = kstrdup(data, GFP_KERNEL);
 
 	/*
 	 * GFP_KERNEL is ok here, because while we do hold the
@@ -1503,6 +1506,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		goto out_fail;
 	}
 
+	fat_msg(sb, KERN_INFO, "Mounted. Opts: %s", orig_data);
+	kfree(orig_data);
+
 	return 0;
 
 out_invalid:
-- 
1.7.1

