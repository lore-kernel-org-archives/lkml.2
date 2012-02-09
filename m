Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab2BIWmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab2BIWmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:42:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] watchdog: update Kconfig entries
Date: Thu,  9 Feb 2012 17:42:21 -0500
Message-Id: <1328827342-6253-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
References: <1328827342-6253-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>

The soft and hard lockup thresholds have changed so the corresponding Kconfig
entries need to be updated accordingly. Add a reference to  watchdog_thresh
while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 lib/Kconfig.debug |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 63696aa..1e37364 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
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
-- 
1.7.7.6

