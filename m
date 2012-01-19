Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2ASKbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:31:51 -0500
Received: from mort.rzone.de ([81.169.144.234]:51828 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab2ASKbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:31:39 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 05:31:39 EST
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: sfr@canb.auug.org.au, chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, sensille@gmx.net,
        torvalds@linux-foundation.org
Subject: [PATCH] Btrfs: fix uninit warning in backref.c
Date: Thu, 19 Jan 2012 11:24:35 +0100
Message-Id: <1326968675-12294-1-git-send-email-list.btrfs@jan-o-sch.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20120119100935.82c5ec6db156f3799835163f@canb.auug.org.au>
References: <20120119100935.82c5ec6db156f3799835163f@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added initialization with the declaration of ret. It isn't set later on the
switch-default branch (which should never be taken).

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b9a8432..633c701 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -297,7 +297,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct rb_node *n = &head->node.rb_node;
 	int sgn;
-	int ret;
+	int ret = 0;
 
 	if (extent_op && extent_op->update_key)
 		btrfs_disk_key_to_cpu(info_key, &extent_op->key);
@@ -392,7 +392,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			     struct btrfs_key *info_key, int *info_level,
 			     struct list_head *prefs)
 {
-	int ret;
+	int ret = 0;
 	int slot;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-- 
1.7.3.4

