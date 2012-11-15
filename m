Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2KOVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:32:15 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14284
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033Ab2KOVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:32:10 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MDJT5F-02-3KE-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 0/4] perf, amd: Enable AMD family 15h northbridge counters
Date: Thu, 15 Nov 2012 15:31:49 -0600
Message-ID: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset enables 4 additional performance counters in
AMD family 15h processors that counts northbridge events -- such as
number of DRAM accesses.

This patchset is based on top of previous work done by Robert Richter
<rric@kernel.org> :

https://lkml.org/lkml/2012/6/19/324

The main differences are:

- The northbridge counters are indexed contiguously right above the
  core performance counters.

- MSR address offset calculations are moved to architecture specific
  files.

- Interrups are set up to be delivered only to a single core.

V2:
Seprate out Robert's patches, and add properly ordered certificate of
origins.

Jacob Shin (2):
  perf, x86: Move MSR address offset calculation to architecture
    specific files
  perf, amd: Enable northbridge performance counters on AMD family 15h

Robert Richter (2):
  perf, amd: Rework northbridge event constraints handler
  perf, amd: Generalize northbridge constraints code for family 15h

 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event.h    |    6 +
 arch/x86/kernel/cpu/perf_event.h     |   21 +--
 arch/x86/kernel/cpu/perf_event_amd.c |  246 ++++++++++++++++++++++++----------
 5 files changed, 187 insertions(+), 90 deletions(-)

-- 
1.7.9.5


