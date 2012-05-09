Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2EIG3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:29:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38739 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581Ab2EIFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:53 -0400
Message-Id: <20120509055037.052794862@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 053/167] [PATCH] btrfs: btrfs_root_readonly() broken on big-endian
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6ed3cf2cdfce4c9f1d73171bd3f27d9cb77b734e upstream.

->root_flags is __le64 and all accesses to it go through the helpers
that do proper conversions.  Except for btrfs_root_readonly(), which
checks bit 0 as in host-endian...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b8ef8e..3f65a81 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2166,7 +2166,7 @@ BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
 
 static inline bool btrfs_root_readonly(struct btrfs_root *root)
 {
-	return root->root_item.flags & BTRFS_ROOT_SUBVOL_RDONLY;
+	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
 
 /* struct btrfs_root_backup */
-- 
1.7.10



