Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0JUAOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:14:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37429 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0JUAOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:14:52 -0400
Date: Wed, 20 Oct 2010 17:14:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36
Message-ID: <20101021001450.GL2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTimdii2F3PsG4SxO5Zym7TB=MSGhtN+TpG=HmbcT@mail.gmail.com>
 <AANLkTinLUHHxBr78OjpJujh_fQZgp1KgtVU5qARJp4_a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLUHHxBr78OjpJujh_fQZgp1KgtVU5qARJp4_a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:00:07AM +0900, Minchan Kim wrote:
> On Thu, Oct 21, 2010 at 6:01 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:

[ . . . ]

> I met "INFO: suspicious rcu_dereference_check() usage"
> Maybe we need this patch http://lkml.org/lkml/2010/10/12/4

Hello, Minchan,

This commit is currently in -tip, and my guess is that Ingo will be
sending it on to Linus during the merge window.

In the meantime, I suggest that people run production 2.6.36 kernels
with CONFIG_PROVE_RCU=n, which is the default.  ;-)

							Thanx, Paul

> ---
> 
> <SNIP>
> 
> Fast TSC calibration using PIT
> Detected 2660.408 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.
> 81 BogoMIPS (lpj=10641632)
> pid_max: default: 32768 minimum: 301
> Security Framework initialized
> SELinux:  Disabled at boot.
> Mount-cache hash table entries: 512
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys memory
> Initializing cgroup subsys freezer
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> using mwait in idle threads.
> Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> ... version:                2
> ... bit width:              40
> ... generic registers:      2
> ... value mask:             000000ffffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   3
> ... event mask:             0000000700000003
> ACPI: Core revision 20100702
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 21862 entries in 43 pages
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz stepping 0a
> lockdep: fixing up alternatives.
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/sched.c:618 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 3 locks held by kworker/0:0/4:
>  #0:  (events){+.+.+.}, at: [<c015fc3e>] process_one_work+0x11e/0x470
>  #1:  ((&c_idle.work)){+.+.+.}, at: [<c015fc3e>] process_one_work+0x11e/0x470
>  #2:  (&rq->lock){-.....}, at: [<c066a042>] init_idle+0x29/0x111
> 
> stack backtrace:
> Pid: 4, comm: kworker/0:0 Not tainted 2.6.36 #44
> Call Trace:
>  [<c066c9bd>] ? printk+0x1d/0x20
>  [<c017ad7a>] lockdep_rcu_dereference+0xaa/0xb0
>  [<c013ed8e>] set_task_rq+0x1ae/0x2d0
>  [<c066a0eb>] init_idle+0xd2/0x111
>  [<c066a4dd>] fork_idle+0xae/0xc1
>  [<c0668f48>] do_fork_idle+0x13/0x23
>  [<c015fcba>] process_one_work+0x19a/0x470
>  [<c015fc3e>] ? process_one_work+0x11e/0x470
>  [<c0668f35>] ? do_fork_idle+0x0/0x23
>  [<c0162069>] worker_thread+0x129/0x320
>  [<c0161f40>] ? worker_thread+0x0/0x320
>  [<c0165e1c>] kthread+0x7c/0x90
>  [<c0165da0>] ? kthread+0x0/0x90
>  [<c01034fa>] kernel_thread_helper+0x6/0x10
> Booting Node   0, Processors  #1
> Initializing CPU#1
> lockdep: fixing up alternatives.
>  #2
> Initializing CPU#2
> lockdep: fixing up alternatives.
>  #3 Ok.
> Initializing CPU#3
> Brought up 4 CPUs
> Total of 4 processors activated (21280.57 BogoMIPS).
> devtmpfs: initialized
> regulator: core version 0.5
> Time:  8:38:59  Date: 10/21/10
> NET: Registered protocol family 16
> EISA bus registered
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-10] at [mem
> 0xf8000000-0xf90fffff] (base 0xf8000000)
> PCI: not using MMCONFIG
> PCI: PCI BIOS revision 2.10 entry at 0xfdc00, last bus=17
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: SSDT beb5efc5 001DD (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT (null) 001DD (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
> ACPI: SSDT beb5f1a2 0016E (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT (null) 0016E (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
> ACPI: SSDT beb5f310 0016E (v01  PmRef  Cpu2Ist 00003000 INTL 20050228)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT (null) 0016E (v01  PmRef  Cpu2Ist 00003000 INTL 20050228)
> ACPI: SSDT beb5f47e 0016E (v01  PmRef  Cpu3Ist 00003000 INTL 20050228)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT (null) 0016E (v01  PmRef  Cpu3Ist 00003000 INTL 20050228)
> ACPI: Interpreter enabled
> 
> <SNIP>
> 
> --
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
