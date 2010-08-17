Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0HQOKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:10:34 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:53911 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab0HQOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:10:32 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCH] cramfs: only unlock new inodes
Date: Tue, 17 Aug 2010 17:08:35 +0300
Message-Id: <1282054115-8322-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.rc1.1.gb2842
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77b8a75f5bb introduced a warning at fs/inode.c:692 unlock_new_inode(),
caused by unlock_new_inode() being called on existing inodes as well.

This patch changes setup_inode() to only call unlock_new_inode() for I_NEW
inodes.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
---
 fs/cramfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a53b130..1e7a330 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -80,7 +80,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 		}
 	} else {
 		inode = iget_locked(sb, CRAMINO(cramfs_inode));
-		if (inode) {
+		if (inode && (inode->i_state & I_NEW)) {
 			setup_inode(inode, cramfs_inode);
 			unlock_new_inode(inode);
 		}
-- 
1.7.1

