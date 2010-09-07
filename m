Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0IGOgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:36:48 -0400
Received: from www.tglx.de ([62.245.132.106]:43824 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab0IGOda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:30 -0400
Message-Id: <20100907125056.511395595@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [patch 19/30] affs: use sema_init instead of init_MUTEX
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=afs-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org

---
 fs/affs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/affs/super.c
===================================================================
--- linux-2.6.orig/fs/affs/super.c
+++ linux-2.6/fs/affs/super.c
@@ -109,8 +109,8 @@ static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	init_MUTEX(&ei->i_link_lock);
-	init_MUTEX(&ei->i_ext_lock);
+	sema_init(&ei->i_link_lock, 1);
+	sema_init(&ei->i_ext_lock, 1);
 	inode_init_once(&ei->vfs_inode);
 }
 


