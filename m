Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1FTWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:34 -0400
Received: from claw.goop.org ([74.207.240.146]:53655 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab1FTWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 00/15] xen: use tracing to replace ad-hoc debug/stats stuff
Date: Mon, 20 Jun 2011 15:14:56 -0700
Message-Id: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

This series (RFC for 3.1) introduces a set of trace events to keep
track of what's going on within the Xen code.  This allows us to
replace a pile of ad-hoc debug and stats code.

The latter part of the series implements some improvements the better
tracing highlighted, specifically to reduce hypercall overhead by
making multicalls cheaper and to increase the multicall batch size.

Also at git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xen-tracing2

Thanks,
	J

Jeremy Fitzhardinge (15):
  trace/xen: add skeleton for Xen trace events
  xen/multicalls: remove debugfs stats
  xen/trace: set up tracepoint skeleton
  xen/trace: add multicall tracing
  xen/trace: add mmu tracepoints
  xen/trace: add ptpage alloc/release tracepoints
  xen/trace: add xen_pgd_(un)pin tracepoints
  xen/trace: add segment desc tracing
  xen/trace: add tlb flush tracepoints
  xen/mmu: use extend_args for more mmuext updates
  xen/mmu: tune pgtable alloc/release
  xen/multicalls: disable MC_DEBUG
  xen/multicalls: add unlikely around slowpath in __xen_mc_entry()
  xen/multicall: special-case singleton hypercalls
  xen/multicall: move *idx fields to start of mc_buffer

 arch/x86/include/asm/xen/hypercall.h   |   22 ++
 arch/x86/include/asm/xen/trace_types.h |   18 +
 arch/x86/xen/Makefile                  |    2 +-
 arch/x86/xen/enlighten.c               |   16 +-
 arch/x86/xen/mmu.c                     |  139 +++++++--
 arch/x86/xen/multicalls.c              |  169 +++--------
 arch/x86/xen/multicalls.h              |    6 +
 arch/x86/xen/trace.c                   |   61 ++++
 include/trace/events/xen.h             |  534 ++++++++++++++++++++++++++++++++
 9 files changed, 817 insertions(+), 150 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/trace_types.h
 create mode 100644 arch/x86/xen/trace.c
 create mode 100644 include/trace/events/xen.h

-- 
1.7.5.4

