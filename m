Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2BIDE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:04:27 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40533 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2BIDE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:04:26 -0500
Message-ID: <4F3337B4.3010102@oss.ntt.co.jp>
Date: Thu, 09 Feb 2012 12:04:20 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] watchdog: fix code/comments mismatches
References: <4F323B21.7080003@oss.ntt.co.jp> <20120208184337.GU5650@redhat.com> <4F331AE7.40708@oss.ntt.co.jp> <4F332475.10603@oss.ntt.co.jp>
In-Reply-To: <4F332475.10603@oss.ntt.co.jp>
Content-Type: multipart/mixed;
 boundary="------------040608070507090204000308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040608070507090204000308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Don,

This is the last of the documentation fixes.
I am preparing some bug fixes now.

Thanks,
Fernando

--------------040608070507090204000308
Content-Type: text/x-patch;
 name="watchdog-ccomments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="watchdog-ccomments.patch"

Subject: [PATCH] watchdog: fix code/comments mismatches

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Reflect the change in the soft and hard lockup thresholds and their relation to
the frequency of the hrtimer and NMI events in the code comments. While at it,
remove references to files that do not exist anymore.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.2.5-orig/kernel/watchdog.c linux-3.2.5/kernel/watchdog.c
--- linux-3.2.5-orig/kernel/watchdog.c	2012-01-05 08:55:44.000000000 +0900
+++ linux-3.2.5/kernel/watchdog.c	2012-02-09 11:39:21.712084495 +0900
@@ -3,12 +3,9 @@
  *
  * started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
  *
- * this code detects hard lockups: incidents in where on a CPU
- * the kernel does not respond to anything except NMI.
- *
- * Note: Most of this code is borrowed heavily from softlockup.c,
- * so thanks to Ingo for the initial implementation.
- * Some chunks also taken from arch/x86/kernel/apic/nmi.c, thanks
+ * Note: Most of this code is borrowed heavily from the original softlockup
+ * detector, so thanks to Ingo for the initial implementation.
+ * Some chunks also taken from the old x86-specific nmi watchdog code, thanks
  * to those contributors as well.
  */
 
@@ -116,10 +113,11 @@ static unsigned long get_timestamp(int t
 static unsigned long get_sample_period(void)
 {
 	/*
-	 * convert watchdog_thresh from seconds to ns
-	 * the divide by 5 is to give hrtimer 5 chances to
-	 * increment before the hardlockup detector generates
-	 * a warning
+	 * convert watchdog_thresh from seconds to ns the
+	 * divide by 5 is to give hrtimer several chances (two
+	 * or three with the current relation between the soft
+	 * and hard thresholds) to increment before the
+	 * hardlockup detector generates a warning
 	 */
 	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
@@ -336,9 +334,11 @@ static int watchdog(void *unused)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
-	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 60 seconds then the
-	 * debug-printout triggers in watchdog_timer_fn().
+	 * Run briefly (kicked by the hrtimer callback function) once every
+	 * get_sample_period() seconds (4 seconds by default) to reset the
+	 * softlockup timestamp. If this gets delayed for more than
+	 * 2*watchdog_thresh seconds then the debug-printout triggers in
+	 * watchdog_timer_fn().
 	 */
 	while (!kthread_should_stop()) {
 		__touch_watchdog();

--------------040608070507090204000308--
