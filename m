Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031140Ab2CSNBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:01:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53199 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CSNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:01:46 -0400
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 18:31:44 +0530
Message-ID: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
Subject: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, refering to you patch:

ARM: remove 'select GENERIC_TIME'
GENERIC_TIME is now enabled by default, so 'select GENERIC_TIME' is
redundant.  Remove them.

The following config's are not selectable:
config NO_HZ, config HIGH_RES_TIMERS, config IRQSOFF_TRACER, config
PREEMPT_TRACER

As far as I know, ARM now uses GENERIC_TIME via the arch_getoffset()
infrastructure, i.e ARCH_USES_GETTIMEOFFSET=y

diff -Naurp -X linux-3.0.20/Documentation/dontdiff
linux-3.0.20/kernel/time/Kconfig
linux-3.0.20-dirty/kernel/time/Kconfig
--- linux-3.0.20/kernel/time/Kconfig    2012-02-06 23:01:45.000000000 +0530
+++ linux-3.0.20-dirty/kernel/time/Kconfig      2012-03-19
18:22:32.000000000 +0530
@@ -6,7 +6,7 @@ config TICK_ONESHOT

 config NO_HZ
        bool "Tickless System (Dynamic Ticks)"
-       depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+       depends on GENERIC_CLOCKEVENTS
        select TICK_ONESHOT
        help
          This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ

 config HIGH_RES_TIMERS
        bool "High Resolution Timer Support"
-       depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+       depends on GENERIC_CLOCKEVENTS
        select TICK_ONESHOT
        help
          This option enables high resolution timer support. If your
diff -Naurp -X linux-3.0.20/Documentation/dontdiff
linux-3.0.20/kernel/trace/Kconfig
linux-3.0.20-dirty/kernel/trace/Kconfig
--- linux-3.0.20/kernel/trace/Kconfig   2012-02-06 23:01:45.000000000 +0530
+++ linux-3.0.20-dirty/kernel/trace/Kconfig     2012-03-19
18:21:41.000000000 +0530
@@ -173,7 +173,6 @@ config IRQSOFF_TRACER
        bool "Interrupts-off Latency Tracer"
        default n
        depends on TRACE_IRQFLAGS_SUPPORT
-       depends on !ARCH_USES_GETTIMEOFFSET
        select TRACE_IRQFLAGS
        select GENERIC_TRACER
        select TRACER_MAX_TRACE
@@ -195,7 +194,6 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
        bool "Preemption-off Latency Tracer"
        default n
-       depends on !ARCH_USES_GETTIMEOFFSET
        depends on PREEMPT
        select GENERIC_TRACER
        select TRACER_MAX_TRACE
