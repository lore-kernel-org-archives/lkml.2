Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918Ab2FEL1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:27:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:50403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2FEL1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151777567"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] affs: remove useless superblock writeout on remount
Date: Tue,  5 Jun 2012 14:28:11 +0300
Message-Id: <1338895695-10362-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need to write out the superblock from '->remount_fs()' because
VFS has already called '->sync_fs()' by this time and the superblock has
already been written out. Thus, remove the 'affs_write_super()'
infocation from 'affs_remount()'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index db184c0..3fc50b1 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -546,10 +546,9 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 
-	if (*flags & MS_RDONLY) {
-		affs_write_super(sb);
+	if (*flags & MS_RDONLY)
 		affs_free_bitmap(sb);
-	} else
+	else
 		res = affs_init_bitmap(sb, flags);
 
 	return res;
-- 
1.7.7.6

