Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1GRIz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:55:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44696 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1GRIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:55:55 -0400
Date: Mon, 18 Jul 2011 18:55:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20110718185550.566328117558bea28395ca30@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
mm/truncate.c between commit ba96a361e21b ("fs: kill i_alloc_sem") from
the vfs tree and commit "Use consistent variable names in
truncate_pagecache(), truncate_setsize()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/truncate.c
index 003c6c6,a87d838..0000000
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@@ -622,11 -625,12 +625,11 @@@ int vmtruncate_range(struct inode *inod
  		return -ENOSYS;
  
  	mutex_lock(&inode->i_mutex);
 -	down_write(&inode->i_alloc_sem);
 +	inode_dio_wait(inode);
- 	unmap_mapping_range(mapping, offset, (end - offset), 1);
- 	inode->i_op->truncate_range(inode, offset, end);
+ 	unmap_mapping_range(mapping, holebegin, holelen, 1);
+ 	inode->i_op->truncate_range(inode, lstart, lend);
  	/* unmap again to remove racily COWed private pages */
- 	unmap_mapping_range(mapping, offset, (end - offset), 1);
+ 	unmap_mapping_range(mapping, holebegin, holelen, 1);
 -	up_write(&inode->i_alloc_sem);
  	mutex_unlock(&inode->i_mutex);
  
  	return 0;
