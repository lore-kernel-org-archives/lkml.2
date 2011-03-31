Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab1CaUCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:02:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62579 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab1CaUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=n9q4OuTAicFI0fO86Es3Vg4qLQY9UtusN0pOu9xNGRgqI0D495Yjdb02ovAx30xCg5
         MsH0SrKUO6N+DOdWIxt7zwn5tUsF1F0ac4VYZc036qvA8OE2v+0qgephmvLmWMm5qw4y
         DadqzjyOWnxzQOmNSknbh6uKXAD7YxUQ9wI6M=
MIME-Version: 1.0
Date: Fri, 1 Apr 2011 01:32:14 +0530
Message-ID: <AANLkTi=SegGu5ue=n23e1fhdoZ1jNyTardFJvtAo6vE1@mail.gmail.com>
Subject: [PATCH] kernel: Fix style problems in time.c
From: Aakash Goenka <aakash.goenka@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Jiri Kosina <jkosina@suse.cz>, Jesper Juhl <jj@chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fixes most style errors and warnings. Only left out the ones about
using include from linux directory instead of asm.
 Signed-off-by: Aakash Goenka <aakash.goenka@gmail.com>

---
 kernel/time.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8e8dc6d..0923dcf 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -48,7 +48,6 @@
  * programs who obtain this value by using gettimeofday.
  */
 struct timezone sys_tz;
-
 EXPORT_SYMBOL(sys_tz);

 #ifdef __ARCH_WANT_SYS_TIME
@@ -64,7 +63,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
 	time_t i = get_seconds();

 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			return -EFAULT;
 	}
 	force_successful_syscall_return();
@@ -172,8 +171,7 @@ int do_sys_settimeofday(const struct timespec *tv,
const struct timezone *tz)
 				warp_clock();
 		}
 	}
-	if (tv)
-	{
+	if (tv) {
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
@@ -212,7 +210,7 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	 * structure. But bear in mind that the structures
 	 * may change
 	 */
-	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
+	if (copy_from_user(&txc, txc_p, sizeof(struct timex)))
 		return -EFAULT;
 	ret = do_adjtimex(&txc);
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
@@ -289,13 +287,12 @@ struct timespec timespec_trunc(struct timespec
t, unsigned gran)
 	 * Currently current_kernel_time() never returns better than
 	 * jiffies resolution. Exploit that.
 	 */
-	if (gran <= jiffies_to_usecs(1) * 1000) {
+	if (gran <= jiffies_to_usecs(1) * 1000)
 		/* nothing */
-	} else if (gran == 1000000000) {
+	else if (gran == 1000000000)
 		t.tv_nsec = 0;
-	} else {
+	else
 		t.tv_nsec -= t.tv_nsec % gran;
-	}
 	return t;
 }
 EXPORT_SYMBOL(timespec_trunc);
@@ -317,13 +314,13 @@ EXPORT_SYMBOL(timespec_trunc);
  */
 unsigned long
 mktime(const unsigned int year0, const unsigned int mon0,
-       const unsigned int day, const unsigned int hour,
-       const unsigned int min, const unsigned int sec)
+	const unsigned int day, const unsigned int hour,
+	const unsigned int min, const unsigned int sec)
 {
 	unsigned int mon = mon0, year = year0;
-
 	/* 1..12 -> 11,12,1..10 */
-	if (0 >= (int) (mon -= 2)) {
+	mon -= 2;
+	if (0 >= (int) (mon)) {
 		mon += 12;	/* Puts Feb last since it has leap day */
 		year -= 1;
 	}
@@ -335,9 +332,9 @@ mktime(const unsigned int year0, const unsigned int mon0,
 	  )*60 + min /* now have minutes */
 	)*60 + sec; /* finally seconds */
 }
-
 EXPORT_SYMBOL(mktime);

+
 /**
  * set_normalized_timespec - set timespec sec and nsec parts and normalize
  *
@@ -505,7 +502,7 @@ timespec_to_jiffies(const struct timespec *value)
 	unsigned long sec = value->tv_sec;
 	long nsec = value->tv_nsec + TICK_NSEC - 1;

-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		nsec = 0;
 	}
@@ -548,7 +545,7 @@ timeval_to_jiffies(const struct timeval *value)
 	unsigned long sec = value->tv_sec;
 	long usec = value->tv_usec;

-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		usec = 0;
 	}
@@ -591,7 +588,7 @@ EXPORT_SYMBOL(jiffies_to_clock_t);

 unsigned long clock_t_to_jiffies(unsigned long x)
 {
-#if (HZ % USER_HZ)==0
+#if (HZ % USER_HZ) == 0
 	if (x >= ~0UL / (HZ / USER_HZ))
 		return ~0UL;
 	return x * (HZ / USER_HZ);
@@ -635,11 +632,11 @@ u64 nsec_to_clock_t(u64 x)
 #elif (USER_HZ % 512) == 0
 	return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
 #else
-	/*
-         * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
-         * overflow after 64.99 years.
-         * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
-         */
+	 /*
+	  * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
+	  * overflow after 64.99 years.
+	  * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
+	  */
 	return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
 #endif
 }
-- 
1.7.0.4
