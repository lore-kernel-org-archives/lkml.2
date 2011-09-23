Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1IWBmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:42:12 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:10201 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1IWBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:42:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1316742127!17043448!7
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/file.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:41:46 -0700
User-Agent: KMail/1.9.9
CC: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221841.46578.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse noise:

warning: symbol 'btrfs_find_defrag_inode' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..08e2aa0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -159,8 +159,8 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 /*
  * must be called with the defrag_inodes lock held
  */
-struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info, u64 ino,
-					     struct rb_node **next)
+static struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
+						u64 ino, struct rb_node **next)
 {
 	struct inode_defrag *entry = NULL;
 	struct rb_node *p;
