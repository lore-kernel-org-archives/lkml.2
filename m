Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1AaOH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:07:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:42532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1AaOHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:07:54 -0500
Date: Mon, 31 Jan 2011 14:07:30 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jesper.nilsson@axis.com, peterz@infradead.org, torbenh@gmx.de,
        starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, jesper.nilsson@axis.com, peterz@infradead.org,
        starvik@axis.com, tglx@linutronix.de
In-Reply-To: <20110127145936.23248.16192.stgit@localhost>
References: <20110127145936.23248.16192.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] cris: arch-v10: Switch do_timer() to xtime_update()
Message-ID: <tip-17588b99183ece563013622afeefd37eb8e68fd3@git.kernel.org>
Git-Commit-ID: 17588b99183ece563013622afeefd37eb8e68fd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:07:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17588b99183ece563013622afeefd37eb8e68fd3
Gitweb:     http://git.kernel.org/tip/17588b99183ece563013622afeefd37eb8e68fd3
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:36 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:44 +0100

cris: arch-v10: Switch do_timer() to xtime_update()

This code failed to take the xtime_lock, which must be held when
calling do_timer(). Use the safe version xtime_update()

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145936.23248.16192.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/cris/arch-v10/kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 00eb36f..20c85b5 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -140,7 +140,7 @@ stop_watchdog(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 //static unsigned short myjiff; /* used by our debug routine print_timestamp */
@@ -176,7 +176,7 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* call the real timer interrupt handler */
 
-	do_timer(1);
+	xtime_update(1);
 	
         cris_do_profile(regs); /* Save profiling information */
         return IRQ_HANDLED;
