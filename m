Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2DXWg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab2DXWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:52 -0400
Message-Id: <20120424223246.858425751@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <chris.mason@oracle.com>
Subject: [ 57/62] btrfs: btrfs_root_readonly() broken on big-endian
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6ed3cf2cdfce4c9f1d73171bd3f27d9cb77b734e upstream.

->root_flags is __le64 and all accesses to it go through the helpers
that do proper conversions.  Except for btrfs_root_readonly(), which
checks bit 0 as in host-endian...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2115,7 +2115,7 @@ BTRFS_SETGET_STACK_FUNCS(root_last_snaps
 
 static inline bool btrfs_root_readonly(struct btrfs_root *root)
 {
-	return root->root_item.flags & BTRFS_ROOT_SUBVOL_RDONLY;
+	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
 
 /* struct btrfs_root_backup */


