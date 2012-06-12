Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2FLL6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:58:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:44829 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2FLL6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:58:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164607784"
Date: Tue, 12 Jun 2012 19:58:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] a writeback locking fix
Message-ID: <20120612115807.GA17717@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback-lock-fix

for you to fetch changes up to ead188f9f930fb5d7f0c49315a7fce3d8bd16b7e:

  writeback: Fix lock imbalance in writeback_sb_inodes() (2012-06-09 08:32:15 +0900)

----------------------------------------------------------------
fix unbalanced wb->list_lock in 3.5-rc1

----------------------------------------------------------------
Jan Kara (1):
      writeback: Fix lock imbalance in writeback_sb_inodes()

 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..41a3ccf 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 			/* Wait for I_SYNC. This function drops i_lock... */
 			inode_sleep_on_writeback(inode);
 			/* Inode may be gone, start again */
+			spin_lock(&wb->list_lock);
 			continue;
 		}
 		inode->i_state |= I_SYNC;
