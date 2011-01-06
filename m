Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1AFVTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:19:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1AFVTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:19:22 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/6] x86, NMI: die_notifier and default_do_nmi cleanups
Date: Thu,  6 Jan 2011 16:18:46 -0500
Message-Id: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another version of the NMI rewrite patches I sent previously.  I
take it those patches were too thick to be reviewed easily, so I broke out
the patches differently to make it easier to review.  Hopefully it doesn't
look as scary.

The bulk of the patch adds priorities to the die_chain notifiers for NMI
events and removes the DIE_NMI_IPI event.  There are some other cleanups
too, which include removing the restriction of the BSP cpu to process 
external NMIs.

Cheers,
Don

Don Zickus (5):
  x86: Convert some devices to use DIE_NMIUNKNOWN
  x86, NMI: Add priorities to handlers
  x86, NMI: Remove DIE_NMI_IPI
  x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
  x86, NMI: Clean-up default_do_nmi()

Huang Ying (1):
  x86, NMI: Add NMI symbol constants and rename memory parity to PCI
    SERR

 arch/x86/include/asm/kdebug.h           |    1 -
 arch/x86/include/asm/mach_traps.h       |   12 +++-
 arch/x86/include/asm/nmi.h              |   20 ++++++
 arch/x86/kernel/apic/hw_nmi.c           |    3 +-
 arch/x86/kernel/apic/x2apic_uv_x.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    5 +-
 arch/x86/kernel/cpu/perf_event.c        |    3 +-
 arch/x86/kernel/kgdb.c                  |    6 +--
 arch/x86/kernel/reboot.c                |    5 +-
 arch/x86/kernel/traps.c                 |  102 +++++++++++++++---------------
 arch/x86/oprofile/nmi_int.c             |    3 +-
 arch/x86/oprofile/nmi_timer_int.c       |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c       |    2 +-
 drivers/watchdog/hpwdt.c                |    2 +-
 14 files changed, 97 insertions(+), 71 deletions(-)

-- 
1.7.3.4

