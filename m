Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab0FFO4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:56:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18231 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997Ab0FFOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:35 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCHv5 09/16] btrfs: remove junk sb_mark_dirty call
Date: Sun,  6 Jun 2010 17:50:22 +0300
Message-Id: <1275835829-1478-10-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:27.0575 (UTC) FILETIME=[0579CA70:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

BTRFS does not define '->write_super()' method, so it should not
mark its superblock as dirty. This looks like some left-over.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index caa4ed9..1419d90 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2938,7 +2938,6 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
-	sb_mark_dirty(dir->i_sb);
 
 	btrfs_free_path(path);
 	return 0;
-- 
1.7.0.1

