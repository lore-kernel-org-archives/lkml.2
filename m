Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0KSU0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:26:52 -0500
Received: from mail.vyatta.com ([76.74.103.46]:36015 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab0KSU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:26:51 -0500
Date: Fri, 19 Nov 2010 12:26:48 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] show set_rtc_mmss: message only once
Message-ID: <20101119122648.4274c994@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occasionally system get in state where CMOS clock has gotten
slightly ahead of current time and the periodic update of RTC
fails. The message is a nuisance and repeats spamming the log.

  See: http://www.ntp.org/ntpfaq/NTP-s-trbl-spec.htm#Q-LINUX-SET-RTC-MMSS

Rather than just removing the message, make it show only once
and reduce severity since it indicates a normal and non urgent
condition.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 arch/alpha/kernel/time.c              |    2 +-
 arch/cris/kernel/time.c               |    2 +-
 arch/mips/dec/time.c                  |    2 +-
 arch/mips/include/asm/mc146818-time.h |    2 +-
 arch/mn10300/kernel/rtc.c             |    2 +-
 arch/sh/boards/mach-sh03/rtc.c        |    2 +-
 arch/x86/kernel/rtc.c                 |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/alpha/kernel/time.c	2010-11-19 12:14:47.003071149 -0800
+++ b/arch/alpha/kernel/time.c	2010-11-19 12:15:13.058296694 -0800
@@ -506,7 +506,7 @@ set_rtc_mmss(unsigned long nowtime)
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
  		retval = -1;
--- a/arch/cris/kernel/time.c	2010-11-19 12:14:47.015069088 -0800
+++ b/arch/cris/kernel/time.c	2010-11-19 12:15:22.168594662 -0800
@@ -86,7 +86,7 @@ int set_rtc_mmss(unsigned long nowtime)
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
--- a/arch/mips/dec/time.c	2010-11-19 12:14:47.031066339 -0800
+++ b/arch/mips/dec/time.c	2010-11-19 12:15:40.229230614 -0800
@@ -104,7 +104,7 @@ int rtc_mips_set_mmss(unsigned long nowt
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
--- a/arch/mips/include/asm/mc146818-time.h	2010-11-19 12:14:47.047063590 -0800
+++ b/arch/mips/include/asm/mc146818-time.h	2010-11-19 12:15:47.247926878 -0800
@@ -66,7 +66,7 @@ static inline int mc146818_set_rtc_mmss(
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
--- a/arch/mn10300/kernel/rtc.c	2010-11-19 12:14:47.063060842 -0800
+++ b/arch/mn10300/kernel/rtc.c	2010-11-19 12:16:02.309135936 -0800
@@ -89,7 +89,7 @@ static int set_rtc_mmss(unsigned long no
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
--- a/arch/sh/boards/mach-sh03/rtc.c	2010-11-19 12:14:47.079058094 -0800
+++ b/arch/sh/boards/mach-sh03/rtc.c	2010-11-19 12:16:14.478887406 -0800
@@ -108,7 +108,7 @@ static int set_rtc_mmss(unsigned long no
 		__raw_writeb(real_minutes % 10, RTC_MIN1);
 		__raw_writeb(real_minutes / 10, RTC_MIN10);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
--- a/arch/x86/kernel/rtc.c	2010-11-19 12:14:47.091056032 -0800
+++ b/arch/x86/kernel/rtc.c	2010-11-19 12:16:26.092747020 -0800
@@ -76,7 +76,7 @@ int mach_set_rtc_mmss(unsigned long nowt
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
