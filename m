Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1CVTto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:49:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:16289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1CVTtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,226,1299484800"; 
   d="scan'208";a="900120179"
Subject: [GIT] dmaengine update for 2.6.39
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 12:54:21 -0700
Message-ID: <1300823661.18112.72.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ updates to ste_dma40, dw_dmac and fsldma

2/ A new mxs-dma driver

3/ minor updates and fixes to dmatest and pch_dma

Most of this has been in next for while, the few bits that have not
(fsldma update and a couple fixes) pass my local build test.

The most prominent change from a process perspective is that Vinod Koul
has taken over maintenance of the slave-dma usage model.  I expect that
slave-dma (peripheral to host dma) will continue to grow as the
predominant usage model for the dmaengine interface.  You might start to
see pull requests from him directly in the coming release cycles.

Thanks,
Dan

Dan Williams (4):
      Merge branch 'dma40' into dmaengine
      Merge branch 'dw_dmac' into dmaengine
      Merge branch 'dmaengine-fixes' into dmaengine
      Merge branch 'for_dan' of git://git.infradead.org/users/vkoul/slave-dma into dmaengine

Ira Snyder (9):
      dmatest: fix automatic buffer unmap type
      fsldma: move related helper functions near each other
      fsldma: use channel name in printk output
      fsldma: improve link descriptor debugging
      fsldma: minor codingstyle and consistency fixes
      fsldma: fix controller lockups
      fsldma: support async_tx dependencies and automatic unmapping
      fsldma: reduce locking during descriptor cleanup
      fsldma: make halt behave nicely on all supported controllers

Jamie Iles (4):
      dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
      dmaengine/dw_dmac: allow src/dst masters to be configured at runtime
      dmaengine/dw_dmac: provide a mechanism to indicate private devices
      avr32: at32ap700x: specify DMA src and dst masters

Rabin Vincent (32):
      dma40: make init function static
      dma40: ensure event lines get enabled
      dma40: remove "hardware link with previous jobs" code
      dma40: use helper for channel registers base
      dma40: use helpers for channel type check
      dma40: use helpers for error functions
      dma40: fix comment to refer to SOCs rather than boards
      dma40: allow realtime and priority for event lines
      dma40: remove unnecessary ALIGN()s
      dma40: use sg_dma_address() instead of sg_phys()
      dma40: fix DMA API usage for LCLA
      dma40: fix DMA API usage for LLIs
      dma40: remove unnecessary casts
      dma40: implement prep_memcpy as a wrapper around memcpy_sg
      dma40: combine desc init functions
      dma40: combine duplicated d40_pool_lli_alloc() calls
      dma40: remove duplicated dev addr code
      dma40: combine mem and slave sg-to-lli functions
      dma40: remove export of stedma40_memcpy_sg
      dma40: combine mem and slave prep_sg functions
      dma40: move lli_load to main source file
      dma40: combine duplicated code in log_sg_to_dev
      dma40: unify d40_log_sg_to_lli funcs for mem and slave
      dma40: pass the info pointer all the way to reduce argument count
      dma40: unify src/dst addr check
      dma40: make d40_log_buf_to_lli static
      dma40: use flags to reduce parameter count
      dma40: extract lcla code into separate function
      dma40: handle failure to allocate first LCLA
      dma40: fix DMA_SG capability and channels
      dma40: stop ongoing transfers in DMA_TERMINATE_ALL
      dma40: cyclic xfer support

Rakib Mullick (1):
      drivers, pch_dma: Fix warning when CONFIG_PM=n.

Shawn Guo (1):
      dmaengine: mxs-dma: add dma support for i.MX23/28

Tomoya MORINAGA (2):
      pch_dma: fix kernel error issue
      pch_dma: set the number of array correctly

Uwe Kleine-König (1):
      dma: let IMX_DMA depend on IMX_HAVE_DMA_V1 instead of an explicit list of SoCs

Viresh KUMAR (1):
      dw_dmac: Allow src/dst msize & flow controller to be configured at runtime

Viresh Kumar (14):
      dw_dmac: Remove compilation dependency from AVR32 and put on HAVE_CLK
      dw_dmac: Replace module_init() with subsys_initcall()
      dw_dmac: Move single descriptor from dwc->queue to dwc->active_list in dwc_complete_all
      dw_dmac: Calling dwc_scan_descriptors from dwc_tx_status() after taking lock
      dw_dmac: Adding support for 64 bit access width for memcpy xfers
      dw_dmac: Change value of DWC_MAX_COUNT to 4095.
      dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK after xfer finish
      dw_dmac: Pass Channel Allocation Order from platform_data
      dw_dmac: Pass Channel Priority from platform_data
      dw_dmac: Changing type of src_master and dest_master to u8.
      dw_dmac: Setting Default Burst length for transfers as 16.
      avr32: at32ap700x: Specify DMA Flow Controller, Src and Dst msize
      dmaengine/dw_dmac fix: use readl & writel instead of __raw_readl & __raw_writel
      dmaengine/dmatest: Pass timeout via module params

 arch/arm/mach-mxs/include/mach/dma.h           |   26 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   22 +-
 arch/avr32/mach-at32ap/at32ap700x.c            |   15 +
 drivers/dma/Kconfig                            |   12 +-
 drivers/dma/Makefile                           |    1 +
 drivers/dma/dmatest.c                          |   14 +-
 drivers/dma/dw_dmac.c                          |  103 ++-
 drivers/dma/dw_dmac_regs.h                     |   12 +-
 drivers/dma/fsldma.c                           |  551 +++++-----
 drivers/dma/fsldma.h                           |    6 +-
 drivers/dma/mxs-dma.c                          |  724 ++++++++++++
 drivers/dma/pch_dma.c                          |   35 +-
 drivers/dma/ste_dma40.c                        | 1402 +++++++++++-------------
 drivers/dma/ste_dma40_ll.c                     |  218 ++---
 drivers/dma/ste_dma40_ll.h                     |   66 +-
 include/linux/dw_dmac.h                        |   44 +-
 16 files changed, 1989 insertions(+), 1262 deletions(-)
 create mode 100644 arch/arm/mach-mxs/include/mach/dma.h
 create mode 100644 drivers/dma/mxs-dma.c


