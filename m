Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081Ab2B1TqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:46:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:52203 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966056Ab2B1TqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:46:04 -0500
Message-Id: <20120228194508.418337594@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 28 Feb 2012 19:46:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 1/4] time: Remove bogus comments
References: <20120228194200.180923135@linutronix.de>
Content-Disposition: inline; filename=time-remove-bogus-comments.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no global irq lock which makes a syscall magically SMP
safe. Remove the outdated comment concerning do_settimeofday() as
well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-3.2/kernel/time.c
===================================================================
--- linux-3.2.orig/kernel/time.c
+++ linux-3.2/kernel/time.c
@@ -163,7 +163,6 @@ int do_sys_settimeofday(const struct tim
 		return error;
 
 	if (tz) {
-		/* SMP safe, global irq locking makes it work. */
 		sys_tz = *tz;
 		update_vsyscall_tz();
 		if (firsttime) {
@@ -173,12 +172,7 @@ int do_sys_settimeofday(const struct tim
 		}
 	}
 	if (tv)
-	{
-		/* SMP safe, again the code in arch/foo/time.c should
-		 * globally block out interrupts when it runs.
-		 */
 		return do_settimeofday(tv);
-	}
 	return 0;
 }
 


