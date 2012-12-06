Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423353Ab2LFMRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:17:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:51641 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2LFMRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:17:13 -0500
Date: Thu, 6 Dec 2012 13:17:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] core regression fix for 3.7
Message-ID: <alpine.LFD.2.02.1212061311190.2701@ionos>
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

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

* Trivial CPU hotplug regression fix for the watchdog code.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      watchdog: Fix CPU hotplug regression


 kernel/watchdog.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dd4b80a..c8c21be 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	if (!watchdog_enabled)
+		return;
+
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
