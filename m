Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0JLPuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:50:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0JLPuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:50:05 -0400
Date: Tue, 12 Oct 2010 15:49:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
In-Reply-To: <20100907125055.079737758@linutronix.de>
References: <20100907125055.079737758@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] input: Serio/hp_sdc: semaphore cleanup
Message-ID: <tip-4a4a506f81eebe63fb1b8e9e99f4bcd1fd9aac66@git.kernel.org>
Git-Commit-ID: 4a4a506f81eebe63fb1b8e9e99f4bcd1fd9aac66
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:49:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a4a506f81eebe63fb1b8e9e99f4bcd1fd9aac66
Gitweb:     http://git.kernel.org/tip/4a4a506f81eebe63fb1b8e9e99f4bcd1fd9aac66
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:08 +0200

input: Serio/hp_sdc: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
LKML-Reference: <20100907125055.079737758@linutronix.de>

---
 drivers/input/serio/hp_sdc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index bcc2d30..8c0b51c 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -905,7 +905,7 @@ static int __init hp_sdc_init(void)
 	ts_sync[1]	= 0x0f;
 	ts_sync[2] = ts_sync[3]	= ts_sync[4] = ts_sync[5] = 0;
 	t_sync.act.semaphore = &s_sync;
-	init_MUTEX_LOCKED(&s_sync);
+	sema_init(&s_sync, 0);
 	hp_sdc_enqueue_transaction(&t_sync);
 	down(&s_sync); /* Wait for t_sync to complete */
 
@@ -1039,7 +1039,7 @@ static int __init hp_sdc_register(void)
 		return hp_sdc.dev_err;
 	}
 
-	init_MUTEX_LOCKED(&tq_init_sem);
+	sema_init(&tq_init_sem, 0);
 
 	tq_init.actidx		= 0;
 	tq_init.idx		= 1;
