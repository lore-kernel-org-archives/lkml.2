Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1KDWVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:21:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1KDWVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337184"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/9] BSP or CPU0 online/offline
Date: Fri,  4 Nov 2011 15:03:52 -0700
Message-Id: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This patch set
implements BSP online and offline and removes this obstacle to CPU hotplug.

RAS needs the feature. If socket0 needs to be hotplugged for any reason (any
thread on socket0 is bad, shared cache issue, uncore issue, etc), CPU0 is
required to be offline or hot replaced to keep the system run.

Fenghua Yu (9):
  include/linux/cpu.h: Define architecture dependent cpu map update and
    state check functions
  kernel/cpu.c: Add arch dependent cpu map update functions
  x86/i387.c: Thread xstate is initialized only on BSP once
  x86/common.c: Init BSP data during BSP online
  x86/mtrr/main.c: Ask the first online CPU to save mtrr
  kernel/power/suspend.c,hibernate.c: Don't hibernate/suspend if CPU0
    is offline
  x86/topology.c: Support functions for BSP online/offline
  x86/smpboot.c: Don't offline BSP if any irq can not be migrated out
    of it
  Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0
    online/offline feature

 Documentation/cpu-hotplug.txt       |   19 +++++++++++++++
 Documentation/kernel-parameters.txt |   13 ++++++++++
 arch/x86/include/asm/processor.h    |    1 +
 arch/x86/kernel/cpu/common.c        |   13 ++++++++--
 arch/x86/kernel/cpu/mtrr/main.c     |    9 +++++-
 arch/x86/kernel/i387.c              |    9 ++++++-
 arch/x86/kernel/smpboot.c           |   43 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/topology.c          |   44 +++++++++++++++++++++++++++++-----
 include/linux/cpu.h                 |    6 ++++
 kernel/cpu.c                        |   12 +++++++++
 kernel/power/hibernate.c            |    5 ++++
 kernel/power/main.c                 |    5 ++++
 kernel/power/suspend.c              |    4 +++
 13 files changed, 163 insertions(+), 20 deletions(-)

