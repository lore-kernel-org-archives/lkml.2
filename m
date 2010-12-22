Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0LVDQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 22:16:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:12236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0LVDQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 22:16:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,210,1291622400"; 
   d="scan'208";a="689566692"
Subject: Re: [V3 PATCH 0/9] x86, NMI: give NMI handler a face-lift
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 11:16:26 +0800
Message-ID: <1292987786.8743.116.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

It seems that this patchset has not been merged yet.  Give it a retry?
Busy on watchdog issue?

Best Regards,
Huang Ying

On Wed, 2010-12-01 at 06:27 +0800, Don Zickus wrote:
> Restructuring the nmi handler to be more readable and simpler.
> 
> This is just laying the ground work for future improvements in this area.
> 
> I also left out one of Huang's patch until we figure out how we are going
> to proceed with a new notifier.
> 
> Tested 32-bit and 64-bit on AMD and Intel machines.
> 
> V3:  rebased on top of removal of nmi watchdog
>      add a couple more watchdog patches from my queue
> 
> V2:  add a patch to kill DIE_NMI_IPI and add in priorities
> 
> Cheers,
> Don
> 
> Don Zickus (5):
>   x86, NMI: Remove DIE_NMI_IPI and add priorties to handlers
>   x86: only call smp_processor_id in non-preempt cases
>   panic:  ratelimit panic messages
>   watchdog:  touch_nmi_watchdog should only touch local cpu not every
>     one
> 
> Dongdong Deng (1):
>   x86: Avoid calling arch_trigger_all_cpu_backtrace() at the same time
> 
> Huang Ying (3):
>   x86, NMI: Add NMI symbol constants and rename memory parity to PCI
>     SERR
>   x86, NMI: Add touch_nmi_watchdog to io_check_error delay
>   x86, NMI: Rewrite NMI handler
>   x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
> 
>  Documentation/kernel-parameters.txt     |    6 ++
>  arch/x86/include/asm/kdebug.h           |    1 -
>  arch/x86/include/asm/mach_traps.h       |   12 +++-
>  arch/x86/include/asm/nmi.h              |   20 ++++++
>  arch/x86/kernel/apic/hw_nmi.c           |   19 ++++-
>  arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +-
>  arch/x86/kernel/cpu/perf_event.c        |    3 +-
>  arch/x86/kernel/kgdb.c                  |    6 +--
>  arch/x86/kernel/reboot.c                |    5 +-
>  arch/x86/kernel/traps.c                 |  114 ++++++++++++++++---------------
>  arch/x86/oprofile/nmi_int.c             |    3 +-
>  arch/x86/oprofile/nmi_timer_int.c       |    2 +-
>  drivers/char/ipmi/ipmi_watchdog.c       |    2 +-
>  drivers/watchdog/hpwdt.c                |    2 +-
>  kernel/panic.c                          |   30 ++++++++
>  kernel/watchdog.c                       |   17 +++--
>  17 files changed, 166 insertions(+), 83 deletions(-)
> 


