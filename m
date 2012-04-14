Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2DNJYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:24:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53238 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2DNJYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:24:41 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chris Mason <chris.mason@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/btrfs/volumes.c: add missing free_fs_devices
Date: Sat, 14 Apr 2012 11:24:33 +0200
Message-Id: <1334395473-16667-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free fs_devices as done in the error-handling code just below.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/btrfs/volumes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a872b48..5d246c3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4334,8 +4334,10 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 
 	ret = __btrfs_open_devices(fs_devices, FMODE_READ,
 				   root->fs_info->bdev_holder);
-	if (ret)
+	if (ret) {
+		free_fs_devices(fs_devices);
 		goto out;
+	}
 
 	if (!fs_devices->seeding) {
 		__btrfs_close_devices(fs_devices);

