Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2J0IGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:06:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab2J0IGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:06:06 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] debugfs: remove goto in debugfs_remount()
Date: Sat, 27 Oct 2012 16:05:29 +0800
Message-Id: <1351325129-10097-5-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple code clean to remove goto.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 58eadc1..c0b06a3 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -221,12 +221,11 @@ static int debugfs_remount(struct super_block *sb, int *flags, char *data)
 
 	err = debugfs_parse_options(data, &fsi->mount_opts);
 	if (err)
-		goto fail;
+		return err;
 
 	debugfs_apply_options(sb);
 
-fail:
-	return err;
+	return 0;
 }
 
 static int debugfs_show_options(struct seq_file *m, struct dentry *root)
-- 
1.7.9.5

