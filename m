Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab0JLPuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:50:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:40103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0JLPun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:50:43 -0400
Date: Tue, 12 Oct 2010 15:50:27 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.269142443@linutronix.de>
References: <20100907125055.269142443@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hamradio: 6pack: semaphore cleanup
Message-ID: <tip-89d9f10d0b21268d3dba33db984ab03092861700@git.kernel.org>
Git-Commit-ID: 89d9f10d0b21268d3dba33db984ab03092861700
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:50:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89d9f10d0b21268d3dba33db984ab03092861700
Gitweb:     http://git.kernel.org/tip/89d9f10d0b21268d3dba33db984ab03092861700
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:08 +0200

hamradio: 6pack: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <20100907125055.269142443@linutronix.de>

---
 drivers/net/hamradio/6pack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 4b52c76..3e5d0b6 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -608,7 +608,7 @@ static int sixpack_open(struct tty_struct *tty)
 
 	spin_lock_init(&sp->lock);
 	atomic_set(&sp->refcnt, 1);
-	init_MUTEX_LOCKED(&sp->dead_sem);
+	sema_init(&sp->dead_sem, 0);
 
 	/* !!! length of the buffers. MTU is IP MTU, not PACLEN!  */
 
