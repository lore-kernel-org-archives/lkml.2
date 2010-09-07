Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0IGRAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:00:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:60096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab0IGQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:39 -0400
Message-Id: <20100907164633.879932949@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/19] perf pmu interface changes -v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches prepare the perf code for multiple PMUs.

About the first half of these patches deals with removing all the weak
functions, the second half provides per pmu contexts.

New to the first half is Alpha, which got merged into mainline recently.

The second half is completely new and lightly tested, one known breakage is
that it currently doesn't allow to mix software and hardware events into a
single group (should be fixed soon).

Patches also available in git format for easy testing (tip/master + patches):

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu

Head should be baf996bc6d6

---

 arch/alpha/kernel/perf_event.c            |  113 ++-
 arch/arm/kernel/perf_event.c              |  136 ++-
 arch/powerpc/kernel/perf_event.c          |  164 ++-
 arch/powerpc/kernel/perf_event_fsl_emb.c  |  148 ++-
 arch/sh/kernel/perf_event.c               |  143 ++-
 arch/sparc/kernel/perf_event.c            |  164 ++-
 arch/x86/kernel/cpu/perf_event.c          |  176 ++-
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 include/linux/ftrace_event.h              |    4 +-
 include/linux/perf_event.h                |  113 +-
 include/linux/sched.h                     |    9 +-
 kernel/hw_breakpoint.c                    |   62 +-
 kernel/perf_event.c                       | 2068 +++++++++++++++--------------
 kernel/sched.c                            |    2 -
 kernel/trace/trace_event_perf.c           |    7 +-
 16 files changed, 1889 insertions(+), 1424 deletions(-)



