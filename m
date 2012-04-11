Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2DKUBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab2DKUBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:01:46 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Fix CONFIG_CLOCKSOURCE_WATCHDOG=n compile
Date: Wed, 11 Apr 2012 16:01:20 -0400
Message-Id: <1334174480-16331-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this while debugging -- compile fails with

arch/x86/built-in.o: In function `mark_tsc_unstable':
/home/linux-2.6/arch/x86/kernel/tsc.c:791: undefined reference to
`clocksource_mark_unstable'
make: *** [.tmp_vmlinux1] Error 1

Add in an empty function for the !CONFIG_CLOCKSOURCE_WATCHDOG case.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index fbe89e1..dac8f91 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -285,7 +285,13 @@ extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 extern void clocksource_mark_unstable(struct clocksource *cs);
+#else
+static inline void clocksource_mark_unstable(struct clocksource *cs)
+{
+}
+#endif
 
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
-- 
1.7.1

