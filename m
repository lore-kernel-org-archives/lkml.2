Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab1LORCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:02:24 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:51776
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759188Ab1LORCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:02:21 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW98EJ-01-7T5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v4 0/4] perf, x86: Implement AMD IBS
Date: Thu, 15 Dec 2011 17:56:35 +0100
Message-ID: <1323968199-9326-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD IBS to perf. It is a new
implementation and unrelated to my previous postings last year. The
main differences are:

* separate and independent from x86 perfctrs, IBS could be used
  without the x86 pmu,
* using dynamic pmu allocation, userspace uses sysfs to select the pmu,
* support for 64 bit counters,
* libperf based example code,
* shared IBS initialziation code for perf and oprofile.

The approach is still to collect raw sample data which should be the
most important use case for application developers. The data format is
the same as described in the IBS register specification.

Future work could be:

* better integration into the perf tool, use IBS for generic events
  where possible,
* support of the precise event sampling perf i/f,
* implementation of extended IBS features (e.g. ext. counter width),
* support of counting (perf stat),
* in-kernel IBS event parsing,
* IBS tracepoint support.

Changes for V2:

    * Remove printks in pmu function stubs.
    * Modify perf_event_ibs_init() to use ibs_caps directly.
    * Added bit mask for msr offsets.
    * Added caps field to raw sample format.
    * Added caps check for IBS_OP_CUR_CNT emulation.
    * Updated include header files to fix build errors on some distros.
    * Note: I kept example code for reference, the patch must not be
      applied. I will come up with a sulution that integrates IBS into
      perf-report.

Changes for V3 (only patch #3 modified):

    * rebased on Don's NMI V5 patch set
    * disable per-task monitoring (mark pmu with perf_invalid_context),
      per-task monitoring can be added in a separate patch

Changes for V4 (only patch #3 modified):

    * removed userland implementation from patch set, will post it as
      separate patch series
    * fix returned number of handled nmis in perf_ibs_handle_irq()

-Robert

Robert Richter (4):
  perf, x86: Implement IBS event configuration
  perf, x86: Implement IBS interrupt handler
  perf, x86: Implement IBS pmu control ops
  perf, x86: Implement 64 bit counter support for IBS

 arch/x86/include/asm/msr-index.h         |    5 +
 arch/x86/include/asm/perf_event.h        |    2 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |  438 +++++++++++++++++++++++++++++-
 3 files changed, 438 insertions(+), 7 deletions(-)

-- 
1.7.7


