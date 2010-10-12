Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab0JLPvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:40153 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0JLPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:51:29 -0400
Date: Tue, 12 Oct 2010 15:51:12 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.460765783@linutronix.de>
References: <20100907125055.460765783@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] net: Ppp_async: semaphore cleanup
Message-ID: <tip-0bce198b7688911e072bd65032ab9278b577ee93@git.kernel.org>
Git-Commit-ID: 0bce198b7688911e072bd65032ab9278b577ee93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:51:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bce198b7688911e072bd65032ab9278b577ee93
Gitweb:     http://git.kernel.org/tip/0bce198b7688911e072bd65032ab9278b577ee93
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:09 +0200

net: Ppp_async: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <20100907125055.460765783@linutronix.de>

---
 drivers/net/ppp_async.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index af50a53..78d70a6 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -184,7 +184,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
 
 	atomic_set(&ap->refcnt, 1);
-	init_MUTEX_LOCKED(&ap->dead_sem);
+	sema_init(&ap->dead_sem, 0);
 
 	ap->chan.private = ap;
 	ap->chan.ops = &async_ops;
