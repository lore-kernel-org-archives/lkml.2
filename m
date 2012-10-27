Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2J0IG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:06:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53093 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2J0IFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:05:53 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] debugfs: return directly if failed to allocate memory in debug_fill_super()
Date: Sat, 27 Oct 2012 16:05:26 +0800
Message-Id: <1351325129-10097-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc failed, memory is not allocated, sb->s_fs_info is NULL.
No need to go through clean up code, return -ENOMEM directly.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b607d92..11f6514 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -262,10 +262,8 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
 
 	fsi = kzalloc(sizeof(struct debugfs_fs_info), GFP_KERNEL);
 	sb->s_fs_info = fsi;
-	if (!fsi) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!fsi)
+		return -ENOMEM;
 
 	err = debugfs_parse_options(data, &fsi->mount_opts);
 	if (err)
-- 
1.7.9.5

