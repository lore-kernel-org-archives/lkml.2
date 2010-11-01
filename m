Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab0KAQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab0KAQQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:16:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] btrfs: close_bdev_exclusive() should use the same @flags as the matching open_bdev_exclusive()
Date: Mon,  1 Nov 2010 17:15:26 +0100
Message-Id: <1288628129-12811-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 16:15:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the failure path of __btrfs_open_devices(), close_bdev_exclusive()
is called with @flags which doesn't match the one used during
open_bdev_exclusive().  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc04dc1..d395962 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -638,7 +638,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 error_brelse:
 		brelse(bh);
 error_close:
-		close_bdev_exclusive(bdev, FMODE_READ);
+		close_bdev_exclusive(bdev, flags);
 error:
 		continue;
 	}
-- 
1.7.1

