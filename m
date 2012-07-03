Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2GCNmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:42:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:39618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab2GCNmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166324229"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/3] fs/sysv: remove another useless write_super call
Date: Tue,  3 Jul 2012 16:43:27 +0300
Message-Id: <1341323008-29414-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need to call 'sysv_write_super()' from 'sysv_remount()',
because VFS has called 'sysv_sync_fs()' before calling '->remount()'.
So remove it. Remove also '(un)lock_super()' which obvioulsy is becoming
useless in this function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/sysv/inode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index af13d13..f20ffe3 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -68,12 +68,9 @@ static void sysv_write_super(struct super_block *sb)
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
-	lock_super(sb);
+
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
-	if (*flags & MS_RDONLY)
-		sysv_write_super(sb);
-	unlock_super(sb);
 	return 0;
 }
 
-- 
1.7.7.6

