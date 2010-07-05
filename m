Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0GEMUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:20:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49113 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0GEMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:18:49 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 4/9] btrfs: remove junk sb_dirt change
Date: Mon,  5 Jul 2010 15:15:02 +0300
Message-Id: <1278332107-11443-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 05 Jul 2010 12:18:43.0452 (UTC) FILETIME=[35AFCBC0:01CB1C3C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

BTRFS does not define a '->write_super()' method, so it should
not mark its superblock as dirty. This looks like some left-over.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7f9e053..04916cd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2938,7 +2938,6 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
-	dir->i_sb->s_dirt = 1;
 
 	btrfs_free_path(path);
 	return 0;
-- 
1.7.0.1

