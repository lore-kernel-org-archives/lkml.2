Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2KEXTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:19:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab2KEXSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:18:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <25722.1352156007@warthog.procyon.org.uk>
References: <25722.1352156007@warthog.procyon.org.uk> <15094.1352155791@warthog.procyon.org.uk>
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net,
        bp@alien8.de, namhyung@gmail.com
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: tools, perf: Fix up for x86 UAPI disintegration
Date: Mon, 05 Nov 2012 23:18:27 +0000
Message-ID: <4600.1352157507@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> David Howells <dhowells@redhat.com> wrote:
> 
> > I've posted a revised version of my perf patches to my UAPI disintegration
> > GIT tree.
> 
> Hmmm...  It seems to break some things according to Fengguang's kbuild test
> robot.

Okay.  I've fixed that.  Revised stuff pushed to the GIT tree.

David
---
The following changes since commit 4adf23e40d6e93169358b4dc5d616b921b6e1982:

  Merge remote-tracking branch 'tipbot/perf/core' into perf-uapi (2012-11-05 14:09:06 +0000)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/perf-uapi-20121105

for you to fetch changes up to fdfa48a57f5d4669213dd56c8a19324304da3e44:

  perf: Make perf build for x86 with UAPI disintegration applied (2012-11-05 23:03:12 +0000)

----------------------------------------------------------------
perf fixes 2012-11-05

----------------------------------------------------------------
David Howells (5):
      x86: Export asm/{svm.h,vmx.h,perf_regs.h}
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
 tools/perf/Makefile                     | 26 +++++++++++++++++++++++++-
 tools/perf/arch/x86/include/perf_regs.h |  2 +-
 tools/perf/builtin-kvm.c                |  6 +++---
 tools/perf/builtin-test.c               |  2 +-
 tools/perf/perf.h                       | 16 +++-------------
 tools/perf/util/evsel.c                 |  4 ++--
 tools/perf/util/evsel.h                 |  2 +-
 tools/perf/util/header.h                |  2 +-
 tools/perf/util/parse-events-test.c     |  2 +-
 tools/perf/util/parse-events.c          |  2 +-
 tools/perf/util/parse-events.h          |  2 +-
 tools/perf/util/pmu.h                   |  2 +-
 tools/perf/util/session.h               |  2 +-
 tools/scripts/Makefile.include          | 23 ++++++++++++++++++++---
 20 files changed, 113 insertions(+), 75 deletions(-)
 create mode 100644 include/uapi/linux/hw_breakpoint.h
