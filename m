Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3AGQWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:22:47 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52671 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab3AGQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:22:46 -0500
Date: Mon, 7 Jan 2013 08:22:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/7] consolidate RCU debugging Kconfig options
Message-ID: <20130107162223.GC2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
 <20121214184204.B7F1D3E9@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214184204.B7F1D3E9@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010716-7182-0000-0000-0000043C47AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 01:42:05PM -0500, Dave Hansen wrote:
> 
> These were in two different places, and taking up too much of my
> valuable screen real-estate.  Banish them to their own menu.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/lib/Kconfig.debug |  160 +++++++++++++++++------------------
>  1 file changed, 82 insertions(+), 78 deletions(-)

Hello, Dave,

There have been enough changes that the patch refused to apply, so
I forward-ported it as follows and queued it for 3.9.  Please let me
know if there are any problems with the result, shown below.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Consolidate debugging Kconfig options

The RCU-related debugging Kconfig options are in two different places,
and consume too much screen real estate.  This commit therefore
consolidates them into their own menu.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a40a36b..ce75d3b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -605,61 +605,6 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
-config PROVE_RCU
-	bool "RCU debugging: prove RCU correctness"
-	depends on PROVE_LOCKING
-	default n
-	help
-	 This feature enables lockdep extensions that check for correct
-	 use of RCU APIs.  This is currently under development.  Say Y
-	 if you want to debug RCU usage or help work on the PROVE_RCU
-	 feature.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_REPEATEDLY
-	bool "RCU debugging: don't disable PROVE_RCU on first splat"
-	depends on PROVE_RCU
-	default n
-	help
-	 By itself, PROVE_RCU will disable checking upon issuing the
-	 first warning (or "splat").  This feature prevents such
-	 disabling, allowing multiple RCU-lockdep warnings to be printed
-	 on a single reboot.
-
-	 Say Y to allow multiple RCU-lockdep warnings per boot.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_DELAY
-	bool "RCU debugging: preemptible RCU race provocation"
-	depends on DEBUG_KERNEL && PREEMPT_RCU
-	default n
-	help
-	 There is a class of races that involve an unlikely preemption
-	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
-	 been set to INT_MIN.  This feature inserts a delay at that
-	 point to increase the probability of these races.
-
-	 Say Y to increase probability of preemption of __rcu_read_unlock().
-
-	 Say N if you are unsure.
-
-config SPARSE_RCU_POINTER
-	bool "RCU debugging: sparse-based checks for pointer usage"
-	default n
-	help
-	 This feature enables the __rcu sparse annotation for
-	 RCU-protected pointers.  This annotation will cause sparse
-	 to flag any non-RCU used of annotated pointers.  This can be
-	 helpful when debugging RCU usage.  Please note that this feature
-	 is not intended to enforce code cleanliness; it is instead merely
-	 a debugging aid.
-
-	 Say Y to make sparse flag questionable use of RCU-protected pointers
-
-	 Say N if you are unsure.
-
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -937,6 +882,63 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
+menu "RCU Debugging"
+
+config PROVE_RCU
+	bool "RCU debugging: prove RCU correctness"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature enables lockdep extensions that check for correct
+	 use of RCU APIs.  This is currently under development.  Say Y
+	 if you want to debug RCU usage or help work on the PROVE_RCU
+	 feature.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_REPEATEDLY
+	bool "RCU debugging: don't disable PROVE_RCU on first splat"
+	depends on PROVE_RCU
+	default n
+	help
+	 By itself, PROVE_RCU will disable checking upon issuing the
+	 first warning (or "splat").  This feature prevents such
+	 disabling, allowing multiple RCU-lockdep warnings to be printed
+	 on a single reboot.
+
+	 Say Y to allow multiple RCU-lockdep warnings per boot.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_DELAY
+	bool "RCU debugging: preemptible RCU race provocation"
+	depends on DEBUG_KERNEL && PREEMPT_RCU
+	default n
+	help
+	 There is a class of races that involve an unlikely preemption
+	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
+	 been set to INT_MIN.  This feature inserts a delay at that
+	 point to increase the probability of these races.
+
+	 Say Y to increase probability of preemption of __rcu_read_unlock().
+
+	 Say N if you are unsure.
+
+config SPARSE_RCU_POINTER
+	bool "RCU debugging: sparse-based checks for pointer usage"
+	default n
+	help
+	 This feature enables the __rcu sparse annotation for
+	 RCU-protected pointers.  This annotation will cause sparse
+	 to flag any non-RCU used of annotated pointers.  This can be
+	 helpful when debugging RCU usage.  Please note that this feature
+	 is not intended to enforce code cleanliness; it is instead merely
+	 a debugging aid.
+
+	 Say Y to make sparse flag questionable use of RCU-protected pointers
+
+	 Say N if you are unsure.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
@@ -1015,6 +1017,8 @@ config RCU_TRACE
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
 
+endmenu # "RCU Debugging"
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL

