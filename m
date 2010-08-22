Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0HVNbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 09:31:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:50956 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0HVNbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 09:31:02 -0400
Date: Sun, 22 Aug 2010 22:30:40 +0900 (JST)
Message-Id: <20100822.223040.116160895.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] nilfs2 additional fix
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 22 Aug 2010 22:30:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following fix, which corrects sync failure of discard in
nilfs that Christoph noticed me recently.

Thanks!

Ryusuke Konishi
--
The following changes since commit 3b89f56783a4ef796190ef1192c25e72e0b986b6:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

Ryusuke Konishi (1):
      nilfs2: wait for discard to finish

 fs/nilfs2/the_nilfs.c |    4 +++-

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 6af1c00..4317f17 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -775,6 +775,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
 						   GFP_NOFS,
+						   BLKDEV_IFL_WAIT |
 						   BLKDEV_IFL_BARRIER);
 			if (ret < 0)
 				return ret;
@@ -785,7 +786,8 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS, BLKDEV_IFL_BARRIER);
+					   GFP_NOFS,
+					  BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 	return ret;
 }
 
