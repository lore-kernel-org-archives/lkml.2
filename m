Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0KLOpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:45:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0KLOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:45:04 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Date: Fri, 12 Nov 2010 09:43:47 -0500
Message-Id: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructuring the nmi handler to be more readable and simpler.

This is just laying the ground work for future improvements in this area.

I also left out one of Huang's patch until we figure out how we are going
to proceed with a new notifier.

Tested 32-bit and 64-bit on AMD and Intel machines.

V2:  add a patch to kill DIE_NMI_IPI and add in priorities

Cheers,
Don

Don Zickus (3):
  x86, NMI: Remove DIE_NMI_IPI and add priorties to handlers
  x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
  x86, NMI: Remove do_nmi_callback logic

Huang Ying (3):
  x86, NMI: Add NMI symbol constants and rename memory parity to PCI
    SERR
  x86, NMI: Add touch_nmi_watchdog to io_check_error delay
  x86, NMI: Rewrite NMI handler

 arch/x86/include/asm/kdebug.h           |    1 -
 arch/x86/include/asm/mach_traps.h       |   12 +++-
 arch/x86/include/asm/nmi.h              |   30 +++++++-
 arch/x86/kernel/apic/hw_nmi.c           |    4 +-
 arch/x86/kernel/apic/nmi.c              |   29 +-------
 arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +-
 arch/x86/kernel/cpu/perf_event.c        |    3 +-
 arch/x86/kernel/kgdb.c                  |    6 +-
 arch/x86/kernel/reboot.c                |    5 +-
 arch/x86/kernel/traps.c                 |  135 ++++++++++++++++---------------
 arch/x86/oprofile/nmi_int.c             |    3 +-
 arch/x86/oprofile/nmi_timer_int.c       |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c       |    2 +-
 drivers/watchdog/hpwdt.c                |    2 +-
 15 files changed, 126 insertions(+), 115 deletions(-)

-- 
1.7.2.3

