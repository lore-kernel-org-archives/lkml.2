Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0LBFRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:17:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:18850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0LBFRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:17:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="355904368"
Subject: [RFC PATCH 0/3 v3] perf: Add Intel Nehalem uncore pmu support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 13:19:38 +0800
Message-ID: <1291267178.2405.311.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here are the v3 patches to add uncore pmu support to perf, applied on
top of current tip/master(74f6deb).

Changelogs of v3:

- Allocate uncore data with kmalloc_node, like AMD NB stuff. (Peter
Zijlstra)

- per-task uncore event is not allowed. Simply set pmu::task_ctx_nr =
perf_invalid_context. (Peter Zijlstra)

- Route interrupts to the first core that accesses uncore pmu. (Stephane
Eranian)

- Check CPUID signatures with boot_cpu_data. (Andi Kleen)

- Remove unneeded include files. (Andi Kleen)

Changelogs of v2:

- modify the NMI handling code to handle all counters enabled by all 4
cores.

- allocate uncore_events[] table dynamically using kmalloc_node() to
avoid unnecessary remote memory accesses. (Stephane Eranian)

- add support for the fixed uncore counter. (Stephane Eranian)

- Handling of exclude_* bits. Uncore PMU measures at all privilege level
all the time. So it doesn't make sense to specify any exclude bits.
(Stephane Eranian)

- let uncore code be more self contained, that is, not include it in
arch/x86/kernel/cpu/perf_event.c (Peter Zijlstra)

- uncore pmu interrupt have its own NMI_DIE notifier entry. (Peter
Zijlstra)

Known bugs:

- When hyper thread is enabled, both HTs will receive the NMI. In this
case, the overflow status bits are not acked correctly.

TODO:

- Add support for uncore address/opcode match thing

- Add a new sub-command for uncore events statistics.
For example, perf package -p <package-id> -e <event>

As usual, any comment is very appreciated.

Lin Ming 

