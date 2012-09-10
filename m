Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2IJLyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:54:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54654 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2IJLyM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 10 Sep 2012 07:54:12 -0400
Message-Id: <504DF0FF020000780009A28E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 12:54:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>
Cc: <a.p.zijlstra@chello.nl>, <dzickus@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust hard-lockup related Kconfig options
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main option should not appear in the resulting .config when the
dependencies aren't met (i.e. use "depends on" rather than directly
setting the default from the combined dependency values).

The sub-options should depend on the main option rather than a more
generic higher level one.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 lib/Kconfig.debug |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- 3.6-rc5/lib/Kconfig.debug
+++ 3.6-rc5-kconfig-cleanup-hardlockup/lib/Kconfig.debug
@@ -196,12 +196,13 @@ config LOCKUP_DETECTOR
 	  thresholds can be controlled through the sysctl watchdog_thresh.
 
 config HARDLOCKUP_DETECTOR
-	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
-		 !HAVE_NMI_WATCHDOG
+	def_bool y
+	depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
+	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
-	depends on LOCKUP_DETECTOR
+	depends on HARDLOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to panic on "hard lockups",
 	  which are bugs that cause the kernel to loop in kernel
@@ -212,7 +213,7 @@ config BOOTPARAM_HARDLOCKUP_PANIC
 
 config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
 	int
-	depends on LOCKUP_DETECTOR
+	depends on HARDLOCKUP_DETECTOR
 	range 0 1
 	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
 	default 1 if BOOTPARAM_HARDLOCKUP_PANIC



