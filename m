Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab0D3Rdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:33:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36097 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab0D3Rcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:32:36 -0400
Date: Fri, 30 Apr 2010 12:46:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: linux-next: manual merge of the block tree with the ext3 tree
Message-Id: <20100430124634.d474fce8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/ext3/fsync.c between commit a74302d5d82ff478822c49b8345312b6fd5c6e0a
("ext3: Fix waiting on transaction during fsync") from the ext3 tree and
commit fbd9b09a177a481eda256447c881f014f29034fe ("blkdev: generalize
flags for blkdev_issue_fn functions") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext3/fsync.c
index 26289e8,9492f60..0000000
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@@ -89,7 -90,9 +89,8 @@@ int ext3_sync_file(struct file * file, 
  	 * disk caches manually so that data really is on persistent
  	 * storage
  	 */
 -	if (test_opt(inode->i_sb, BARRIER))
 +	if (needs_barrier)
- 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+ 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
+ 				BLKDEV_IFL_WAIT);
 -out:
  	return ret;
  }
