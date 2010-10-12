Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0JLPwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:40345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886Ab0JLPwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:52:43 -0400
Date: Tue, 12 Oct 2010 15:52:21 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        hch@infradead.org
In-Reply-To: <20100907125055.743613774@linutronix.de>
References: <20100907125055.743613774@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] parport: Semaphore cleanup
Message-ID: <tip-a529f1505b6facfd0078dcb18a444976c1985962@git.kernel.org>
Git-Commit-ID: a529f1505b6facfd0078dcb18a444976c1985962
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:52:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a529f1505b6facfd0078dcb18a444976c1985962
Gitweb:     http://git.kernel.org/tip/a529f1505b6facfd0078dcb18a444976c1985962
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:10 +0200

parport: Semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
LKML-Reference: <20100907125055.743613774@linutronix.de>

---
 drivers/parport/share.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index dffa5d4..a2d9d1e 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -306,7 +306,7 @@ struct parport *parport_register_port(unsigned long base, int irq, int dma,
 	spin_lock_init(&tmp->pardevice_lock);
 	tmp->ieee1284.mode = IEEE1284_MODE_COMPAT;
 	tmp->ieee1284.phase = IEEE1284_PH_FWD_IDLE;
-	init_MUTEX_LOCKED (&tmp->ieee1284.irq); /* actually a semaphore at 0 */
+	sema_init(&tmp->ieee1284.irq, 0);
 	tmp->spintime = parport_default_spintime;
 	atomic_set (&tmp->ref_count, 1);
 	INIT_LIST_HEAD(&tmp->full_list);
