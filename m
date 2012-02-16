Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2BPUKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:10:47 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36654 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753584Ab2BPUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:10:46 -0500
Date: Thu, 16 Feb 2012 14:10:42 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <johnstul@us.ibm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86 uv: lower UV rtc clocksource rating
Message-ID: <20120216201042.GA10260@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lower the rating of the UV rtc clocksource to just below that of the tsc.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/platform/uv/uv_time.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux/arch/x86/platform/uv/uv_time.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_time.c
+++ linux/arch/x86/platform/uv/uv_time.c
@@ -37,7 +37,7 @@ static void uv_rtc_timer_setup(enum cloc
 
 static struct clocksource clocksource_uv = {
 	.name		= RTC_NAME,
-	.rating		= 400,
+	.rating		= 299,
 	.read		= uv_read_rtc,
 	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
@@ -379,10 +379,6 @@ static __init int uv_rtc_setup_clock(voi
 	if (!is_uv_system())
 		return -ENODEV;
 
-	/* If single blade, prefer tsc */
-	if (uv_num_possible_blades() == 1)
-		clocksource_uv.rating = 250;
-
 	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
