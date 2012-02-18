Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2BRCf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:35:27 -0500
Received: from smp.if.uj.edu.pl ([149.156.82.206]:54208 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab2BRCf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:35:26 -0500
Date: Sat, 18 Feb 2012 03:35:21 +0100
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: akpm@linux-foundation.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: ODEBUG: selftest warnings failed 4 != 5 (WARNING: at
 lib/debugobjects.c:908 check_results.constprop.9)
Message-ID: <20120218023521.GB13538@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I recently enabled a CONFIG_DEBUG_OBJECTS kconfig option, and this is what I got when booting

...
[    0.000000] Linux version 3.3.0-rc3-t43-devel-smp-00278-g4903062-dirty (baryluk@sredniczarny) (gcc version 4.6.2 (Debian 4.6.2-14) ) #27 SMP Fri Feb 17 20:13:29 CE
...
...
...
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
...
...
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at lib/debugobjects.c:908 check_results.constprop.9+0x11c/0x140()
[    0.000000] Hardware name: 2669UYD
[    0.000000] ODEBUG: selftest warnings failed 4 != 5
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc3-t43-devel-smp-00272-g7ada1dd-dirty #25
[    0.000000] Call Trace:
[    0.000000]  [<c104a4d2>] warn_slowpath_common+0x72/0xa0
[    0.000000]  [<c1b5eb22>] ? check_results.constprop.9+0x11c/0x140
[    0.000000]  [<c1b5eb22>] ? check_results.constprop.9+0x11c/0x140
[    0.000000]  [<c104a5a3>] warn_slowpath_fmt+0x33/0x40
[    0.000000]  [<c1b5eb22>] check_results.constprop.9+0x11c/0x140
[    0.000000]  [<c1b5edb8>] debug_objects_selftest+0x1c3/0x2d1
[    0.000000]  [<c1b5efbf>] debug_objects_mem_init+0x6c/0x6e
[    0.000000]  [<c1b3a6f0>] start_kernel+0x2a7/0x33a
[    0.000000]  [<c1b3a25a>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c1b3a11e>] ? reserve_ebda_region+0x6b/0x6d
[    0.000000]  [<c1b3a0ac>] i386_start_kernel+0x9b/0xa2
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
...

Kernel is booting however without bigger problems. I have some lockdep
problems latter, but I'm not sure if this is related (already reported
few days ago to few people including Andrew).

I cannot say when bug was introduced, because well, I noticed it just
today when inspecting some kernel messages in more detail, and because I
had previously not CONFIG_DEBUG_OBJECTS not set in kernel config.

This is IBM Thinkpad T43, with Intel Pentium-M (32-bit). Was using
gcc-4.6.2-14 from Debian sid.

Oh, It looks that it already was noticed by Stephen Boyd on -mm kernel
( https://lkml.org/lkml/2012/1/14/132 ), but now looks to happen on
mainline. Can a fix be rechecked and merged?

Or should I start using -mm kernel for testing more fresh code?

Regards,
Witek

-- 
Witold Baryluk
