Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032304Ab2CSR3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:29:04 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:44153 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030441Ab2CSR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:29:01 -0400
Date: Mon, 19 Mar 2012 18:28:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv change for v3.4
Message-ID: <20120319172857.GA16633@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   HEAD: b0deca2e0270135f797e81bdb0743e50fd1dc58d x86/UV: Lower UV rtc clocksource rating

 Thanks,

	Ingo

------------------>
Dimitri Sivanich (1):
      x86/UV: Lower UV rtc clocksource rating


 arch/x86/platform/uv/uv_time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 9f29a01..5032e0d 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -37,7 +37,7 @@ static void uv_rtc_timer_setup(enum clock_event_mode,
 
 static struct clocksource clocksource_uv = {
 	.name		= RTC_NAME,
-	.rating		= 400,
+	.rating		= 299,
 	.read		= uv_read_rtc,
 	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
@@ -379,10 +379,6 @@ static __init int uv_rtc_setup_clock(void)
 	if (!is_uv_system())
 		return -ENODEV;
 
-	/* If single blade, prefer tsc */
-	if (uv_num_possible_blades() == 1)
-		clocksource_uv.rating = 250;
-
 	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
