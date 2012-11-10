Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2KJBCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:02:15 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:54770
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab2KJBB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:01:59 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzd6eahzz1de0h1202h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h1155h)
X-WSS-ID: 0MD8YV3-01-03M-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Date: Fri, 9 Nov 2012 19:01:34 -0600
Message-ID: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset enables 4 additional performance counters in
AMD family 15h processors that counts northbridge events -- such as
DRAM accesses.

This patchset is based on previous work done by Robert Richter
<rric@kernel.org> :

https://lkml.org/lkml/2012/6/19/324

The main differences are:

- The northbridge counters are indexed contiguously right above the
  core performance counters.

- MSR address offset calculations are moved to architecture specific
  files.

- Interrups are set up to be delivered only to a single core.

Jacob Shin (3):
  perf, amd: Refactor northbridge event constraints handler for code
    sharing
  perf, x86: Move MSR address offset calculation to architecture
    specific files
  perf, amd: Enable northbridge performance counters on AMD family 15h

Robert Richter (1):
  perf, amd: Simplify northbridge event constraints handler

 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event.h    |    6 +
 arch/x86/kernel/cpu/perf_event.h     |   21 +--
 arch/x86/kernel/cpu/perf_event_amd.c |  279 +++++++++++++++++++++++-----------
 5 files changed, 207 insertions(+), 103 deletions(-)

-- 
1.7.9.5


