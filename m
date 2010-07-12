Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0GLCZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:25:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56249 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0GLCZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:25:03 -0400
Date: Mon, 12 Jul 2010 12:24:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20100712122458.3fe5c01a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nilfs2/inode.c: In function 'nilfs_clear_inode':
fs/nilfs2/inode.c:630: error: implicit declaration of function 'nilfs_btnode_cache_clear'

Caused by commit 743a0a2f1a89e53d656ec6a2f715111d92642bcb ("convert
nilfs2 to ->evict_inode()") interacting with commit
ceb4f9c819c321e7eabf53b51f956ff959561573 ("nilfs2: get rid of
nilfs_bmap_union") from the nilfs2 tree which removed the implicit
inclusion of btnode.h (via bmap_union.h via nilfs.h).

I have added the following patch for today (which should be applied to
the vfs tree or merged into the above vfs tree commit):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Jul 2010 12:17:47 +1000
Subject: [PATCH] nilfs2: inode.c needs to include btnode.h directly now

Due to the new usage of nilfs_btnode_cache_clear().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nilfs2/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8fea40e..eccb2f2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include "nilfs.h"
+#include "btnode.h"
 #include "segment.h"
 #include "page.h"
 #include "mdt.h"
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
