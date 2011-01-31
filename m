Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1AaOGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:06:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:46540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1AaOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:06:50 -0500
Date: Mon, 31 Jan 2011 14:06:18 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, linux@arm.linux.org.uk, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, linux@arm.linux.org.uk, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20110127145920.23248.75541.stgit@localhost>
References: <20110127145920.23248.75541.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] arm: Switch from do_timer() to xtime_update()
Message-ID: <tip-6906e33cc555c390cd091f6f363b783322dfedf6@git.kernel.org>
Git-Commit-ID: 6906e33cc555c390cd091f6f363b783322dfedf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:06:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6906e33cc555c390cd091f6f363b783322dfedf6
Gitweb:     http://git.kernel.org/tip/6906e33cc555c390cd091f6f363b783322dfedf6
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:21 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:43 +0100

arm: Switch from do_timer() to xtime_update()

xtime_update takes the xtime_lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145920.23248.75541.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/time.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 3d76bf2..1ff46ca 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -107,9 +107,7 @@ void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
 	do_leds();
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
