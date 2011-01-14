Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1ANBMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:12:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35322 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1ANBML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:12:11 -0500
Date: Fri, 14 Jan 2011 12:12:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the cleancache tree with Linus' tree
Message-Id: <20110114121207.8d9d33ad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Today's linux-next merge of the cleancache tree got a conflict in
include/linux/fs.h between commit
c8aebb0c9f8c7471643d5f8ba68328de8013005f ("per-superblock default
->d_op") from Linus' tree and commit
8b53f238859d3fca74c4c52ee1af8d6b5daafcc5 ("fs: add field to superblock to
support cleancache") from the cleancache tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fs.h
index ed6ee47,c52bab0..0000000
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@@ -1422,8 -1384,12 +1422,13 @@@ struct super_block 
  	 * Saved mount options for lazy filesystems using
  	 * generic_show_options()
  	 */
 -	char *s_options;
 +	char __rcu *s_options;
 +	const struct dentry_operations *s_d_op; /* default d_op for dentries */
+ 
+ 	/*
+ 	 * Saved pool identifier for cleancache (-1 means none)
+ 	 */
+ 	int cleancache_poolid;
  };
  
  extern struct timespec current_fs_time(struct super_block *sb);
