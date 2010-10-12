Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0JLPx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:53:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741Ab0JLPxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:53:24 -0400
Date: Tue, 12 Oct 2010 15:53:07 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org
In-Reply-To: <20100907125057.179587334@linutronix.de>
References: <20100907125057.179587334@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] printk: Make console_sem a semaphore not a pseudo mutex
Message-ID: <tip-5b8c4f23c54edda640a4850bc9b81dee70acb525@git.kernel.org>
Git-Commit-ID: 5b8c4f23c54edda640a4850bc9b81dee70acb525
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:53:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b8c4f23c54edda640a4850bc9b81dee70acb525
Gitweb:     http://git.kernel.org/tip/5b8c4f23c54edda640a4850bc9b81dee70acb525
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:33:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:10 +0200

printk: Make console_sem a semaphore not a pseudo mutex

It needs to be investigated whether it can be replaced by a real
mutex, but that needs more thought.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
LKML-Reference: <20100907125057.179587334@linutronix.de>

---
 kernel/printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..2531017 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DECLARE_MUTEX(console_sem);
+static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -556,7 +556,7 @@ static void zap_locks(void)
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
-	init_MUTEX(&console_sem);
+	sema_init(&console_sem, 1);
 }
 
 #if defined(CONFIG_PRINTK_TIME)
