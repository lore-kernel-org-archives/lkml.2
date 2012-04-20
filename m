Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2DTNRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:17:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:45029 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2DTNRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:17:01 -0400
Date: Fri, 20 Apr 2012 15:16:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <20120420122120.097464672@linutronix.de>
Message-ID: <alpine.LFD.2.02.1204201516130.2542@ionos>
References: <20120420122120.097464672@linutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Thomas Gleixner wrote:
> This converts all architectures except m32r, mn10300, tile and UM to
> the new core facility. These architecture are calling fork_idle() in
> the very early boot code in smp_prepare_cpus() for unknown reasons.
> I haven't analyzed yet, whether this is on purpose or can be moved
> over to the generic facility. It'd be nice if the responsible maintainers
> could look into that as well.

Forgot to add a diffstat for the full series.

 arch/Kconfig                    |    3 +
 arch/alpha/Kconfig              |    1 
 arch/alpha/kernel/smp.c         |   20 +-------
 arch/arm/Kconfig                |    1 
 arch/arm/include/asm/cpu.h      |    1 
 arch/arm/kernel/smp.c           |   26 ----------
 arch/blackfin/Kconfig           |    1 
 arch/blackfin/mach-common/smp.c |   19 --------
 arch/cris/Kconfig               |    1 
 arch/cris/arch-v32/kernel/smp.c |   14 +----
 arch/hexagon/Kconfig            |    1 
 arch/hexagon/kernel/smp.c       |   11 ----
 arch/ia64/Kconfig               |    1 
 arch/ia64/kernel/smpboot.c      |   63 +-------------------------
 arch/m32r/kernel/smpboot.c      |    6 --
 arch/mips/Kconfig               |    1 
 arch/mips/kernel/smp.c          |   56 -----------------------
 arch/mn10300/kernel/smp.c       |    2 
 arch/parisc/Kconfig             |    1 
 arch/parisc/kernel/smp.c        |   25 +---------
 arch/powerpc/Kconfig            |    1 
 arch/powerpc/kernel/smp.c       |   76 ++------------------------------
 arch/s390/Kconfig               |    1 
 arch/s390/include/asm/smp.h     |    2 
 arch/s390/kernel/smp.c          |   35 +-------------
 arch/sh/Kconfig                 |    1 
 arch/sh/include/asm/processor.h |    4 -
 arch/sh/kernel/smp.c            |   14 -----
 arch/sparc/Kconfig              |    1 
 arch/sparc/include/asm/leon.h   |    5 +-
 arch/sparc/kernel/leon_smp.c    |    9 ---
 arch/sparc/kernel/smp_32.c      |   12 ++---
 arch/sparc/kernel/smp_64.c      |   12 +----
 arch/sparc/kernel/sun4d_smp.c   |    8 ---
 arch/sparc/kernel/sun4m_smp.c   |    7 --
 arch/tile/kernel/smpboot.c      |    2 
 arch/um/kernel/smp.c            |    2 
 arch/x86/Kconfig                |    1 
 arch/x86/include/asm/smp.h      |   11 ++--
 arch/x86/kernel/smpboot.c       |   83 ++++------------------------------
 arch/x86/xen/smp.c              |   19 +-------
 include/linux/smp.h             |    2 
 kernel/Makefile                 |    1 
 kernel/cpu.c                    |   10 +++-
 kernel/sched/core.c             |    2 
 kernel/smpboot.c                |   95 ++++++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h                |   16 ++++++
 47 files changed, 215 insertions(+), 471 deletions(-)
