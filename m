Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab2EVRWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:22:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60419 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab2EVRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:21:58 -0400
Date: Tue, 22 May 2012 10:21:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alex Shi <alex.shi@intel.com>
Subject: [GIT PULL] percpu changes for 3.5-rc1
Message-ID: <20120522172150.GF14339@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu changes for
3.5-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.5

Contains Alex Shi's three patches to remove percpu_xxx() which overlap
with this_cpu_xxx().  There shouldn't be any functional change.

Thanks.

Alex Shi (3):
      net: replace percpu_xxx funcs with this_cpu_xxx or __this_cpu_xxx
      x86: replace percpu_xxx funcs with this_cpu_xxx
      percpu: remove percpu_xxx() functions

 arch/x86/include/asm/compat.h         |    2 +-
 arch/x86/include/asm/current.h        |    2 +-
 arch/x86/include/asm/desc.h           |    1 +
 arch/x86/include/asm/fpu-internal.h   |    6 ++--
 arch/x86/include/asm/hardirq.h        |    9 +++--
 arch/x86/include/asm/irq_regs.h       |    4 +-
 arch/x86/include/asm/mmu_context.h    |   12 ++++----
 arch/x86/include/asm/percpu.h         |   24 ++++++--------
 arch/x86/include/asm/smp.h            |    4 +-
 arch/x86/include/asm/stackprotector.h |    4 +-
 arch/x86/include/asm/thread_info.h    |    2 +-
 arch/x86/include/asm/tlbflush.h       |    4 +-
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    4 +-
 arch/x86/kernel/i387.c                |    2 +-
 arch/x86/kernel/nmi_selftest.c        |    1 +
 arch/x86/kernel/paravirt.c            |   12 ++++----
 arch/x86/kernel/process.c             |    2 +-
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |   10 +++---
 arch/x86/mm/tlb.c                     |   10 +++---
 include/linux/percpu.h                |   54 ---------------------------------
 include/linux/topology.h              |    4 +-
 net/netfilter/xt_TEE.c                |   12 ++++----
 net/socket.c                          |    4 +-
 25 files changed, 69 insertions(+), 124 deletions(-)

--
tejun
