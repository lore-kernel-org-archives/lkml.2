Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1EZFXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:23:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:38561 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1EZFXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:23:07 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 15:22:54 +1000
Message-ID: <1306387374.7481.451.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a bit more than I expected to send you that late in the merge
window, but hopefully none of it should be problematic. A couple of
patches were simply delayed due to misunderstandings as to which tree
they should go through (4xx MSI and ftrace).

There's a generic patch to linux/smp.h which removes some definitions
that as far as we can tell aren't used anywhere anymore (we just removed
the last use in powerpc in my previous pull request).

The rest is either good enough bug fixes (in large part regressions),
with a couple more cleanups from Milton on top of his big series that
I merged earlier.

Cheers,
Ben.

The following changes since commit 3f5785ec31adcb7cafa9135087297a38d9698cf8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-05-25 17:00:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git ..BRANCH.NOT.VERIFIED..

Brian King (1):
      powerpc/pseries: Update MAX_HCALL_OPCODE to reflect page coalescing

Eric B Munson (1):
      powerpc/oprofile: Handle events that raise an exception without overflowing

Ian Munsie (1):
      powerpc/ftrace: Implement raw syscall tracepoints on PowerPC

Milton Miller (8):
      Remove unused MSG_ flags in linux/smp.h
      powerpc/cell: Use common smp ipi actions
      powerpc/cell: Rename ipi functions to match current abstractions
      powerpc/irq: Remove stale and misleading comment
      powerpc/irq: Always free duplicate IRQ_LEGACY hosts
      powerpc/irq: Check desc in handle_one_irq and expand generic_handle_irq
      powerpc/irq: Protect irq_radix_revmap_lookup against irq_free_virt
      powerpc: Fix irq_free_virt by adjusting bounds before loop

Rupjyoti Sarmah (1):
      powerpc/4xx: Adding PCIe MSI support

 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/boot/dts/canyonlands.dts   |   18 ++
 arch/powerpc/boot/dts/katmai.dts        |   18 ++
 arch/powerpc/boot/dts/kilauea.dts       |   28 +++
 arch/powerpc/boot/dts/redwood.dts       |   20 +++
 arch/powerpc/include/asm/ftrace.h       |   14 ++
 arch/powerpc/include/asm/hvcall.h       |    2 +-
 arch/powerpc/include/asm/smp.h          |    2 -
 arch/powerpc/include/asm/syscall.h      |    5 +
 arch/powerpc/include/asm/thread_info.h  |    7 +-
 arch/powerpc/kernel/Makefile            |    1 +
 arch/powerpc/kernel/ftrace.c            |    8 +
 arch/powerpc/kernel/irq.c               |   46 +++---
 arch/powerpc/kernel/ptrace.c            |   10 +
 arch/powerpc/kernel/smp.c               |    2 +-
 arch/powerpc/oprofile/op_model_power4.c |   24 +++-
 arch/powerpc/platforms/40x/Kconfig      |    2 +
 arch/powerpc/platforms/44x/Kconfig      |    6 +
 arch/powerpc/platforms/cell/interrupt.c |   55 ++----
 arch/powerpc/platforms/cell/interrupt.h |    2 +-
 arch/powerpc/platforms/cell/smp.c       |    2 +-
 arch/powerpc/sysdev/Kconfig             |    7 +
 arch/powerpc/sysdev/Makefile            |    1 +
 arch/powerpc/sysdev/ppc4xx_msi.c        |  276 +++++++++++++++++++++++++++++++
 include/linux/smp.h                     |   10 -
 25 files changed, 491 insertions(+), 76 deletions(-)
 create mode 100644 arch/powerpc/sysdev/ppc4xx_msi.c


