Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1ETRwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:52:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:48604 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ETRwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:52:36 -0400
Date: Fri, 20 May 2011 19:52:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes
Message-ID: <alpine.LFD.2.02.1105201951150.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (2):
      clockevents/source: Use u64 to make 32bit happy
      MAINTAINERS: Add drivers/clocksource to TIMEKEEPING


 MAINTAINERS               |    1 +
 kernel/time/clockevents.c |    2 +-
 kernel/time/clocksource.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8df8d2d..e20c974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5431,6 +5431,7 @@ F:	include/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
+F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 22a9da9..c027d4f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -197,7 +197,7 @@ EXPORT_SYMBOL_GPL(clockevents_register_device);
 static void clockevents_config(struct clock_event_device *dev,
 			       u32 freq)
 {
-	unsigned long sec;
+	u64 sec;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
 		return;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index d9d5f8c..1c95fd6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -639,7 +639,7 @@ static void clocksource_enqueue(struct clocksource *cs)
  */
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
-	unsigned long sec;
+	u64 sec;
 
 	/*
 	 * Calc the maximum number of seconds which we can run before
