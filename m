Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab2GLN0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:26:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:27661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab2GLN0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="170963759"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Evgeniy Dushistov <dushistov@mail.ru>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] fs/ufs: remove extra superblock write on unmount
Date: Thu, 12 Jul 2012 16:28:06 +0300
Message-Id: <1342099688-14894-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

UFS calls 'ufs_write_super()' from 'ufs_put_super()' in order to write the
superblocks to the media. However, it is not needed because VFS calls
'->sync_fs()' before calling '->put_super()' - so by the time we are in
'ufs_write_super()', the superblocks are already synchronized.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ufs/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 302f340..ae91e0a 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1238,9 +1238,6 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
-		ufs_write_super(sb);
-
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_put_super_internal(sb);
 	
-- 
1.7.7.6

