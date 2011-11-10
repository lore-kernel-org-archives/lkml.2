Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1KJAvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:51:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:1731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab1KJAvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:51:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="35103407"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 0/7] x86: BSP or CPU0 online/offline
Date: Wed,  9 Nov 2011 16:34:10 -0800
Message-Id: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
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

v3: Register a pm notifier to check if CPU0 is online before hibernate/suspend.
Small wording changes in document and print info.

v2: Add locking changes between cpu hotplug and hibernate/suspend. Change PIC
irq bound to CPU0 detection.

Fenghua Yu (7):
  x86/topology.c: Support functions for BSP online/offline
  x86/common.c: Init BSP data during BSP online
  x86/mtrr/main.c: Ask the first online CPU to save mtrr
  x86/smpboot.c: Don't offline BSP if any irq can not be migrated out
    of it
  Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0
    online/offline feature
  x86/i387.c: Thread xstate is initialized only on BSP once
  x86/power/cpu.c: Don't hibernate/suspend if CPU0 is offline

 Documentation/cpu-hotplug.txt       |   19 +++++++++++++++
 Documentation/kernel-parameters.txt |   13 ++++++++++
 arch/x86/include/asm/processor.h    |    1 +
 arch/x86/kernel/cpu/common.c        |   13 ++++++++--
 arch/x86/kernel/cpu/mtrr/main.c     |    9 +++++-
 arch/x86/kernel/i387.c              |    9 ++++++-
 arch/x86/kernel/smpboot.c           |   43 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/topology.c          |   24 +++++++++++++-----
 arch/x86/power/cpu.c                |   44 +++++++++++++++++++++++++++++++++++
 9 files changed, 155 insertions(+), 20 deletions(-)

