Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2LEXF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:05:58 -0500
Received: from [216.32.181.185] ([216.32.181.185]:34940 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab2LEXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:05:53 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzd6eahzz1de0h1202h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MEKYR6-02-25C-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V4 0/6] perf, amd: Enable AMD family 15h northbridge counters
Date: Wed, 5 Dec 2012 17:04:12 -0600
Message-ID: <1354748658-30567-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset enables 4 additional performance counters in
AMD family 15h processors that count northbridge events -- such as
number of DRAM accesses.

This patchset is based on previous work done by Robert Richter
<rric@kernel.org> :

https://lkml.org/lkml/2012/6/19/324

The main differences are:

* The northbridge counters are indexed contiguously right above the
  core performance counters.

* MSR address offset calculations are moved to architecture specific
  files.

* Interrups are set up to be delivered only to a single core.

V4:
* Moved interrupt core select set up back to event constraints
  function, sicne during ->hw_config time we do not yet know on which
  CPU the the event will run on.
* Tested on and made minor revisions to make sure that the patchset is
  compatible with upcoming AMD Family 16h processors, and will support
  core and NB counters without any further patches.

V3:
Addressed the following feedback/comments from Robert's review
* https://lkml.org/lkml/2012/11/16/484
* https://lkml.org/lkml/2012/11/26/162

V2:
Separate out Robert's patches, and add properly ordered certificate of
origins.

Jacob Shin (4):
  perf, amd: Use proper naming scheme for AMD bit field definitions
  perf, x86: Move MSR address offset calculation to architecture
    specific files
  perf, x86: Allow for architecture specific RDPMC indexes
  perf, amd: Enable northbridge performance counters on AMD family 15h

Robert Richter (2):
  perf, amd: Rework northbridge event constraints handler
  perf, amd: Generalize northbridge constraints code for family 15h

 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event.h    |   13 +-
 arch/x86/kernel/cpu/perf_event.c     |    2 +-
 arch/x86/kernel/cpu/perf_event.h     |   25 ++-
 arch/x86/kernel/cpu/perf_event_amd.c |  318 ++++++++++++++++++++++++++--------
 6 files changed, 268 insertions(+), 94 deletions(-)

-- 
1.7.9.5


