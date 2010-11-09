Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0KIEDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:03:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0KIEDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:03:06 -0500
Date: Tue, 9 Nov 2010 15:03:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20101109150302.fa79a73a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

After merging the scsi-post-merge tree, today's linux-next build (sparc32
defconfig) failed like this:

fs/openpromfs/inode.c: In function 'openprom_mount':
fs/openpromfs/inode.c:422: error: expected ';' before '}' token

Caused by commit fc14f2fef682df677d64a145256dbd263df2aa7b ("convert
get_sb_single() users") from Linus' tree.   Pity that conmmit never made
it into the linux-next tree :-(

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 9 Nov 2010 14:58:55 +1100
Subject: [PATCH] openpromfs: fix for bad get_sb_single() conversion

Fixes:

fs/openpromfs/inode.c: In function 'openprom_mount':
fs/openpromfs/inode.c:422: error: expected ';' before '}' token

on sparc.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/openpromfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index ddb1f41..911e61f 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -418,7 +418,7 @@ out_no_root:
 static struct dentry *openprom_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_single(fs_type, flags, data, openprom_fill_super)
+	return mount_single(fs_type, flags, data, openprom_fill_super);
 }
 
 static struct file_system_type openprom_fs_type = {
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
