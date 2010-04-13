Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0DMLnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:43:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45840
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab0DMLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:43:37 -0400
Date: Tue, 13 Apr 2010 04:43:41 -0700 (PDT)
Message-Id: <20100413.044341.94138285.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've spent the last week or so getting ftrace et al. working
again on sparc64.  The NMI scheme I use there was causing all
sorts of issues, but luckily the final fix was very simple.

While I was here debugging this stuff I added function graph
tracer support, as well as support for kmemleak.  Kmemleak
even found a bug :-)

All combinations of features seems to work (perf top with tracers,
lockdep, and kmemleak all enabled for example) and wow is this stuff
super-useful :-)

I merged in your tree to resolve a conflict in lib/Kconfig.debug
since Microblaze added kmemleak support recently too.

Please pull, thanks a lot!

The following changes since commit 0d0fb0f9c5fddef4a10242fe3337f00f528a3099:
  Linus Torvalds (1):
        Linux 2.6.34-rc4

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (14):
      sparc64: Use kstack_valid() in die_if_kernel().
      sparc64: Adjust __raw_local_irq_save() to cooperate in NMIs.
      sparc64: Add HAVE_FUNCTION_TRACE_MCOUNT_TEST and tidy up.
      sparc64: Kill CONFIG_STACK_DEBUG code.
      sparc64: Kill unnecessary static on local var in ftrace_call_replace().
      sparc64: Remove profiling from some low-level bits.
      sparc64: Use a seperate counter for timer interrupts and NMI checks, like x86.
      sparc64: Give a stack frame to the ftrace call sites.
      sparc64: Add function graph tracer support.
      sparc64: Support kmemleak.
      sparc64: Add kmemleak annotation to sun4v_build_virq()
      sparc64: Fix memory leak in pci_register_iommu_region().
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: Add some more commentary to __raw_local_irq_save()

 arch/sparc/Kconfig                   |    3 +
 arch/sparc/Kconfig.debug             |    5 +-
 arch/sparc/include/asm/cpudata_64.h  |    2 +-
 arch/sparc/include/asm/irqflags_64.h |   23 ++++-
 arch/sparc/kernel/Makefile           |   10 ++-
 arch/sparc/kernel/ftrace.c           |   60 +++++++++++++-
 arch/sparc/kernel/irq_64.c           |   11 ++-
 arch/sparc/kernel/kgdb_64.c          |    3 +-
 arch/sparc/kernel/nmi.c              |    3 +-
 arch/sparc/kernel/pci_common.c       |   11 ++-
 arch/sparc/kernel/pcr.c              |    3 +-
 arch/sparc/kernel/smp_64.c           |   11 ++-
 arch/sparc/kernel/time_64.c          |    4 +-
 arch/sparc/kernel/traps_64.c         |   26 +-----
 arch/sparc/kernel/vmlinux.lds.S      |    5 +
 arch/sparc/lib/mcount.S              |  159 +++++++++++++++------------------
 lib/Kconfig.debug                    |    2 +-
 17 files changed, 206 insertions(+), 135 deletions(-)
