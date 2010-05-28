Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0E1Bbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:31:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab0E1Bb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:31:26 -0400
Date: Fri, 28 May 2010 11:31:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20100528113124.899dc9e2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
include/linux/fs.h between commit
facd07b07d2a7988f5ce849558838cc953847637 ("direct-io: add a hook for the
fs to provide its own submit_bio function") from Linus' tree and commit
42e0df712d6a3573268d6be6bc97d113579e258c ("fs: introduce new truncate
sequence") from the vfs tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fs.h
index 85e823a,357ebcf..0000000
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@@ -2251,11 -2251,10 +2252,15 @@@ static inline int xip_truncate_page(str
  #endif
  
  #ifdef CONFIG_BLOCK
 +struct bio;
 +typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
 +			    loff_t file_offset);
 +void dio_end_io(struct bio *bio, int error);
 +
+ ssize_t __blockdev_direct_IO_newtrunc(int rw, struct kiocb *iocb, struct inode *inode,
+ 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
+ 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+ 	int lock_type);
  ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
  	struct block_device *bdev, const struct iovec *iov, loff_t offset,
  	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
