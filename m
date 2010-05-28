Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0E1Bb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:31:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42804 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab0E1BbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:31:21 -0400
Date: Fri, 28 May 2010 11:31:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the vfs tree with the ext3 tree
Message-Id: <20100528113120.b7fe818a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/ufs/file.c
between commit 8f45c33decf62e1aaaa9411aae8fef6a38f95845 ("ufs: Remove
dead quota code") from the ext3 tree and commit
8f1edffdb5a76f205cf45070e1552ee8b2239a2b ("rename the generic fsync
implementations") from the vfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ufs/file.c
index 73655c6,d4c30d1..0000000
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@@ -40,7 -41,7 +40,7 @@@ const struct file_operations ufs_file_o
  	.write		= do_sync_write,
  	.aio_write	= generic_file_aio_write,
  	.mmap		= generic_file_mmap,
 -	.open           = dquot_file_open,
 +	.open           = generic_file_open,
- 	.fsync		= simple_fsync,
+ 	.fsync		= generic_file_fsync,
  	.splice_read	= generic_file_splice_read,
  };
