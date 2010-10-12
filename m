Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0JLPvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab0JLPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:51:05 -0400
Date: Tue, 12 Oct 2010 15:50:49 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.368389976@linutronix.de>
References: <20100907125055.368389976@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hamradio: Mkiss: semaphore cleanup
Message-ID: <tip-495e64bddeb9349395ed346177057fff7d52857e@git.kernel.org>
Git-Commit-ID: 495e64bddeb9349395ed346177057fff7d52857e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:50:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  495e64bddeb9349395ed346177057fff7d52857e
Gitweb:     http://git.kernel.org/tip/495e64bddeb9349395ed346177057fff7d52857e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:09 +0200

hamradio: Mkiss: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <20100907125055.368389976@linutronix.de>

---
 drivers/net/hamradio/mkiss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 66e88bd..4c62839 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -747,7 +747,7 @@ static int mkiss_open(struct tty_struct *tty)
 
 	spin_lock_init(&ax->buflock);
 	atomic_set(&ax->refcnt, 1);
-	init_MUTEX_LOCKED(&ax->dead_sem);
+	sema_init(&ax->dead_sem, 0);
 
 	ax->tty = tty;
 	tty->disc_data = ax;
