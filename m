Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1AaOKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:10:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:42640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab1AaOKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:10:34 -0500
Date: Mon, 31 Jan 2011 14:10:14 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, kyle@mcmartin.ca, torbenh@gmx.de,
        jejb@parisc-linux.org, tglx@linutronix.de, deller@gmx.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, jejb@parisc-linux.org, peterz@infradead.org,
        tglx@linutronix.de, deller@gmx.de, kyle@mcmartin.ca
In-Reply-To: <20110127150017.23248.22559.stgit@localhost>
References: <20110127150017.23248.22559.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] parisc: Switch do_timer() to xtime_update()
Message-ID: <tip-bb1dfc1cf6c51ca42f7c05029a6f06df9092a0fc@git.kernel.org>
Git-Commit-ID: bb1dfc1cf6c51ca42f7c05029a6f06df9092a0fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:10:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb1dfc1cf6c51ca42f7c05029a6f06df9092a0fc
Gitweb:     http://git.kernel.org/tip/bb1dfc1cf6c51ca42f7c05029a6f06df9092a0fc
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:17 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:46 +0100

parisc: Switch do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127150017.23248.22559.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/parisc/kernel/time.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..45b7389 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -162,11 +162,8 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 		update_process_times(user_mode(get_irq_regs()));
 	}
 
-	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
-		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
-	}
+	if (cpu == 0)
+		xtime_update(ticks_elapsed);
 
 	return IRQ_HANDLED;
 }
