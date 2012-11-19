Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2KSWpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KSWpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:45:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: acme@ghostprotocols.net, Josh Boyer <jwboyer@gmail.com>,
        xiaoguangrong@linux.vnet.ibm.com
cc: dhowells@redhat.com, mingo@kernel.org, haodong@linux.vnet.ibm.com,
        runzhen@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [GIT PULL] UAPI: perf fixes on top of perf/urgent
Date: Mon, 19 Nov 2012 22:45:16 +0000
Message-ID: <7463.1353365116@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnaldo,

Here are my perf fixes based on top of your perf/urgent branch.  I have
squashed the linux/hw_breakpoint.h disintegration patch into the main perf
patch as you can't have one without the other without getting errors.

I tried to apply Xiao Guangrong's builtin-kvm fixes for the x86/x86_64-only
bits, but they weren't simple to fix up - so I left them off.

So, if you could pull the perf-uapi-20121119 tag, this contains:
 
 (1a) A patch to export asm/svm.h, asm/vmx.h and asm/perf_regs.h to UAPI.

 (1b) A merge commit for (1a).  The patch in (1a) is premerged by the UAPI
     disintegration for x86 also, and I'd rather not include your perf/core
     branch in that if I can avoid it.

     Could you possibly merge patch (1a) rather than cherry-picking it?  That
     would mean that my disintegrate-x86 branch won't conflict with yours.

 (2) The three tools patches from me plus Sukadev Bhattiprolu's powerpc patch
     to use uapi/unistd.h that you have added to perf/core already.

 (3) A patch that does:

     (a) Exports and disintegrates linux/hw_breakpoint.h.

     (b) Makes perf work for x86 by adding -I flags and changing long #includes
     	 with "../../include" in them into short <asm/foo.h> type things.

     Neither of these parts works without the other, so I've combined them into
     one to maintain bisectability.

If you look on the perf-uapi branch in the GIT tree mentioned below, you'll see
that for convenience, I have added an extra bit beyond the tag mentioned below
whereby the disintegrate-x86 branch is merged and tagged as
uapi-perf-x86-20121119-2.

David
---
The following changes since commit f787d9519fb10411f2948f5b9957a1669879ba84:

  perf tools: Fix strbuf_addf() when the buffer needs to grow (2012-10-30 10:32:56 -0200)

are available in the git repository at:

  git://git.infradead.org/users/dhowells/linux-headers.git tags/perf-uapi-20121119

for you to fetch changes up to d2709c7ce4c513ab7f4ca9a106a930621811f2d3:

  perf: Make perf build for x86 with UAPI disintegration applied (2012-11-19 22:21:03 +0000)

----------------------------------------------------------------
perf/urgent fixes 2012-11-19

----------------------------------------------------------------
David Howells (6):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      Merge branch 'x86-pre-uapi' into perf-uapi
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      tools: Pass the target in descend
      perf: Make perf build for x86 with UAPI disintegration applied

Sukadev Bhattiprolu (1):
      perf powerpc: Use uapi/unistd.h to fix build error

 Makefile                                |  6 ++++--
 arch/x86/include/asm/Kbuild             |  3 +++
 include/linux/hw_breakpoint.h           | 31 +------------------------------
 include/uapi/linux/Kbuild               |  1 +
 include/uapi/linux/hw_breakpoint.h      | 30 ++++++++++++++++++++++++++++++
 tools/Makefile                          | 24 ++++++++++++------------
 tools/perf/Makefile                     | 29 ++++++++++++++++++++++++++++-
 tools/perf/arch/x86/include/perf_regs.h |  2 +-
 tools/perf/builtin-kvm.c                |  6 +++---
 tools/perf/builtin-test.c               |  2 +-
 tools/perf/perf.h                       | 16 +++-------------
 tools/perf/util/evsel.c                 |  4 ++--
 tools/perf/util/evsel.h                 |  3 ++-
 tools/perf/util/header.h                |  2 +-
 tools/perf/util/parse-events-test.c     |  2 +-
 tools/perf/util/parse-events.c          |  2 +-
 tools/perf/util/parse-events.h          |  2 +-
 tools/perf/util/pmu.h                   |  2 +-
 tools/perf/util/session.h               |  2 +-
 tools/scripts/Makefile.include          | 23 ++++++++++++++++++++---
 20 files changed, 117 insertions(+), 75 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h
