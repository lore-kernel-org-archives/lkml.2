Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1FSLpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:45:09 -0400
Received: from mail.southpole.se ([193.12.106.18]:37737 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1FSLpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:07 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Subject: OpenRISC Architecture: Request for review 
Date: Sun, 19 Jun 2011 13:43:26 +0200
Message-Id: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a port of Linux to the OpenRISC 1000 architecture.

The OpenRISC architecture was conceived with the idea of creating a CPU
with an open specification and freely licensed implementations thereof.
The OR1200 implementation of the OpenRISC 1000 architecture is LGPL licensed,
runs on FPGA's from a broad number of vendors, and is currently being
used in a number of successful industrial projects.

A product of OpenCores.org, development of the OpenRISC architecture has
unfortunately languished for a while buried amongst a multitude of other
projects.  Recently, however, a renewed effort to lift the CPU project out
of its doldrums was initiated by the OpenCores.org management and a community
of participants consisting of both commercial and independent contributors
has rapidly taken shape around this effort.  The project now lives (at
least temporarily) at http://openrisc.net where it can get the attention
it needs.  The active development community around this architecture has
grown from roughly 5 to 25 developers in the last year and we are looking
forward to seeing what may emerge as the community grows and this CPU
architecture is allowed to be developed truly in the open.

We have been tracking upstream Linux with our port since 2.6.35.  Tracking
upstream has been mostly painless as the changes that require architecture
modifications are pretty easy to spot with git.  That said, we want to be
"upstream!"

So here's our code.  The following patches implement support for the
OpenRISC architecture on Linux.  The patch series is broken into functional
units that, hopefully, will facilitate review.

There are a couple of blemishes here and there that we are aware of and
that we aim to clean up in short order.  That said, the important thing is
that the userspace-facing ABI has settled and will not be changing again,
so any necessary cleanups can just as easily be made after the tree is
merged upstream as before.

We are excited by the prospect of getting our work reviewed by our peers and
we are excited by this opportunity to bring the OpenRISC architecture to the
attention of a larger audience.  Thanks for taking the time to consider this
port for inclusion.

The branch 'for-upstream' of the following git repository has the patch
series in this thread:

git://openrisc.net/jonas/linux

Web view for that branch at:

http://git.openrisc.net/cgit.cgi/jonas/linux/log/?h=for-upstream

Notes
-----

See the file README.openrisc for information on getting a toolchain and
simulator for building and running this code.

We currently have only a uClibc port to this architecture and this does
not fully support the reduced set of generic syscalls.  In our upstream
submission we have included only the reduced set of syscalls, while we
will be carrying an out-of-tree patch that enables Linux to work with our
uClibc port until we are able to sort this out.  This shouldn't, however,
need to further delay beginning the code review.

There's a short TODO.openrisc file, as well.  Some of the items listed
there could potentially be done before any pull request for the architecture
is sent.

There are also fair number of places where we still have old test code
laying about inside #ifdefs and comments.  The intention is to get all that
cleaned up before the final pull request, but I didn't want to allow that
to delay beginning the review process any further.

Diff stat follows:

 MAINTAINERS                              |    8 +
 arch/openrisc/Kconfig                    |  245 +++++
 arch/openrisc/Makefile                   |   66 ++
 arch/openrisc/README.openrisc            |  102 ++
 arch/openrisc/TODO.openrisc              |   16 +
 arch/openrisc/boot/Makefile              |   15 +
 arch/openrisc/boot/dts/aac.dts           |  290 ++++++
 arch/openrisc/boot/dts/atlys.dts         |   94 ++
 arch/openrisc/boot/dts/system.dts        |   88 ++
 arch/openrisc/configs/aac_defconfig      |  115 +++
 arch/openrisc/configs/minimal_defconfig  |   69 ++
 arch/openrisc/configs/or1ksim_defconfig  |   67 ++
 arch/openrisc/include/asm/Kbuild         |   62 ++
 arch/openrisc/include/asm/asm-offsets.h  |    1 +
 arch/openrisc/include/asm/bitops.h       |   59 ++
 arch/openrisc/include/asm/bitops/__ffs.h |   32 +
 arch/openrisc/include/asm/bitops/__fls.h |   32 +
 arch/openrisc/include/asm/bitops/ffs.h   |   31 +
 arch/openrisc/include/asm/bitops/fls.h   |   32 +
 arch/openrisc/include/asm/byteorder.h    |    1 +
 arch/openrisc/include/asm/cache.h        |   29 +
 arch/openrisc/include/asm/cacheflush.h   |   25 +
 arch/openrisc/include/asm/cpuinfo.h      |   34 +
 arch/openrisc/include/asm/delay.h        |   44 +
 arch/openrisc/include/asm/dma-mapping.h  |  129 +++
 arch/openrisc/include/asm/elf.h          |  109 ++
 arch/openrisc/include/asm/fixmap.h       |  113 +++
 arch/openrisc/include/asm/gpio.h         |   65 ++
 arch/openrisc/include/asm/io.h           |  220 ++++
 arch/openrisc/include/asm/irq.h          |   27 +
 arch/openrisc/include/asm/irqflags.h     |   29 +
 arch/openrisc/include/asm/linkage.h      |   25 +
 arch/openrisc/include/asm/memblock.h     |   24 +
 arch/openrisc/include/asm/mmu.h          |   26 +
 arch/openrisc/include/asm/mmu_context.h  |   43 +
 arch/openrisc/include/asm/mutex.h        |   27 +
 arch/openrisc/include/asm/page.h         |  112 +++
 arch/openrisc/include/asm/param.h        |   26 +
 arch/openrisc/include/asm/pci.h          |   28 +
 arch/openrisc/include/asm/pgalloc.h      |  142 +++
 arch/openrisc/include/asm/pgtable.h      |  449 +++++++++
 arch/openrisc/include/asm/processor.h    |  117 +++
 arch/openrisc/include/asm/prom.h         |   92 ++
 arch/openrisc/include/asm/ptrace.h       |  124 +++
 arch/openrisc/include/asm/serial.h       |   36 +
 arch/openrisc/include/asm/sigcontext.h   |   38 +
 arch/openrisc/include/asm/smp.h          |   22 +
 arch/openrisc/include/asm/spinlock.h     |   24 +
 arch/openrisc/include/asm/spr_defs.h     |  604 +++++++++++
 arch/openrisc/include/asm/string.h       |   34 +
 arch/openrisc/include/asm/syscall.h      |   78 ++
 arch/openrisc/include/asm/syscalls.h     |   27 +
 arch/openrisc/include/asm/system.h       |   56 +
 arch/openrisc/include/asm/thread_info.h  |  167 +++
 arch/openrisc/include/asm/timex.h        |   35 +
 arch/openrisc/include/asm/tlb.h          |   34 +
 arch/openrisc/include/asm/tlbflush.h     |   72 ++
 arch/openrisc/include/asm/uaccess.h      |  385 +++++++
 arch/openrisc/include/asm/unaligned.h    |   51 +
 arch/openrisc/include/asm/unistd.h       |   29 +
 arch/openrisc/kernel/Makefile            |   14 +
 arch/openrisc/kernel/asm-offsets.c       |   71 ++
 arch/openrisc/kernel/dma.c               |  152 +++
 arch/openrisc/kernel/entry.S             | 1134 +++++++++++++++++++++
 arch/openrisc/kernel/head.S              | 1607 ++++++++++++++++++++++++++++++
 arch/openrisc/kernel/idle.c              |   81 ++
 arch/openrisc/kernel/init_task.c         |   41 +
 arch/openrisc/kernel/irq.c               |  169 ++++
 arch/openrisc/kernel/module.c            |  126 +++
 arch/openrisc/kernel/or32_ksyms.c        |   47 +
 arch/openrisc/kernel/process.c           |  351 +++++++
 arch/openrisc/kernel/prom.c              |  109 ++
 arch/openrisc/kernel/ptrace.c            |  580 +++++++++++
 arch/openrisc/kernel/ptrace.h            |   37 +
 arch/openrisc/kernel/setup.c             |  393 ++++++++
 arch/openrisc/kernel/signal.c            |  410 ++++++++
 arch/openrisc/kernel/sys_call_table.c    |   28 +
 arch/openrisc/kernel/sys_or32.c          |   83 ++
 arch/openrisc/kernel/time.c              |  182 ++++
 arch/openrisc/kernel/traps.c             |  390 ++++++++
 arch/openrisc/kernel/vmlinux.lds.S       |  115 +++
 arch/openrisc/lib/Makefile               |    5 +
 arch/openrisc/lib/delay.c                |   72 ++
 arch/openrisc/lib/string.S               |  204 ++++
 arch/openrisc/mm/Makefile                |    5 +
 arch/openrisc/mm/fault.c                 |  338 +++++++
 arch/openrisc/mm/init.c                  |  329 ++++++
 arch/openrisc/mm/ioremap.c               |  112 +++
 arch/openrisc/mm/tlb.c                   |  198 ++++
 arch/openrisc/or1ksim.cfg                |  888 +++++++++++++++++
 90 files changed, 13447 insertions(+), 0 deletions(-)

