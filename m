Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab2GYPLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:30025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219Ab2GYPK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267594"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH 06/16] ext4: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:04 +0300
Message-Id: <1343229134-29487-7-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from ext4 comments.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ff8b9f..854ca17 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1941,7 +1941,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
  * This function can get called via...
  *   - ext4_da_writepages after taking page lock (have journal handle)
  *   - journal_submit_inode_data_buffers (no journal handle)
- *   - shrink_page_list via pdflush (no journal handle)
+ *   - shrink_page_list via the kswapd/direct reclaim (no journal handle)
  *   - grab_page_cache when doing write_begin (have journal handle)
  *
  * We don't do any block allocation in this function. If we have page with
-- 
1.7.10

