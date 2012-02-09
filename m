Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2BIBmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:42:21 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:37249 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2BIBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:42:19 -0500
Message-ID: <4F332475.10603@oss.ntt.co.jp>
Date: Thu, 09 Feb 2012 10:42:13 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] watchdog: update Kconfig entries
References: <4F323B21.7080003@oss.ntt.co.jp> <20120208184337.GU5650@redhat.com> <4F331AE7.40708@oss.ntt.co.jp>
In-Reply-To: <4F331AE7.40708@oss.ntt.co.jp>
Content-Type: multipart/mixed;
 boundary="------------000104040200080909020104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000104040200080909020104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Don,

Could you pick up the attached patch too?

Thanks,
Fernando

--------------000104040200080909020104
Content-Type: text/x-patch;
 name="watchdog-kconfig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="watchdog-kconfig.patch"

Subject: [PATCH] watchdog: update Kconfig entries

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

The soft and hard lockup thresholds have changed so the corresponding Kconfig
entries need to be updated accordingly. Add a reference to  watchdog_thresh
while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.2.5-orig/lib/Kconfig.debug linux-3.2.5/lib/Kconfig.debug
--- linux-3.2.5-orig/lib/Kconfig.debug	2012-01-05 08:55:44.000000000 +0900
+++ linux-3.2.5/lib/Kconfig.debug	2012-02-09 10:30:06.781625497 +0900
@@ -166,18 +166,21 @@ config LOCKUP_DETECTOR
 	  hard and soft lockups.
 
 	  Softlockups are bugs that cause the kernel to loop in kernel
-	  mode for more than 60 seconds, without giving other tasks a
+	  mode for more than 20 seconds, without giving other tasks a
 	  chance to run.  The current stack trace is displayed upon
 	  detection and the system will stay locked up.
 
 	  Hardlockups are bugs that cause the CPU to loop in kernel mode
-	  for more than 60 seconds, without letting other interrupts have a
+	  for more than 10 seconds, without letting other interrupts have a
 	  chance to run.  The current stack trace is displayed upon detection
 	  and the system will stay locked up.
 
 	  The overhead should be minimal.  A periodic hrtimer runs to
-	  generate interrupts and kick the watchdog task every 10-12 seconds.
-	  An NMI is generated every 60 seconds or so to check for hardlockups.
+	  generate interrupts and kick the watchdog task every 4 seconds.
+	  An NMI is generated every 10 seconds or so to check for hardlockups.
+
+	  The frequency of hrtimer and NMI events and the soft and hard lockup
+	  thresholds can be controlled through the sysctl watchdog_thresh.
 
 config HARDLOCKUP_DETECTOR
 	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
@@ -189,7 +192,8 @@ config BOOTPARAM_HARDLOCKUP_PANIC
 	help
 	  Say Y here to enable the kernel to panic on "hard lockups",
 	  which are bugs that cause the kernel to loop in kernel
-	  mode with interrupts disabled for more than 60 seconds.
+	  mode with interrupts disabled for more than 10 seconds (configurable
+	  using the watchdog_thresh sysctl).
 
 	  Say N if unsure.
 
@@ -206,8 +210,8 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 	help
 	  Say Y here to enable the kernel to panic on "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
-	  mode for more than 60 seconds, without giving other tasks a
-	  chance to run.
+	  mode for more than 20 seconds (configurable using the watchdog_thresh
+	  sysctl), without giving other tasks a chance to run.
 
 	  The panic can be used in combination with panic_timeout,
 	  to cause the system to reboot automatically after a

--------------000104040200080909020104--
