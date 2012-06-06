Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab2FFP6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:58:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab2FFPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755284"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/7] affs: remove useless superblock writeout on remount
Date: Wed,  6 Jun 2012 18:56:53 +0300
Message-Id: <1338998217-5010-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
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
index 12b4f58..c837e43 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -545,10 +545,9 @@ affs_remount(struct super_block *sb, int *flags, char *data)
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

