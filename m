Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2C3G00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:26:26 -0400
Received: from linux-sh.org ([111.68.239.195]:43932 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2C3G0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:26:18 -0400
Date: Fri, 30 Mar 2012 15:26:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.4
Message-ID: <20120330062613.GC26543@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6658a6991cef75719a21441aa0b7f8d6821534ee:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2012-03-27 18:36:38 -0700)

are available in the git repository at:


  git://github.com/pmundt/linux-sh.git sh-for-linus

for you to fetch changes up to b7e68d6876dfbab087bc3859211a9efc74cbe30c:

  sh: Support I/O space swapping where needed. (2012-03-29 16:05:10 +0900)

----------------------------------------------------------------
SuperH updates for 3.4 merge window

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      sh: ecovec: switch SDHI controllers to card polling

Julia Lawall (1):
      arch/sh/drivers/dma/{dma-g2,dmabrg}.c: ensure arguments to request_irq and free_irq are compatible

Matt Fleming (2):
      sh: no need to reset handler if SA_ONESHOT
      sh: use set_current_blocked() and block_sigmask()

Nobuhiro Iwamatsu (3):
      sh/next: Fix build fail by asm/system.h in asm/bitops.h
      sh: dma: Collect up CHCR of SH7723 and SH7730
      sh: dma: Collect up CHCR of SH7763, SH7764, SH7780 and SH7785

Paul Mundt (18):
      sh: intc: Make global intc controller counter static.
      sh: intc: Prefer IRQCHIP_SKIP_SET_WAKE over a dummy set_wake callback.
      sh: intc: Kill off superfluous irq_shutdown hooking.
      sh: intc: Use IRQ_SET_MASK_OK_NOCOPY for intc_set_affinity.
      sh: intc: optimize intc IRQ lookup
      sh: cpufreq: percpu struct clk accounting.
      sh: cpufreq: struct device lookup from CPU topology.
      sh: cpufreq: Support CPU clock frequency table.
      sh: cpufreq: notify about rate rounding fallback.
      sh: cpufreq: Wire up scaling_available_freqs support.
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux into sh-latest
      Merge branch 'sh/cpufreq' into sh-latest
      Merge branch 'common/intc-extension' into sh-latest
      sh: Avoid exporting unimplemented syscalls.
      sh: Consolidate duplicate _32/_64 unistd definitions.
      sh: select ARCH_DISCARD_MEMBLOCK.
      sh: intc: Fix up section mismatch for intc_ack_data
      sh: Support I/O space swapping where needed.

Shimoda, Yoshihiro (1):
      sh: add platform_device for RSPI in setup-sh7757

Takashi YOSHII (1):
      serial: sh-sci: fix a race of DMA submit_tx on transfer

Thomas Schwinge (1):
      SH: pci-sh7780: enable big-endian operation.

 arch/sh/Kconfig                                |    4 +
 arch/sh/boards/mach-ecovec24/setup.c           |  104 ++++++++++++--------
 arch/sh/drivers/dma/dma-g2.c                   |    4 +-
 arch/sh/drivers/dma/dmabrg.c                   |    4 +-
 arch/sh/drivers/pci/pci-sh7780.c               |   15 +++-
 arch/sh/include/asm/bitops.h                   |    1 -
 arch/sh/include/asm/io.h                       |   25 ++---
 arch/sh/include/asm/unistd.h                   |   37 +++++++
 arch/sh/include/asm/unistd_32.h                |  102 ++++++--------------
 arch/sh/include/asm/unistd_64.h                |  106 +++++++--------------
 arch/sh/include/cpu-sh4/cpu/dma-register.h     |   32 ++-----
 arch/sh/include/mach-common/mach/mangle-port.h |   49 ++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c         |   20 ++++
 arch/sh/kernel/cpufreq.c                       |  121 ++++++++++++++++--------
 arch/sh/kernel/signal_32.c                     |   35 ++-----
 arch/sh/kernel/signal_64.c                     |   40 ++------
 arch/sh/kernel/syscalls_32.S                   |    8 +-
 arch/sh/kernel/syscalls_64.S                   |    8 +-
 drivers/sh/intc/chip.c                         |   37 ++------
 drivers/sh/intc/core.c                         |   11 ++-
 drivers/sh/intc/handle.c                       |    5 +-
 drivers/sh/intc/internals.h                    |    9 ++-
 drivers/tty/serial/sh-sci.c                    |   15 ++-
 23 files changed, 420 insertions(+), 372 deletions(-)
 create mode 100644 arch/sh/include/mach-common/mach/mangle-port.h
