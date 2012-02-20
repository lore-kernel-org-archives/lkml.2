Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2BTLra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:47:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2BTLr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:47:29 -0500
Date: Mon, 20 Feb 2012 03:46:19 -0800
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Message-ID: <tip-b0deca2e0270135f797e81bdb0743e50fd1dc58d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, johnstul@us.ibm.com, tglx@linutronix.de,
        sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, steiner@sgi.com, tglx@linutronix.de,
        sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20120217141641.GA28063@sgi.com>
References: <20120217141641.GA28063@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Lower UV rtc clocksource rating
Git-Commit-ID: b0deca2e0270135f797e81bdb0743e50fd1dc58d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 03:46:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0deca2e0270135f797e81bdb0743e50fd1dc58d
Gitweb:     http://git.kernel.org/tip/b0deca2e0270135f797e81bdb0743e50fd1dc58d
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Fri, 17 Feb 2012 08:16:41 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 20 Feb 2012 09:07:56 +0100

x86/UV: Lower UV rtc clocksource rating

Lower the rating of the UV rtc clocksource to just below that of
the tsc, to improve performance.

Reading the tsc clocksource has lower latency than reading the
rtc, so favor it in situations where it is synchronized and
stable.  When the tsc is unsynchronized, the rtc needs to be the
chosen clocksource.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20120217141641.GA28063@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
