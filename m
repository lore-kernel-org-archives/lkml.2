Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0KLQXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:23:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab0KLQXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:23:01 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, gorcunov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] x86: Remove old nmi_watchdog
Date: Fri, 12 Nov 2010 11:22:22 -0500
Message-Id: <1289578944-28564-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo asked me to remove the old nmi_watchdog to minimize the amount of
code duplication we have to do for recent fixes.  All the functionality
needed by the old nmi watchdog should be available in perf now.

This is done in two parts.  The first part is simply remove the old code
and leave stubs for the functions that were removed.  This mimics the
behaviour of the new nmi watchdog.

The second parts removes all the stub functions, which is probably a
little more intrusive, but basically dead code anyway.

The only small piece left is the perf counter reservation code.  That can't
be removed until oprofile is modified to sit on top of perf (if that is
possible).

Compile tested for 32/64 bit with the lockup detector turned on and off.
Tested on 32/64 bit machines to make sure they still boot properly.

NOTE:  This patch will clash with my nmi rewrite patch series.  I don't
which patch series will go in first.  I can refresh either one once one
of them is merged.

Don Zickus (2):
  x86, nmi_watchdog:  remove the old nmi_watchdog
  x86, nmi_watchdog: remove all stub function calls from old
    nmi_watchdog

 arch/x86/include/asm/nmi.h             |   51 ---
 arch/x86/include/asm/smpboot_hooks.h   |    1 -
 arch/x86/include/asm/timer.h           |    6 -
 arch/x86/kernel/apic/Makefile          |    5 +-
 arch/x86/kernel/apic/apic.c            |   15 +-
 arch/x86/kernel/apic/hw_nmi.c          |   16 +-
 arch/x86/kernel/apic/io_apic.c         |   46 ---
 arch/x86/kernel/apic/nmi.c             |  567 ----------------------------
 arch/x86/kernel/cpu/perf_event.c       |    9 -
 arch/x86/kernel/cpu/perfctr-watchdog.c |  642 --------------------------------
 arch/x86/kernel/smpboot.c              |   11 -
 arch/x86/kernel/time.c                 |   18 -
 arch/x86/kernel/traps.c                |   11 -
 arch/x86/oprofile/nmi_timer_int.c      |    3 -
 drivers/acpi/acpica/nsinit.c           |    2 -
 drivers/watchdog/hpwdt.c               |    7 +-
 include/linux/nmi.h                    |    8 +-
 kernel/sysctl.c                        |   16 -
 18 files changed, 7 insertions(+), 1427 deletions(-)
 delete mode 100644 arch/x86/kernel/apic/nmi.c

-- 
1.7.2.3

