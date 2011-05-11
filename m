Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1EKUS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:18:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37401 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1EKUSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:18:55 -0400
Date: Wed, 11 May 2011 13:18:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110511201852.GC2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110508151848.GA21906@linux.vnet.ibm.com>
 <20110509073636.GA18247@elte.hu>
 <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
 <20110510085623.GG2258@linux.vnet.ibm.com>
 <4DC97E49.7040401@kernel.org>
 <20110510193216.GN2258@linux.vnet.ibm.com>
 <4DC9A5A4.1050308@kernel.org>
 <20110511045443.GS2258@linux.vnet.ibm.com>
 <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:56:35AM -0700, Yinghai Lu wrote:
> On Tue, May 10, 2011 at 9:54 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, May 10, 2011 at 01:52:52PM -0700, Yinghai Lu wrote:
> >> On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
> >> > On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
> >> >> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
> >> >>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
> >> >>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >>>>>
> >> >>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >> >>>>>
> >> >>>>>> Hello, Ingo,
> >> >>>>>>
> >> >>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
> >> >>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
> >> >>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
> >> >>>>>> of the commits.  There are a number of smaller features and bug fixes.
> >> >>>>>> All have been sent to LKML in the following batches:
> >> >>>>>>
> >> >>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
> >> >>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
> >> >>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
> >> >>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
> >> >>>>>>
> >> >>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
> >> >>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
> >> >>>>>> Acked-by:s, and I will deal with these later.
> >> >>>>>>
> >> >>>>>> These channges are available in the -rcu git repository at:
> >> >>>>>>
> >> >>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> >> >>>>>
> >> >>>>> Pulled, thanks a lot Paul!
> >> >>>>>
> >> >>>>
> >> >>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
> >> >>>>
> >> >>>> after hard code to enable rcu_cpu_stall_suppress
> >> >>>>
> >> >>>> Index: linux-2.6/kernel/rcutree.c
> >> >>>> ===================================================================
> >> >>>> --- linux-2.6.orig/kernel/rcutree.c
> >> >>>> +++ linux-2.6/kernel/rcutree.c
> >> >>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
> >> >>>>  module_param(qhimark, int, 0);
> >> >>>>  module_param(qlowmark, int, 0);
> >> >>>>
> >> >>>> -int rcu_cpu_stall_suppress __read_mostly;
> >> >>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
> >> >>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
> >> >>>>
> >> >>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
> >> >>>>
> >> >>>> will get system hang after pnp ACPI init.
> >> >>>
> >> >>> Could you please send the stack traces from the RCU CPU stall?  Also,
> >> >>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
> >> >>>
> >> >>>                                                   Thanx, Paul
> >> >>
> >> >> Do not have time to bisect it at this point.
> >> >
> >> > Could you please send the stack traces from the RCU CPU stall?
> >
> > Thank you!  OK, so CPU 0 has not been responding, despite resched IPIs.
> > Everyone is idle, except for CPU 124, which detected the stall, and
> > possibly CPU 0, which has csum_partial_copy_generic() on the stack, though
> > that looks like a backtrace error to me.  The fact that it hangs if you
> > disable RCU CPU stall detection leads me to believe that something real
> > is being detected.
> 
> the problem is that now I can not disable RCU CPU stall detection any more.

There is a rcu_cpu_stall_suppress module parameter, and you should be
able to pass in rcu_cpu_stall_suppress=1 as a boot parameter.  However,
I did produce a patch that reverts the change, please see below.
I would be surprised if this did anything different than your change
that initializes rcu_cpu_stall_suppress to 1.  If this patch somehow
does make a difference, please let me know.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 1d7a885..71b6f50 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -21,7 +21,7 @@ rcu.txt
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 stallwarn.txt
-	- RCU CPU stall warnings (module parameter rcu_cpu_stall_suppress)
+	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 4e95920..862c08e 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -1,25 +1,22 @@
 Using RCU's CPU Stall Detector
 
-The rcu_cpu_stall_suppress module parameter enables RCU's CPU stall
-detector, which detects conditions that unduly delay RCU grace periods.
-This module parameter enables CPU stall detection by default, but
-may be overridden via boot-time parameter or at runtime via sysfs.
-The stall detector's idea of what constitutes "unduly delayed" is
-controlled by a set of kernel configuration variables and cpp macros:
+The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
+RCU's CPU stall detector, which detects conditions that unduly delay
+RCU grace periods.  The stall detector's idea of what constitutes
+"unduly delayed" is controlled by a set of C preprocessor macros:
 
-CONFIG_RCU_CPU_STALL_TIMEOUT
+RCU_SECONDS_TILL_STALL_CHECK
 
-	This kernel configuration parameter defines the period of time
-	that RCU will wait from the beginning of a grace period until it
-	issues an RCU CPU stall warning.  This time period is normally
-	ten seconds.
+	This macro defines the period of time that RCU will wait from
+	the beginning of a grace period until it issues an RCU CPU
+	stall warning.	This time period is normally ten seconds.
 
 RCU_SECONDS_TILL_STALL_RECHECK
 
 	This macro defines the period of time that RCU will wait after
 	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to three
-	times the check interval plus thirty seconds.
+	for the same stall.  This time period is normally set to thirty
+	seconds.
 
 RCU_STALL_RAT_DELAY
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 86f44a3..2e8fbed 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -174,8 +174,10 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-int rcu_cpu_stall_suppress __read_mostly;
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
 module_param(rcu_cpu_stall_suppress, int, 0644);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -497,6 +499,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -635,6 +639,26 @@ static void __init check_cpu_stall_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
 }
 
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+}
+
+void rcu_cpu_stall_reset(void)
+{
+}
+
+static void __init check_cpu_stall_init(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 93d4a1c..c8e5bf4 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -317,6 +317,7 @@ struct rcu_data {
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA	       (5 * HZ)
@@ -334,6 +335,13 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
+#define RCU_CPU_STALL_SUPPRESS_INIT 0
+#else
+#define RCU_CPU_STALL_SUPPRESS_INIT 1
+#endif
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -382,8 +390,10 @@ struct rcu_state {
 						/*  due to no GP active. */
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	char *name;				/* Name of structure. */
@@ -421,9 +431,11 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed339702..f77bc10 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -54,6 +54,10 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
+#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO
+	       "\tRCU-based detection of stalled CPUs is disabled.\n");
+#endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
@@ -398,6 +402,8 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
@@ -466,6 +472,8 @@ static void rcu_preempt_stall_reset(void)
 	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /*
  * Check that the list of blocked tasks for the newly completed grace
  * period is in fact empty.  It is a serious bug to complete a grace
@@ -922,6 +930,8 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
 /*
  * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
@@ -946,6 +956,8 @@ static void rcu_preempt_stall_reset(void)
 {
 }
 
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /*
  * Because there is no preemptible RCU, there can be no readers blocked,
  * so there is no need to check for blocked tasks.  So check only for
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3aa2780..a863e35 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -875,9 +875,22 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	default y
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say N if you want to disable such checks.
+
+	  Say Y if you are unsure.
+
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on RCU_CPU_STALL_DETECTOR
 	range 3 300
 	default 60
 	help
@@ -886,9 +899,22 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
+config RCU_CPU_STALL_DETECTOR_RUNNABLE
+	bool "RCU CPU stall checking starts automatically at boot"
+	depends on RCU_CPU_STALL_DETECTOR
+	default y
+	help
+	  If set, start checking for RCU CPU stalls immediately on
+	  boot.  Otherwise, RCU CPU stall checking must be manually
+	  enabled.
+
+	  Say Y if you are unsure.
+
+	  Say N if you wish to suppress RCU CPU stall checking during boot.
+
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on TREE_PREEMPT_RCU
+	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
 	default y
 	help
 	  This option causes RCU to printk detailed per-task information
