Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1AaOJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:09:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:42584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1AaOJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:09:14 -0500
Date: Mon, 31 Jan 2011 14:08:38 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        ysato@users.sourceforge.jp
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        ysato@users.sourceforge.jp
In-Reply-To: <20110127145951.23248.92727.stgit@localhost>
References: <20110127145951.23248.92727.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] h8300: Switch do_timer() to xtime_update()
Message-ID: <tip-daad8b581e7f5e21a2f79e49d57d4f6a73b26510@git.kernel.org>
Git-Commit-ID: daad8b581e7f5e21a2f79e49d57d4f6a73b26510
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:08:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  daad8b581e7f5e21a2f79e49d57d4f6a73b26510
Gitweb:     http://git.kernel.org/tip/daad8b581e7f5e21a2f79e49d57d4f6a73b26510
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:51 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:45 +0100

h8300: Switch do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145951.23248.92727.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/h8300/kernel/time.c         |    4 +---
 arch/h8300/kernel/timer/timer8.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..32263a1 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,7 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 3946c0f..7a1533f 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -61,7 +61,7 @@
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
