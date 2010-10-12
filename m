Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0JLPtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:49:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab0JLPtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:49:32 -0400
Date: Tue, 12 Oct 2010 15:49:00 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dtor@mail.ru, tglx@linutronix.de,
        hch@infradead.org
In-Reply-To: <20100907125054.888438853@linutronix.de>
References: <20100907125054.888438853@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] input: Misc/hp_sdc_rtc: semaphore cleanup
Message-ID: <tip-10d0ff83078d5ef99aaf94a2aaceb740f5ced923@git.kernel.org>
Git-Commit-ID: 10d0ff83078d5ef99aaf94a2aaceb740f5ced923
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:49:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10d0ff83078d5ef99aaf94a2aaceb740f5ced923
Gitweb:     http://git.kernel.org/tip/10d0ff83078d5ef99aaf94a2aaceb740f5ced923
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:31:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:07 +0200

input: Misc/hp_sdc_rtc: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
LKML-Reference: <20100907125054.888438853@linutronix.de>

---
 drivers/input/misc/hp_sdc_rtc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index c190664..7e2c12a 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -104,7 +104,7 @@ static int hp_sdc_rtc_do_read_bbrtc (struct rtc_time *rtctm)
 	t.endidx =		91;
 	t.seq =			tseq;
 	t.act.semaphore =	&tsem;
-	init_MUTEX_LOCKED(&tsem);
+	sema_init(&tsem, 0);
 	
 	if (hp_sdc_enqueue_transaction(&t)) return -1;
 	
@@ -698,7 +698,7 @@ static int __init hp_sdc_rtc_init(void)
 		return -ENODEV;
 #endif
 
-	init_MUTEX(&i8042tregs);
+	sema_init(&i8042tregs, 1);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;
