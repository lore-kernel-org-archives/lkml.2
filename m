Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1EFAlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:41:15 -0400
Received: from kroah.org ([198.145.64.141]:37263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1EFAZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.854857246@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Chris Mason <chris.mason@oracle.com>
Subject: [118/143] btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6f88a4403def422bd8e276ddf6863d6ac71435d2 upstream.

Filesystem rebalancing (BTRFS_IOC_BALANCE) affects the entire
filesystem and may run uninterruptibly for a long time.  This does not
seem to be something that an unprivileged user should be able to do.

Reported-by: Aron Xu <happyaron.xu@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/btrfs/volumes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/iocontext.h>
+#include <linux/capability.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -1900,6 +1901,9 @@ int btrfs_balance(struct btrfs_root *dev
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
 


