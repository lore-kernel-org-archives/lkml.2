Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1AaOIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:08:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:42550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1AaOIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:08:15 -0500
Date: Mon, 31 Jan 2011 14:07:53 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jesper.nilsson@axis.com, peterz@infradead.org, torbenh@gmx.de,
        starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, jesper.nilsson@axis.com, peterz@infradead.org,
        starvik@axis.com, tglx@linutronix.de
In-Reply-To: <20110127145941.23248.92547.stgit@localhost>
References: <20110127145941.23248.92547.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] cris: arch-v32: Switch do_timer() to xtime_update()
Message-ID: <tip-36cb07bb8118cb14211ef25c58026f005877c47d@git.kernel.org>
Git-Commit-ID: 36cb07bb8118cb14211ef25c58026f005877c47d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36cb07bb8118cb14211ef25c58026f005877c47d
Gitweb:     http://git.kernel.org/tip/36cb07bb8118cb14211ef25c58026f005877c47d
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:44 +0100

cris: arch-v32: Switch do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145941.23248.92547.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/cris/arch-v32/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index a545211..bb978ed 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -183,7 +183,7 @@ void handle_watchdog_bite(struct pt_regs *regs)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick.
+ * as well as call the "xtime_update()" routine every clocktick.
  */
 extern void cris_do_profile(struct pt_regs *regs);
 
@@ -216,9 +216,7 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	/* Call the real timer interrupt handler */
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
         return IRQ_HANDLED;
 }
 
