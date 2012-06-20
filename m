Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2FTSrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:47:00 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:51492
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab2FTSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:46:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5XIU4-01-38S-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/4] perf, x86: Updates and cleanups
Date: Wed, 20 Jun 2012 20:46:32 +0200
Message-ID: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I separated these for patches from my original NB counter
implementation. They are independent and contain updates and
cleanups. The most important change is the pmu unification. That code
also changes pmu setup for core perfctr from family detection to cpuid
check.

-Robert


Robert Richter (4):
  perf, x86: Rename Intel specific macros
  perf, x86: Move Intel specific code to intel_pmu_init()
  perf, amd: Unify AMD's generic and family 15h pmus
  perf, x86: Improve debug output in check_hw_exists()

 arch/x86/include/asm/kvm_host.h           |    4 +-
 arch/x86/include/asm/perf_event.h         |   20 +++---
 arch/x86/kernel/cpu/perf_event.c          |   59 ++++------------
 arch/x86/kernel/cpu/perf_event_amd.c      |  103 +++++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c    |   47 +++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +-
 arch/x86/kernel/cpu/perf_event_p4.c       |    2 +-
 arch/x86/kvm/pmu.c                        |   22 +++---
 arch/x86/oprofile/op_model_amd.c          |    4 +-
 9 files changed, 128 insertions(+), 137 deletions(-)

-- 
1.7.8.4


