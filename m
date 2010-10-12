Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0JLPyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:54:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:40446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab0JLPy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:54:29 -0400
Date: Tue, 12 Oct 2010 15:54:13 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        hch@infradead.org
In-Reply-To: <20100907125056.511395595@linutronix.de>
References: <20100907125056.511395595@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] affs: Use sema_init instead of init_MUTEX
Message-ID: <tip-756b0322e50aebc4b9afb4488a2d3f6c802b4e64@git.kernel.org>
Git-Commit-ID: 756b0322e50aebc4b9afb4488a2d3f6c802b4e64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:54:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  756b0322e50aebc4b9afb4488a2d3f6c802b4e64
Gitweb:     http://git.kernel.org/tip/756b0322e50aebc4b9afb4488a2d3f6c802b4e64
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:33:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:39:25 +0200

affs: Use sema_init instead of init_MUTEX

Get rid of init_MUTE() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
LKML-Reference: <20100907125056.511395595@linutronix.de>
---
 fs/affs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 33c4e7e..9581ea9 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -109,8 +109,8 @@ static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	init_MUTEX(&ei->i_link_lock);
-	init_MUTEX(&ei->i_ext_lock);
+	sema_init(&ei->i_link_lock, 1);
+	sema_init(&ei->i_ext_lock, 1);
 	inode_init_once(&ei->vfs_inode);
 }
 
