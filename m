Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1GXAUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 20:20:15 -0400
Received: from claw.goop.org ([74.207.240.146]:38252 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1GXAUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 20:20:08 -0400
Message-ID: <4E29F6FE.6030004@goop.org>
Date: Fri, 22 Jul 2011 15:17:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [GIT PULL] xen: replace adhoc debug goo with proper tracing
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This replaces a pile of ad-hoc debug stuff in the Xen code with tracing, and a few performance improvements noticed as a result.

Thanks,
	J

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xen-tracing2

Jeremy Fitzhardinge (17):
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
      xen/trace: convert mmu events to use DECLARE_EVENT_CLASS()/DEFINE_EVENT()
      xen/trace: use class for multicall trace

 arch/x86/include/asm/xen/hypercall.h   |   22 ++
 arch/x86/include/asm/xen/trace_types.h |   18 ++
 arch/x86/xen/Makefile                  |    2 +-
 arch/x86/xen/enlighten.c               |   16 +-
 arch/x86/xen/mmu.c                     |  139 +++++++--
 arch/x86/xen/multicalls.c              |  169 +++--------
 arch/x86/xen/multicalls.h              |    6 +
 arch/x86/xen/trace.c                   |   61 ++++
 include/trace/events/xen.h             |  504 ++++++++++++++++++++++++++++++++
 9 files changed, 787 insertions(+), 150 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/trace_types.h
 create mode 100644 arch/x86/xen/trace.c
 create mode 100644 include/trace/events/xen.h


