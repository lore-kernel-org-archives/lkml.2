Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0EYNuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:50:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35317 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab0EYNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:50:51 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: [PATCHv4 04/17] BTRFS: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:48:59 +0300
Message-Id: <1274795352-3551-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:39.0844 (UTC) FILETIME=[42C6AA40:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d601629..bb76735 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2577,7 +2577,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
-	dir->i_sb->s_dirt = 1;
+	mark_sb_dirty(dir->i_sb);
 
 	btrfs_free_path(path);
 	return 0;
-- 
1.6.6.1

