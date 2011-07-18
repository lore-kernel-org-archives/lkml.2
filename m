Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1GRDgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:36:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41348 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1GRDge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:36:34 -0400
Date: Mon, 18 Jul 2011 13:36:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@users.sf.net>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20110718133625.f78ac5eb9a4a2084665003fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/inode.c between commit dae1e52cb126 ("ext4: move ext4_ind_*
functions from inode.c to indirect.c") from the ext4 tree and commit
d1769fea6879 ("fs: simplify the blockdev_direct_IO prototype") from the
vfs tree.

A function moved to a new file.  I fixed it up and can carry the fix as
necessary.

I also needed the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Jul 2011 13:28:44 +1000
Subject: [PATCH] vfs/ext4: merge fixup for moved function

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/indirect.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 6c27111..b8602cd 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -806,10 +806,8 @@ retry:
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
 	else {
-		ret = blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL);
+		ret = blockdev_direct_IO(rw, iocb, inode, iov,
+				 offset, nr_segs, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
