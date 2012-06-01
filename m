Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab2FAORu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:17:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933308Ab2FAORD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036888"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 3/5] reiserfs: remove useless superblock dirtying
Date: Fri,  1 Jun 2012 17:18:06 +0300
Message-Id: <1338560288-10727-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
References: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The 'reiserfs_resize()' function marks the superblock as dirty by assigning 1
to 's_dirt' and then calls 'journal_mark_dirty()' which does the same. Thus,
we can remove the assignment from 'reiserfs_resize()'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/reiserfs/resize.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 9a17f63..3ce02cf 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -200,7 +200,6 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
 	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new);
-	s->s_dirt = 1;
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 
-- 
1.7.7.6

