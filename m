Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1AOPVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:21:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1AOPVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:21:43 -0500
Date: Sat, 15 Jan 2011 16:21:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers fixes
Message-ID: <20110115152132.GA12447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
H Hartley Sweeten (1):
      timekeeping: Make local variables static

Nicolas Pitre (1):
      time: Rename misnamed minsec argument of clocks_calc_mult_shift()


 kernel/time/clocksource.c |    8 ++++----
 kernel/time/timekeeping.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..8588abc 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * @shift:	pointer to shift variable
  * @from:	frequency to convert from
  * @to:		frequency to convert to
- * @minsec:	guaranteed runtime conversion range in seconds
+ * @maxsec:	guaranteed runtime conversion range in seconds
  *
  * The function evaluates the shift/mult pair for the scaled math
  * operations of clocksources and clockevents.
@@ -122,7 +122,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
  * event @to is the counter frequency and @from is NSEC_PER_SEC.
  *
- * The @minsec conversion range argument controls the time frame in
+ * The @maxsec conversion range argument controls the time frame in
  * seconds which must be covered by the runtime conversion with the
  * calculated mult and shift factors. This guarantees that no 64bit
  * overflow happens when the input value of the conversion is
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * factors.
  */
 void
-clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 {
 	u64 tmp;
 	u32 sft, sftacc= 32;
@@ -140,7 +140,7 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
 	 * Calculate the shift factor which is limiting the conversion
 	 * range:
 	 */
-	tmp = ((u64)minsec * from) >> 32;
+	tmp = ((u64)maxsec * from) >> 32;
 	while (tmp) {
 		tmp >>=1;
 		sftacc--;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5bb86da..eef7452 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -49,7 +49,7 @@ struct timekeeper {
 	u32	mult;
 };
 
-struct timekeeper timekeeper;
+static struct timekeeper timekeeper;
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -164,7 +164,7 @@ static struct timespec total_sleep_time;
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
  */
-struct timespec raw_time;
+static struct timespec raw_time;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
