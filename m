Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2FSSLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:11:12 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53285
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab2FSSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIG-01-1O9-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD family 15h
Date: Tue, 19 Jun 2012 20:10:38 +0200
Message-ID: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds northbridge counter support for AMD family 15h cpus.

The NB counter implementation and usage is in the same way as for
family 10h. Thus a nb event can now be selected as any other
performance counter event. As for family 10h the kernel selects only
one NB PMC per node by using the nb constraint handler.

Main part of this patch set is to rework current code in a way that
bit masks for counters can be used. Also, Intel's fixed counters have
been moved to Intel only code. This is since AMD nb counters start at
index 32 which leads to holes in the counter mask and causes conflicts
with fixed counters.

Another major change is the unification of AMD pmus and, where
possible, a family independent feature check based on cpuid.

It should also be mentioned that nb perfctrs do not support all bits
in the config value, see patch #10.

-Robert



Robert Richter (10):
  perf, amd: Rework northbridge event constraints handler
  perf, x86: Rework counter reservation code
  perf, x86: Use bitmasks for generic counters
  perf, x86: Rename Intel specific macros
  perf, x86: Move Intel specific code to intel_pmu_init()
  perf, amd: Unify AMD's generic and family 15h pmus
  perf, amd: Generalize northbridge constraints code for family 15h
  perf, amd: Enable northbridge counters on family 15h
  perf, x86: Improve debug output in check_hw_exists()
  perf, amd: Check northbridge event config value

 arch/x86/include/asm/cpufeature.h         |    2 +
 arch/x86/include/asm/kvm_host.h           |    4 +-
 arch/x86/include/asm/perf_event.h         |   26 ++-
 arch/x86/kernel/cpu/perf_event.c          |  129 +++++------
 arch/x86/kernel/cpu/perf_event.h          |    7 +
 arch/x86/kernel/cpu/perf_event_amd.c      |  368 +++++++++++++++++------------
 arch/x86/kernel/cpu/perf_event_intel.c    |   65 +++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +-
 arch/x86/kernel/cpu/perf_event_p4.c       |    8 +-
 arch/x86/kvm/pmu.c                        |   22 +-
 arch/x86/oprofile/op_model_amd.c          |    4 +-
 11 files changed, 374 insertions(+), 265 deletions(-)

-- 
1.7.8.4


