Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1AGJzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:55:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52661 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1AGJzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:55:00 -0500
Subject: Re: [PATCH 0/6] x86, NMI: die_notifier and default_do_nmi cleanups
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 10:55:12 +0100
Message-ID: <1294394112.2016.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 16:18 -0500, Don Zickus wrote:
> This is another version of the NMI rewrite patches I sent previously.  I
> take it those patches were too thick to be reviewed easily, so I broke out
> the patches differently to make it easier to review.  Hopefully it doesn't
> look as scary.
> 
> The bulk of the patch adds priorities to the die_chain notifiers for NMI
> events and removes the DIE_NMI_IPI event.  There are some other cleanups
> too, which include removing the restriction of the BSP cpu to process 
> external NMIs.
> 
> Cheers,
> Don
> 
> Don Zickus (5):
>   x86: Convert some devices to use DIE_NMIUNKNOWN
>   x86, NMI: Add priorities to handlers
>   x86, NMI: Remove DIE_NMI_IPI
>   x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
>   x86, NMI: Clean-up default_do_nmi()
> 
> Huang Ying (1):
>   x86, NMI: Add NMI symbol constants and rename memory parity to PCI
>     SERR
> 
>  arch/x86/include/asm/kdebug.h           |    1 -
>  arch/x86/include/asm/mach_traps.h       |   12 +++-
>  arch/x86/include/asm/nmi.h              |   20 ++++++
>  arch/x86/kernel/apic/hw_nmi.c           |    3 +-
>  arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +-
>  arch/x86/kernel/cpu/perf_event.c        |    3 +-
>  arch/x86/kernel/kgdb.c                  |    6 +--
>  arch/x86/kernel/reboot.c                |    5 +-
>  arch/x86/kernel/traps.c                 |  102 +++++++++++++++---------------
>  arch/x86/oprofile/nmi_int.c             |    3 +-
>  arch/x86/oprofile/nmi_timer_int.c       |    2 +-
>  drivers/char/ipmi/ipmi_watchdog.c       |    2 +-
>  drivers/watchdog/hpwdt.c                |    2 +-
>  14 files changed, 97 insertions(+), 71 deletions(-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
