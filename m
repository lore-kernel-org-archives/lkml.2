Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1IWBue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:50:34 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63702 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1IWBud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:50:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1316742632!16353432!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/xattr.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:50:19 -0700
User-Agent: KMail/1.9.9
CC: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221850.19938.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse noise:

warning: symbol 'btrfs_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 6196e1a..e878463 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -374,8 +374,8 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 				XATTR_REPLACE);
 }
 
-int btrfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int btrfs_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
 {
 	const struct xattr *xattr;
 	struct btrfs_trans_handle *trans = fs_info;
