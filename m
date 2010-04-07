Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0DGS4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:56:38 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:42885 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109Ab0DGS4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:56:37 -0400
Date: Wed, 7 Apr 2010 14:53:18 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Tweak SMI sniffer commentary
Message-ID: <20100407185318.GA11442@typhoon.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20100406200605.GA16586@typhoon.ccur.com> <20100407110507.3c8a3aea.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407110507.3c8a3aea.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 02:05:07PM -0400, Randy Dunlap wrote:
> > +			to detect otherwise undetectable SMIs.  Not available
> > +			unless CONFIG_DEBUG_SMI_SNIFFER=y.
> 
> preferable:		Only available when CONFIG_DEBUG_SMI_SNIFFER=y.


> drop "to" (redundant) ^^
> s/cpu/CPU/ throughout
> drop "to" (redundant)
> s/ie/i.e./

> > +the applications running underneath it. For many uses this is unimportant,
> (or on top of it ;)


> > +their occurrence via the setting of a per-cpu 'system interrupt occured' flag.
>                                                                    occurred


Hi Randy,
Thanks!  I've created a follow-on patch containing the suggested rewordings.
Joe

[PATCH] Tweak some SMI sniffer commentary

Thanks go to Randy Dunlap for these suggestions.

Signed-off-by: Joe Korty <joe.korty@ccur.com>


Index: 2.6.34-rc3/Documentation/kernel-parameters.txt
===================================================================
--- 2.6.34-rc3.orig/Documentation/kernel-parameters.txt	2010-04-05 14:30:06.000000000 -0400
+++ 2.6.34-rc3/Documentation/kernel-parameters.txt	2010-04-07 14:39:50.000000000 -0400
@@ -947,8 +947,8 @@
 			will use a lot of power and make the system run hot.
 			Not recommended.
 			idle=smi: variant of idle=poll that uses the spin-time
-			to detect otherwise undetectable SMIs.  Not available
-			unless CONFIG_DEBUG_SMI_SNIFFER=y.
+			to detect otherwise undetectable SMIs.  Only available
+			when CONFIG_DEBUG_SMI_SNIFFER=y.
 			idle=mwait: On systems which support MONITOR/MWAIT but
 			the kernel chose to not use it because it doesn't save
 			as much power as a normal idle loop, use the
Index: 2.6.34-rc3/Documentation/x86/smi-sniffer.txt
===================================================================
--- 2.6.34-rc3.orig/Documentation/x86/smi-sniffer.txt	2010-04-05 14:30:06.000000000 -0400
+++ 2.6.34-rc3/Documentation/x86/smi-sniffer.txt	2010-04-07 14:49:19.000000000 -0400
@@ -8,17 +8,17 @@
 interrupt that goes directly to the BIOS. They are used by motherboard
 manufacturers to, for example, 1) simulate missing hardware in software,
 such as an RTC or emulating a missing PS2 mouse/keyboard using a USB
-mouse/keyboard, 2) to perform critical motherboard duties, such as periodic
-DRAM memory refresh or slowing the cpu down whenever it gets too hot, and 3)
-to work around in software (ie, in the BIOS) deficiencies discovered after
+mouse/keyboard, 2) perform critical motherboard duties, such as periodic
+DRAM memory refresh or slowing the CPU down whenever it gets too hot, and 3)
+work around in software (i.e., in the BIOS) deficiencies discovered after
 a board has been manufactured and shipped to customers.
 
 The OS is not involved with nor even informed of these interrupts when
 they occur, and indeed it is difficult for the OS to detect that they have
 occurred at all. The only signature an SMI leaves behind is the time that it
-consumes. These 'time slices', taken randomly out of the running time of a cpu,
+consumes. These 'time slices', taken randomly out of the running time of a CPU,
 compromise the ability of the OS to provide reasonable latency guarantees to
-the applications running underneath it. For many uses this is unimportant,
+the applications running on top of it. For many uses this is unimportant,
 but for real time systems, the occurrence of an SMI during the run of some
 critically-timed piece of code could shatter the correct running of the system.
 
@@ -36,8 +36,8 @@
 routine is in use, by an "echo 1 >/proc/sys/kernel/smi_sniffer_enable" command.
 
 The sniffer adds a pair of lines to /proc/interrupts.  The "SMI" line shows
-the number of SMIs detected (per-cpu) so far. The "DSMI" line gives the
-duration, in microseconds, of the most recent SMI (for each cpu).
+the number of SMIs detected (per-CPU) so far. The "DSMI" line gives the
+duration, in microseconds, of the most recent SMI (for each CPU).
 
 These lines appear only while the sniffer is running. If it is disabled later,
 say with an "echo 0 >/proc/sys/kernel/smi_sniffer_enable", then the lines
@@ -66,7 +66,7 @@
 longer than 125 usecs by the time it took to process the interrupt.
 
 The OS is modified so that all normal system interrupts, including NMI, mark
-their occurrence via the setting of a per-cpu 'system interrupt occured' flag.
+their occurrence via the setting of a per-CPU 'system interrupt occurred' flag.
 We can therefore detect SMIs by assuming that if a period significantly longer
 than 125 usecs is seen, and this 'system interrupt happened' flag is not set,
 that it was an SMI that lengthened the period.
