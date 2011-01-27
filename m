Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1A0O7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46030 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752235Ab1A0O71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:27 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+NS28zm1WN83D+RpsqpADvpbgq5eLul4i4y7NX/M
	ALDYALZRZ+eygE
Subject: [PATCH v2 06/20] arm: switch from do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:21 +0100
Message-ID: <20110127145920.23248.75541.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update takes the xtime_lock itself.


Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Torben Hohn <torbenh@gmx.de>
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

