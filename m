Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1LHSFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:05:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1LHSFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:05:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2 6/7] VFS: Document s_frozen state through freeze_super
Date: Thu,  8 Dec 2011 10:04:36 -0800
Message-Id: <1323367477-21685-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323367477-21685-1-git-send-email-kamal@canonical.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <val@vaaconsulting.com>

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
[kamal@canonical.com: patch restructure]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/super.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 5629d06..a56696b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1140,6 +1140,24 @@ out:
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
  * -EBUSY.
+ *
+ * During this function, sb->s_frozen goes through these values:
+ *
+ * SB_UNFROZEN: File system is normal, all writes progress as usual.
+ *
+ * SB_FREEZE_WRITE: The file system is in the process of being frozen
+ * and any remaining out-standing writes are being synced.  Writes
+ * that complete in-process writes should be permitted but new ones
+ * should be blocked.
+ *
+ * SB_FREEZE_TRANS: The file system is frozen.  The ->freeze_fs and
+ * ->unfreeze_fs ops are the only operations permitted to write to the
+ * file system in this state.
+ *
+ * sb->s_frozen is protected by sb->s_umount.  Additionally,
+ * SB_FREEZE_WRITE is only temporarily set during freeze/thaw while
+ * holding sb->s_umount for writing, so any other callers holding
+ * sb->s_umount will never see this state.
  */
 int freeze_super(struct super_block *sb)
 {
-- 
1.7.5.4

