Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2BKXHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:07:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2BKXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:07:37 -0500
Date: Sat, 11 Feb 2012 15:07:25 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgRmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=" 
	<fernando@oss.ntt.co.jp>
Message-ID: <tip-5f329089431aac08bf759fa2bcb34077a6aa1f4e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1328827342-6253-2-git-send-email-dzickus@redhat.com>
References: <1328827342-6253-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Update Kconfig entries
Git-Commit-ID: 5f329089431aac08bf759fa2bcb34077a6aa1f4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 11 Feb 2012 15:07:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f329089431aac08bf759fa2bcb34077a6aa1f4e
Gitweb:     http://git.kernel.org/tip/5f329089431aac08bf759fa2bcb34077a6aa1f4e
Author:     Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
AuthorDate: Thu, 9 Feb 2012 17:42:21 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Feb 2012 15:11:30 +0100

watchdog: Update Kconfig entries

The soft and hard lockup thresholds have changed so the
corresponding Kconfig entries need to be updated accordingly.
Add a reference to  watchdog_thresh while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1328827342-6253-2-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..9739c0b 100644
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
