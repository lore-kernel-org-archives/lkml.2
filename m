Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1LSOHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:07:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1LSOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:07:30 -0500
Date: Mon, 19 Dec 2011 06:06:52 -0800
From: tip-bot for Kusanagi Kouichi <slash@ac.auone-net.jp>
Message-ID: <tip-b1b73d095084e754562961c443aa8f6587a55f8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, slash@ac.auone-net.jp, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        slash@ac.auone-net.jp, johnstul@us.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111219091320.0D5AF6FC03D@msa105.auone-net.jp>
References: <20111219091320.0D5AF6FC03D@msa105.auone-net.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time/clocksource: Fix kernel-doc warnings
Git-Commit-ID: b1b73d095084e754562961c443aa8f6587a55f8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 06:06:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1b73d095084e754562961c443aa8f6587a55f8e
Gitweb:     http://git.kernel.org/tip/b1b73d095084e754562961c443aa8f6587a55f8e
Author:     Kusanagi Kouichi <slash@ac.auone-net.jp>
AuthorDate: Mon, 19 Dec 2011 18:13:19 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Dec 2011 11:41:40 +0100

time/clocksource: Fix kernel-doc warnings

Fix various KernelDoc build warnings.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20111219091320.0D5AF6FC03D@msa105.auone-net.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/clocksource.h |   11 ++++++++---
 kernel/time/clocksource.c   |   12 +++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c86c940..081147d 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -71,7 +71,7 @@ struct timecounter {
 
 /**
  * cyclecounter_cyc2ns - converts cycle counter cycles to nanoseconds
- * @tc:		Pointer to cycle counter.
+ * @cc:		Pointer to cycle counter.
  * @cycles:	Cycles
  *
  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
@@ -114,7 +114,7 @@ extern u64 timecounter_read(struct timecounter *tc);
  *                        time base as values returned by
  *                        timecounter_read()
  * @tc:		Pointer to time counter.
- * @cycle:	a value returned by tc->cc->read()
+ * @cycle_tstamp:	a value returned by tc->cc->read()
  *
  * Cycle counts that are converted correctly as long as they
  * fall into the interval [-1/2 max cycle count, +1/2 max cycle count],
@@ -156,11 +156,12 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
- * @maxadj		maximum adjustment value to mult (~11%)
+ * @maxadj:		maximum adjustment value to mult (~11%)
  * @flags:		flags describing special properties
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
+ * @cycle_last:		most recent cycle counter value seen by ::read()
  */
 struct clocksource {
 	/*
@@ -187,6 +188,7 @@ struct clocksource {
 	void (*suspend)(struct clocksource *cs);
 	void (*resume)(struct clocksource *cs);
 
+	/* private: */
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
@@ -261,6 +263,9 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 
 /**
  * clocksource_cyc2ns - converts clocksource cycles to nanoseconds
+ * @cycles:	cycles
+ * @mult:	cycle to nanosecond multiplier
+ * @shift:	cycle to nanosecond divisor (power of two)
  *
  * Converts cycles to nanoseconds, using the given mult and shift.
  *
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index da2f760..d3ad022 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -647,7 +647,7 @@ static void clocksource_enqueue(struct clocksource *cs)
 
 /**
  * __clocksource_updatefreq_scale - Used update clocksource with new freq
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
@@ -699,7 +699,7 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 
 /**
  * __clocksource_register_scale - Used to install new clocksources
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
@@ -727,7 +727,7 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
 
 /**
  * clocksource_register - Used to install new clocksources
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  *
  * Returns -EBUSY if registration fails, zero otherwise.
  */
@@ -761,6 +761,8 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating)
 
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
+ * @cs:		clocksource to be changed
+ * @rating:	new rating
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
@@ -772,6 +774,7 @@ EXPORT_SYMBOL(clocksource_change_rating);
 
 /**
  * clocksource_unregister - remove a registered clocksource
+ * @cs:	clocksource to be unregistered
  */
 void clocksource_unregister(struct clocksource *cs)
 {
@@ -787,6 +790,7 @@ EXPORT_SYMBOL(clocksource_unregister);
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
  * Provides sysfs interface for listing current clocksource.
@@ -807,6 +811,7 @@ sysfs_show_current_clocksources(struct sys_device *dev,
 /**
  * sysfs_override_clocksource - interface for manually overriding clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	name of override clocksource
  * @count:	length of buffer
  *
@@ -842,6 +847,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 /**
  * sysfs_show_available_clocksources - sysfs interface for listing clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
  * Provides sysfs interface for listing registered clocksources
