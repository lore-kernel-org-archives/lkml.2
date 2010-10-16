Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0JPCXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab0JPCW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:22:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: andi@firstfloor.org, robert.richter@amd.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/5] x86, NMI: give NMI handler a face-lift
Date: Fri, 15 Oct 2010 22:22:13 -0400
Message-Id: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructuring the nmi handler to be more readable and simpler.

This is just laying the ground work for future improvements in this area.

I know people were complaining about having DIE_NMI and DIE_NMI_IPI, but
for now it is consistent with what was there before.  Hopefully, we can
modify the notifier chain to make it smarter and combine the two events.

I also left out one of Huang's patch until we figure out how we are going
to proceed with a new notifier.

Tested 32-bit and 64-bit on AMD and Intel machines.

Cheers,
Don

Huang Ying (5):
  x86, NMI: Add NMI symbol constants and rename memory parity to PCI
    SERR
  x86, NMI: Add touch_nmi_watchdog to io_check_error delay
  x86, NMI: Rewrite NMI handler
  x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
  x86, NMI: Remove do_nmi_callback logic

 arch/x86/include/asm/mach_traps.h |   12 +++-
 arch/x86/include/asm/nmi.h        |   10 +++-
 arch/x86/kernel/apic/hw_nmi.c     |    1 -
 arch/x86/kernel/apic/nmi.c        |   29 +-------
 arch/x86/kernel/cpu/perf_event.c  |    1 -
 arch/x86/kernel/traps.c           |  141 ++++++++++++++++++++----------------
 arch/x86/oprofile/nmi_int.c       |    1 -
 arch/x86/oprofile/nmi_timer_int.c |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 drivers/watchdog/hpwdt.c          |    2 +-
 10 files changed, 102 insertions(+), 99 deletions(-)

-- 
1.7.2.3

