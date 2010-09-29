Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0I2Dxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:53:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48435 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab0I2Dxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:53:44 -0400
Date: Wed, 29 Sep 2010 13:53:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the cleancache tree with the rcu tree
Message-Id: <20100929135343.ae08dbce.sfr@canb.auug.org.au>
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
4d2deb40b20c2608486598364e63e37b09a9ac2f ("kernel: __rcu annotations")
from the rcu tree and commit 661ea21b454e53a8b6fd587d2db0daa5be6d7c18
("fs: add field to superblock to support cleancache") from the cleancache
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fs.h
index fd85cd2,31eb6b8..0000000
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@@ -1386,7 -1380,12 +1386,12 @@@ struct super_block 
  	 * Saved mount options for lazy filesystems using
  	 * generic_show_options()
  	 */
 -	char *s_options;
 +	char __rcu *s_options;
+ 
+ 	/*
+ 	 * Saved pool identifier for cleancache (-1 means none)
+ 	 */
+ 	int cleancache_poolid;
  };
  
  extern struct timespec current_fs_time(struct super_block *sb);
