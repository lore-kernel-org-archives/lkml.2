Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2KHMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:52:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab2KHMwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:52:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: acme@ghostprotocols.net
cc: dhowells@redhat.com, mingo@kernel.org, tglx@linutronix.de, bp@alien8.de,
        namhyung@gmail.com, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [GIT PULL] UAPI: perf fixes
Date: Thu, 08 Nov 2012 12:51:50 +0000
Message-ID: <1378.1352379110@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnaldo,

Assuming my patches should be based on your perf/core branch, could you pull
from my git tree at tag perf-uapi-20121108 into your perf/core branch?

Note the tree also contains a uapi-perf-x86-20121108 tag that has the UAPI
disintegration branch for x86 merged on top for reference.

There are six commits, three preliminary patches:

 (1) A patch to export asm/svm.h, asm/vmx.h and asm/perf_regs.h to UAPI.

 (2) A merge for (1) - the patch in (1) is premerged by the UAPI disintegration
     for x86 also, and I'd rather not include your perf/core branch in that if
     I can avoid it.

 (3) A patch to export and disintegrate linux/hw_breakpoint.h.  It looks like
     it should perhaps have been exported already, given the __KERNEL__ markers
     in it.

and then the main three patches:

 (4) Use a makefile $(call ...) function in tools/Makefile to make it easier
     to deal with.

 (5) Fix handling of O= with a relative path when doing something like:

	make tools/perf O=foo

     from the top-level directory in the kernel source tree for all tools.

 (6) Make perf work for x86 by adding -I flags and changing long #includes
     with "../../include" in them into short <asm/foo.h> type things.

David
---
The following changes since commit 8dfec403e39b7c37fd6e8813bacc01da1e1210ab:

  perf tests: Removing 'optional' field (2012-11-05 14:03:59 -0300)

are available in the git repository at:

  git://git.infradead.org/users/dhowells/linux-headers.git tags/perf-uapi-20121108

for you to fetch changes up to 028c2c390c71d3d37f91291ac8e827f5028f7975:

  perf: Make perf build for x86 with UAPI disintegration applied (2012-11-08 11:55:58 +0000)

----------------------------------------------------------------
perf fixes 2012-11-08

----------------------------------------------------------------
David Howells (6):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
      UAPI: Merge pre-disintegration bits for x86
      UAPI: Export and disintegrate linux/hw_breakpoint.h
      tools: Define a Makefile function to do subdir processing
      tools: Honour the O= flag when tool build called from a higher Makefile
      perf: Make perf build for x86 with UAPI disintegration applied

 Makefile                                |  6 ++++--
 arch/x86/include/asm/Kbuild             |  3 +++
 include/linux/hw_breakpoint.h           | 31 +------------------------------
 include/uapi/linux/Kbuild               |  1 +
 include/uapi/linux/hw_breakpoint.h      | 30 ++++++++++++++++++++++++++++++
 tools/Makefile                          | 24 ++++++++++++------------
 tools/perf/Makefile                     | 28 +++++++++++++++++++++++++++-
 tools/perf/arch/x86/include/perf_regs.h |  2 +-
 tools/perf/builtin-kvm.c                |  6 +++---
 tools/perf/perf.h                       | 16 +++-------------
 tools/perf/tests/builtin-test.c         |  2 +-
 tools/perf/tests/parse-events.c         |  2 +-
 tools/perf/util/evsel.c                 |  4 ++--
 tools/perf/util/evsel.h                 |  2 +-
 tools/perf/util/header.h                |  2 +-
 tools/perf/util/parse-events.c          |  2 +-
 tools/perf/util/parse-events.h          |  2 +-
 tools/perf/util/pmu.h                   |  2 +-
 tools/perf/util/session.h               |  2 +-
 tools/scripts/Makefile.include          | 23 ++++++++++++++++++++---
 20 files changed, 115 insertions(+), 75 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h
