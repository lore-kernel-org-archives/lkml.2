Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0JLPto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:49:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab0JLPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:49:43 -0400
Date: Tue, 12 Oct 2010 15:49:22 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
In-Reply-To: <20100907125054.985090435@linutronix.de>
References: <20100907125054.985090435@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] input: Serio/hil_mlc: semaphore cleanup
Message-ID: <tip-45e8492f594dcb17e8cbb26edb2dd3018a68dada@git.kernel.org>
Git-Commit-ID: 45e8492f594dcb17e8cbb26edb2dd3018a68dada
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:49:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45e8492f594dcb17e8cbb26edb2dd3018a68dada
Gitweb:     http://git.kernel.org/tip/45e8492f594dcb17e8cbb26edb2dd3018a68dada
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:08 +0200

input: Serio/hil_mlc: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
LKML-Reference: <20100907125054.985090435@linutronix.de>

---
 drivers/input/serio/hil_mlc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index c92f4ed..e5624d8 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -915,15 +915,15 @@ int hil_mlc_register(hil_mlc *mlc)
 	mlc->ostarted = 0;
 
 	rwlock_init(&mlc->lock);
-	init_MUTEX(&mlc->osem);
+	sema_init(&mlc->osem, 1);
 
-	init_MUTEX(&mlc->isem);
+	sema_init(&mlc->isem, 1);
 	mlc->icount = -1;
 	mlc->imatch = 0;
 
 	mlc->opercnt = 0;
 
-	init_MUTEX_LOCKED(&(mlc->csem));
+	sema_init(&(mlc->csem), 0);
 
 	hil_mlc_clear_di_scratch(mlc);
 	hil_mlc_clear_di_map(mlc, 0);
