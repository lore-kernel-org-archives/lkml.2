Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2FMQUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:20:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40424 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2FMQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 2/7] nohz: Introduce adaptive nohz config
Date: Wed, 13 Jun 2012 18:19:52 +0200
Message-Id: <1339604397-8758-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare a config option for the full adaptive nohz feature.
This way we can start to put the related code under appropriate
ifdefs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig        |    8 ++++++++
 kernel/time/Kconfig |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8c3d957..a71c698 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -251,6 +251,14 @@ config HAVE_CMPXCHG_DOUBLE
 config ARCH_WANT_OLD_COMPAT_IPC
 	bool
 
+config HAVE_NO_HZ_FULL
+        bool
+	help
+	 An arch should select this symbols if it provides
+	 the kernel entry/exit hooks necessary to implement
+	 full tickless support. This includes syscall entry/exit,
+	 exceptions entry/exit and do_notify_resume() hooks.
+
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 0883fa1..5ac4b74 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -65,6 +65,13 @@ config NO_HZ
 	  This option enables a tickless idle system: timer interrupts will
 	  only trigger on an as-needed basis when the system is idle.
 
+config NO_HZ_FULL
+        bool "Full tickless system (Dynamic Ticks)"
+	depends on NO_HZ && HAVE_NO_HZ_FULL
+	help
+	  This option enables a full adaptive tickless system: timer
+	  interrupts will globally only trigger on an as-needed basis.
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-- 
1.7.5.4

