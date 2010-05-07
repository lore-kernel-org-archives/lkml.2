Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0EGTwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:52:46 -0400
Received: from liberdade.minaslivre.org ([72.232.254.139]:33636 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0EGTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:52:44 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Nick Piggin <npiggin@suse.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] trivial: inode uses a mutex instead of a semaphore.
Date: Fri,  7 May 2010 16:52:26 -0300
Message-Id: <1273261946-19378-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the introduced i_sem by an i_mutex in the filesystem locking
documentation. This was introduced [1] after all occurrences were
already replaced in the same text [2]. However, the term "inode
semaphore" has not been replaced then, and it's replaced now.

[1] afddba49d18f346e5cc2938b6ed7c512db18ca68
[2] a7bc02f4f47fd0e7860c6589f0ad000d1476f7a3

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/Locking |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 06bbbed..af16080 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -178,7 +178,7 @@ prototypes:
 locking rules:
 	All except set_page_dirty may block
 
-			BKL	PageLocked(page)	i_sem
+			BKL	PageLocked(page)	i_mutex
 writepage:		no	yes, unlocks (see below)
 readpage:		no	yes, unlocks
 sync_page:		no	maybe
@@ -429,7 +429,7 @@ check_flags:		no
 implementations.  If your fs is not using generic_file_llseek, you
 need to acquire and release the appropriate locks in your ->llseek().
 For many filesystems, it is probably safe to acquire the inode
-semaphore.  Note some filesystems (i.e. remote ones) provide no
+mutex.  Note some filesystems (i.e. remote ones) provide no
 protection for i_size so you will need to use the BKL.
 
 Note: ext2_release() was *the* source of contention on fs-intensive
-- 
1.7.1

