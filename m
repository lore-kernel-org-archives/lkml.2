Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab1JEQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:57:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:52172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935044Ab1JEQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558364"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/8] Online/offline BSP on x86
Date: Wed,  5 Oct 2011 09:39:11 -0700
Message-Id: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This patch set
implements BSP online and offline and removes this obstacle to CPU hotplug.

Fenghua Yu (8):
  x86, apic.c: Disable irq0 if CPU enables ARAT for local apic timer
  x86/mtrr/main.c: Ask the first online CPU to save mtrr
  x86, i387.c: thread xstate is initialized only on BSP once
  kernel/workqueue.c: unbound work queue rescuer runs on first cpu in
    cpumask_online_cpu
  x86, common.c, smpboot.c: Init BSP during BSP online and don't
    offline BSP if irq is bound to it
  x86, topology.c: Enable CPU0 online/offline
  kernel/power/main.c: Not suspend/resume if CPU0 is offlined
  kernel/cpu.c: Define bsp_hotpluggable variable

 Documentation/kernel-parameters.txt |    7 ++++++
 arch/x86/include/asm/processor.h    |    1 +
 arch/x86/kernel/apic/apic.c         |    5 ++++
 arch/x86/kernel/cpu/common.c        |   13 +++++++++--
 arch/x86/kernel/cpu/mtrr/main.c     |    6 +++-
 arch/x86/kernel/i387.c              |    9 +++++++-
 arch/x86/kernel/smpboot.c           |   38 ++++++++++++++++++++++++++++------
 arch/x86/kernel/topology.c          |   22 +++++++++++++------
 include/linux/cpu.h                 |    2 +
 kernel/cpu.c                        |    5 ++++
 kernel/power/main.c                 |    9 ++++++++
 kernel/workqueue.c                  |    4 +-
 12 files changed, 99 insertions(+), 22 deletions(-)

