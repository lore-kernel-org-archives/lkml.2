Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1CQDGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:06:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39928
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab1CQDGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:06:00 -0400
Date: Wed, 16 Mar 2011 20:06:38 -0700 (PDT)
Message-Id: <20110316.200638.189689580.davem@davemloft.net>
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


Several small fixes, and a series of cleanups to the IRQ
handling code of sparc32 to get us ready for a full generic
IRQ conversion.

Please pull, thanks a lot!

The following changes since commit 4c5811bf463b0ef82fabbd1708f8bb2d753aeb18:

  Merge branch 'devicetree/next' of git://git.secretlab.ca/git/linux-2.6 (2011-03-16 17:28:10 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Ben Hutchings (1):
      sparc: Fix .size directive for do_int_load

Daniel Hellstrom (3):
      sparc32: added U-Boot build target: uImage
      SPARC/LEON: power down instruction different of different LEONs
      sparc32/leon: FPU-FSR only available when FPU present

David S. Miller (3):
      sparc64: Sharpen address space randomization calculations.
      sparc64: Fix build errors with gcc-4.6.0
      sparc32: Fix might-be-used-uninitialized warning in do_sparc_fault().

John Stultz (1):
      sparc: convert to clocksource_register_hz/khz

Kristoffer Glembo (6):
      sparc: Replace open coded page alignment with PAGE_ALIGN macro.
      sparc: Add pci32_unmap_page.
      sparc/leon: Add LEON dma_ops.
      sparc/leon: Make mmu_inval_dma_area flush dcache for LEONs without snooping enabled.
      sparc: Make mmu_inval_dma_area take void * instead of unsigned long to minimize casts.
      sparc: Fix sbus_alloc_coherent error handling.

Sam Ravnborg (19):
      sparc64: fix direct access to irq_desc
      sparc: in handler_irq() rename irq parameter to pil
      sparc64: all pointers to irq_handler_data renamed to handler_data
      sparc64: use {get,set}_irq_data for handler_data
      sparc64: use up-to-data genirq functions
      sparc64: rename virt_irq => irq - I
      sparc64: rename virt_irq => irq - II
      sparc32: remove tick14.c
      sparc32: add irq + smp declarations to headers
      sparc32,sun4c: irq file cleanup
      sparc32,sun4m: irq, smp files cleanup
      sparc32,sun4d: irq, smp files cleanup
      sparc32,sun4d: drop unused code in sun4d_distribute_irqs()
      sparc32, sun4d: add comment in empty statement in sun4d_request_irq()
      sparc32: irq_32.c cleanup
      sparc32: fix build with leon or floppy enabled
      sparc32: introduce sparc_irq_config
      sparc32: introduce build_device_irq
      sparc32,sun4m: percpu and global register definitions moved to irq.h

 arch/sparc/Kconfig                 |   34 ++++
 arch/sparc/Makefile                |    3 +-
 arch/sparc/boot/Makefile           |   31 ++++
 arch/sparc/include/asm/irq_64.h    |   18 +-
 arch/sparc/include/asm/leon.h      |    3 -
 arch/sparc/include/asm/leon_amba.h |    6 +
 arch/sparc/include/asm/mmu_32.h    |    3 +
 arch/sparc/include/asm/smp_32.h    |    6 +
 arch/sparc/kernel/Makefile         |    2 +-
 arch/sparc/kernel/cpu.c            |    2 +-
 arch/sparc/kernel/entry.h          |    4 +-
 arch/sparc/kernel/iommu.c          |    3 -
 arch/sparc/kernel/ioport.c         |  108 +++++++-----
 arch/sparc/kernel/irq.h            |   42 ++++-
 arch/sparc/kernel/irq_32.c         |  260 +++++++++++++-----------------
 arch/sparc/kernel/irq_64.c         |  312 ++++++++++++++++++------------------
 arch/sparc/kernel/kernel.h         |   49 ++++++
 arch/sparc/kernel/ldc.c            |   28 ++--
 arch/sparc/kernel/leon_kernel.c    |   11 +-
 arch/sparc/kernel/leon_pmc.c       |   82 ++++++++++
 arch/sparc/kernel/leon_smp.c       |   36 ++---
 arch/sparc/kernel/of_device_32.c   |   59 +------
 arch/sparc/kernel/pci.c            |   11 +-
 arch/sparc/kernel/pci_common.c     |   11 +-
 arch/sparc/kernel/pci_fire.c       |   10 +-
 arch/sparc/kernel/pci_impl.h       |    4 +-
 arch/sparc/kernel/pci_msi.c        |   44 +++---
 arch/sparc/kernel/pci_schizo.c     |    4 +-
 arch/sparc/kernel/pci_sun4v.c      |    9 +-
 arch/sparc/kernel/pcr.c            |    2 +-
 arch/sparc/kernel/prom_irqtrans.c  |   16 +-
 arch/sparc/kernel/ptrace_64.c      |    3 +-
 arch/sparc/kernel/setup_32.c       |   19 +--
 arch/sparc/kernel/smp_64.c         |   11 +-
 arch/sparc/kernel/sun4c_irq.c      |   85 ++++++-----
 arch/sparc/kernel/sun4d_irq.c      |  298 +++++++++++++++++++---------------
 arch/sparc/kernel/sun4d_smp.c      |  176 ++++++++-------------
 arch/sparc/kernel/sun4m_irq.c      |  202 +++++++++++------------
 arch/sparc/kernel/sun4m_smp.c      |   91 +++--------
 arch/sparc/kernel/sys_sparc_64.c   |   21 ++-
 arch/sparc/kernel/tick14.c         |   39 -----
 arch/sparc/kernel/time_32.c        |    2 +-
 arch/sparc/kernel/time_64.c        |    4 +-
 arch/sparc/kernel/traps_64.c       |    3 +-
 arch/sparc/kernel/una_asm_64.S     |    2 +-
 arch/sparc/mm/fault_32.c           |    3 +-
 arch/sparc/prom/misc_32.c          |    4 -
 47 files changed, 1117 insertions(+), 1059 deletions(-)
 create mode 100644 arch/sparc/kernel/leon_pmc.c
 delete mode 100644 arch/sparc/kernel/tick14.c
