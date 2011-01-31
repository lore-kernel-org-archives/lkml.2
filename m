Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1AaOHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:07:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:42514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab1AaOH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:07:28 -0500
Date: Mon, 31 Jan 2011 14:07:03 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, vapier@gentoo.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, vapier@gentoo.org,
        tglx@linutronix.de
In-Reply-To: <20110127145931.23248.33917.stgit@localhost>
References: <20110127145931.23248.33917.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] blackfin: Switch from do_timer() to xtime_update()
Message-ID: <tip-4196b892d55caaf2c98da05e80472ca482ca19fe@git.kernel.org>
Git-Commit-ID: 4196b892d55caaf2c98da05e80472ca482ca19fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4196b892d55caaf2c98da05e80472ca482ca19fe
Gitweb:     http://git.kernel.org/tip/4196b892d55caaf2c98da05e80472ca482ca19fe
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:31 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:44 +0100

blackfin: Switch from do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145931.23248.33917.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index c911361..8d73724 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -114,16 +114,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 #ifdef CONFIG_CORE_TIMER_IRQ_L1
 __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
