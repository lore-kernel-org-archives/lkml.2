Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1AaOHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:07:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:46553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab1AaOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:07:07 -0500
Date: Mon, 31 Jan 2011 14:06:39 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, linux@arm.linux.org.uk, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, linux@arm.linux.org.uk, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20110127145926.23248.56369.stgit@localhost>
References: <20110127145926.23248.56369.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] arm/mach-clps711x: Switch do_timer() to xtime_update()
Message-ID: <tip-ec2dff2febf19ff2109c2eb3e56d5a969fe399e2@git.kernel.org>
Git-Commit-ID: ec2dff2febf19ff2109c2eb3e56d5a969fe399e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec2dff2febf19ff2109c2eb3e56d5a969fe399e2
Gitweb:     http://git.kernel.org/tip/ec2dff2febf19ff2109c2eb3e56d5a969fe399e2
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:26 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:44 +0100

arm/mach-clps711x: Switch do_timer() to xtime_update()

do_timer() requires holding the xtime_lock, which this
code did not do. Use the safe version xtime_update()

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145926.23248.56369.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-clps711x/include/mach/time.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 8fe283c..61fef91 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -30,7 +30,7 @@ p720t_timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
-	do_timer(1);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
