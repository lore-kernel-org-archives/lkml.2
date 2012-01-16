Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2APQWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:22:47 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48700 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2APQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:22:46 -0500
Subject: [RFC PATCH v1 0/2] sched: unified sched_powersavings tunables
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Indan Zupancic <indan@nul.nu>,
        Youquan Song <youquan.song@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jan 2012 21:52:26 +0530
Message-ID: <20120116161740.29759.4679.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12011607-3568-0000-0000-000001100D1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have created the following RFC patch based on the recent discussions
and consensus on simplifying the power aware scheduler in the kernel.

Ref: LWN: Rethinking power-aware scheduling
     http://lwn.net/Articles/474915/

The goal of the unified tunable are as follows:

* Simple and single tunable for different (all) topology
* Good default powersavings for kernel
* Potential to map this setting to other subsystems like cpufreq and
  cpuidle    

What this patch does: (first step)

* Create a single sched_powersavings tunable in sysfs
* Enable current sched_mc and sched_smt features based on 
  value of this single tunable

What this patch is yet to do:

* Tune the default power savings to pack packages only till
  a threshold of say 50%
* Add notifiers to change setting on battery/AC transitions
* Feed the thresholds from arch specific code so that different archs
  can do 'optimal' packing based on topology  
* May be move this to /sys/device/system/powersavings and add additional
  platform tunables like x86_energy_perf_policy?

This RFC has only x86 changes and has been tested on dual-socket,
quad-core,HT configuration.

Please let me know your comments and feedback.

Thanks,
Vaidy

---

Vaidyanathan Srinivasan (2):
      sched: unified sched_powersavings sysfs tunable
      sched: fix group_capacity for thread level consolidation


 arch/x86/Kconfig          |   20 ++++--------
 arch/x86/kernel/smpboot.c |    2 +
 block/blk.h               |   11 ++++---
 drivers/base/cpu.c        |    2 +
 include/linux/sched.h     |   29 +++++++++--------
 include/linux/topology.h  |    9 +----
 kernel/sched/core.c       |   75 +++++++++++----------------------------------
 kernel/sched/fair.c       |   38 ++++++++++++++++-------
 8 files changed, 77 insertions(+), 109 deletions(-)

