Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1DPAgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:36:13 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:58399
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab1DPAfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:35:48 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJPYZ8-01-0IV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf, x86: Fixes for v2.6.39
Date: Sat, 16 Apr 2011 02:27:52 +0200
Message-ID: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains fixes for v2.6.39. They are related to the
AMD family 15h PMU but also modify x86 generic code. See the diffstat
below.

If possible I would like to see patch #4 also in .39, though it is
more than just a one-liner with many changes in the x86 event
scheduling code. Without this patch scheduling multiple events on AMD
family 15h may fail under certain conditions though there are enough
counters available.

-Robert



The following changes since commit e566b76ed30768140df8f0023904aed5a41244f7:

  perf_event: Fix cgrp event scheduling bug in perf_enable_on_exec() (2011-04-11 11:07:55 +0200)

Andre Przywara (1):
      perf, x86: Fix pre-defined cache-misses event for AMD family 15h cpus

Robert Richter (3):
      perf, x86: Fix AMD family 15h FPU event constraints
      perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE
      perf, x86: Fix event scheduler to solve complex scheduling problems

 arch/x86/kernel/cpu/perf_event.c     |   63 +++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/perf_event_amd.c |   23 ++++++++++--
 2 files changed, 70 insertions(+), 16 deletions(-)



