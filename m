Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2GCNm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:42:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:39618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab2GCNmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:42:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166324218"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/3] fs/sysv: remove useless write_super call
Date: Tue,  3 Jul 2012 16:43:26 +0300
Message-Id: <1341323008-29414-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need to call 'sysv_write_super()' from 'sysv_put_super()',
because VFS has called 'sysv_sync_fs()' before calling '->put_super()'.
So remove it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/sysv/inode.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 08d0b25..af13d13 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -81,9 +81,6 @@ static void sysv_put_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
-	if (sb->s_dirt)
-		sysv_write_super(sb);
-
 	if (!(sb->s_flags & MS_RDONLY)) {
 		/* XXX ext2 also updates the state here */
 		mark_buffer_dirty(sbi->s_bh1);
-- 
1.7.7.6

