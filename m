Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0J0VkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:40:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:49338 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab0J0VkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,248,1286175600"; 
   d="scan'208";a="567983070"
Subject: [GIT] dmaengine/async_tx update for 2.6.37
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 14:44:15 -0700
Message-ID: <1288215855.32240.21.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ (2) new drivers amba-pl08x and imx-dma.  The imx-dma driver provides
a transition path from the arch-specific dma interface to dmaengine.

2/ Updates to dma40, fsldma, and intel-mid.

3/ New dmaengine operations ->device_prep_dma_sg for scatterlist to
scatterlist transfers and ->device_prep_dma_cyclic for periodic
transfers.

4/ Other cleanups and fixes including the ability to compile out the
async-tx channel switching capability.  Useful for chaining raid
operations, but unused by the bulk of dmaengine drivers which are doing
device-to-memory dma.

The excursions into arch/ are the normal updates to platform device
data, or removal of arch-specific operations obviated by new dmaengine
operations.

Thanks,
Dan

Dan Williams (4):
      Merge branches 'dma40', 'pl08x', 'fsldma', 'imx' and 'intel-mid' into dmaengine
      move async raid6 test to lib/Kconfig.debug
      async_tx: make async_tx channel switching opt-in
      Merge branch 'dma40' into dmaengine

Ira Snyder (4):
      dma: add support for scatterlist to scatterlist copy
      fsldma: implement support for scatterlist to scatterlist copy
      fsldma: improved DMA_SLAVE support
      ste_dma40: implement support for scatterlist to scatterlist copy

Jonas Aaberg (13):
      DMAENGINE: ste_dma40: Fix failed to restart logical channel bug
      DMAENGINE: ste_dma40: No need reading, masking and setting a set register
      DMAENGINE: ste_dma40: Code clean-up and removed an unneeded suspend request
      DMAENGINE: ste_dma40: fix bug related to callback handling
      DMAENGINE: ste_dma40: removed a few magic numbers
      DMAENGINE: ste_dma40: added support for link jobs in hw
      DMAENGINE: ste_dma40: code clean-up
      DMAENGINE: ste_dma40: corrected is_paused behavior
      DMAENGINE: ste_dma40: fix possible use of uninitialized variable
      DMAENGINE: ste_dma40: rewrote LCLA entries allocation code
      DMAENGINE: ste_dma40: removed non-used variable from struct
      DMAENGINE: ste_dma40: don't pause/resume non-executing channels
      DMAENGINE: ste_dma40: added kernel doc for struct

Koul, Vinod (3):
      intel_mid_dma: Add runtime PM support
      intel_mid_dma: fix the WARN_ONs
      intel_mid_dma: change the slave interface

Linus Walleij (4):
      DMAENGINE: ste_dma40: config checks
      dmaengine: driver for the ARM PL080/PL081 PrimeCells v5
      DMAENGINE: define a dummy filter function for ste_dma40
      DMAENGINE: move COH901318 to arch_initcall

Nicolas Kaiser (1):
      dma/timberdale: simplify conditional

Per Forlin (2):
      DMAENGINE: Set burst size for phy and log chans in ste_dma40 dev_control
      DMAENGINE: Remove stedma40_set_psize and pre_transfer hook in ste_dma40

Rabin Vincent (11):
      DMAENGINE: ste_dma40: fix disabled channels list
      DMAENGINE: ste_dma40: fix clk_get failure path
      DMAENGINE: ste_dma40: fix desc_get
      DMAENGINE: ste_dma40: fix resource leaks in error paths.
      ste_dma40: add variable to indicate valid dma_cfg
      ste_dma40: move priority to separate field
      ste_dma40: move channel mode to a separate field
      ste_dma40: move mode_opt to separate config
      ste_dma40: remove TIM_FOR_LINK option
      ste_dma40: remove enum for endianess
      ste_dma40: remove channel_type

Ramesh Babu K V (1):
      intel_mid_dma: Add sg list support to DMA driver

Sascha Hauer (5):
      dmaengine: add possibility for cyclic transfers
      dmaengine: add wrapper functions for device control functions
      dmaengine: Add Freescale i.MX SDMA support
      dmaengine: Add Freescale i.MX1/21/27 DMA driver
      dma: imx-dma: fix signedness bug

Yong Wang (2):
      intel_mid_dma: Allow IRQ sharing
      intel_mid_dma: Allow DMAC2 to share interrupt

 arch/arm/mach-imx/include/mach/dma-v1.h        |    8 +-
 arch/arm/mach-ux500/devices-db8500.c           |   13 +-
 arch/arm/plat-mxc/include/mach/dma.h           |   67 +
 arch/arm/plat-mxc/include/mach/sdma.h          |   17 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |  134 +-
 arch/powerpc/include/asm/fsldma.h              |  137 --
 crypto/async_tx/Kconfig                        |   13 -
 drivers/dma/Kconfig                            |   31 +-
 drivers/dma/Makefile                           |    3 +
 drivers/dma/amba-pl08x.c                       | 2167 ++++++++++++++++++++++++
 drivers/dma/coh901318.c                        |    2 +-
 drivers/dma/dmaengine.c                        |    8 +-
 drivers/dma/fsldma.c                           |  328 ++--
 drivers/dma/imx-dma.c                          |  424 +++++
 drivers/dma/imx-sdma.c                         | 1392 +++++++++++++++
 drivers/dma/intel_mid_dma.c                    |  476 +++++-
 drivers/dma/intel_mid_dma_regs.h               |   53 +-
 drivers/dma/ste_dma40.c                        | 1023 ++++++-----
 drivers/dma/ste_dma40_ll.c                     |  180 +--
 drivers/dma/ste_dma40_ll.h                     |   86 +-
 drivers/dma/timb_dma.c                         |    2 +-
 include/linux/amba/pl08x.h                     |  222 +++
 include/linux/dmaengine.h                      |   60 +-
 include/linux/intel_mid_dma.h                  |   16 +-
 lib/Kconfig.debug                              |   13 +
 25 files changed, 5716 insertions(+), 1159 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/dma.h
 create mode 100644 arch/arm/plat-mxc/include/mach/sdma.h
 delete mode 100644 arch/powerpc/include/asm/fsldma.h
 create mode 100644 drivers/dma/amba-pl08x.c
 create mode 100644 drivers/dma/imx-dma.c
 create mode 100644 drivers/dma/imx-sdma.c
 create mode 100644 include/linux/amba/pl08x.h

commit 964dc256bb91e990277010a3f6dc66daa130be8b
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Thu Oct 21 21:04:38 2010 +0200

    DMAENGINE: move COH901318 to arch_initcall
    
    After moving the PL022 driver to subsys_initcall() due to the need
    of having stuff like regulators on the other end of the SPI link,
    I noticed that the COH901318 DMA engine will get probed before
    the DMA engine, so move it to an arch_initcall().
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8267f16e8b67ea272f37f7072933dc0d3839693d
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Oct 20 08:37:19 2010 +0200

    dma: imx-dma: fix signedness bug
    
    mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
    failed imx_dma_request_by_prio() made no sence.  Explicitly check
    signed values.
    Also, fix uninitialzed use of ret.
    
    Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 42e55736f7efd7658f8826a5f441c3ccb962db74
Merge: 9cb047d 5c37209
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Oct 19 15:34:26 2010 -0700

    Merge branch 'dma40' into dmaengine

commit 9cb047d4d19fc15791a64d900d483405eae6200d
Author: Nicolas Kaiser <nikai@nikai.net>
Date:   Fri Oct 8 00:48:01 2010 +0200

    dma/timberdale: simplify conditional
    
    Simplify: ((a && b) || (!a && !b)) => (a == b)
    
    Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
    Acked-by: Jack Stone <jwjstone@fastmail.fm>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5c3720935813c45c2893fdb53eb6f73f1aee93c7
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:55 2010 +0000

    ste_dma40: remove channel_type
    
    It has been replaced with separate fields.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 51f5d744ed07a6b82e5cbbeeabd73605d62dcfc9
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:54 2010 +0000

    ste_dma40: remove enum for endianess
    
    A bool will suffice.  The default is little endian.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4a6aed3c4eb69702335ed3689132d07eabaaf86d
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:53 2010 +0000

    ste_dma40: remove TIM_FOR_LINK option
    
    This does not seem to be implemented.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 20a5b6d043a9a12d01cec76993ba3658a6d36ba7
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:52 2010 +0000

    ste_dma40: move mode_opt to separate config
    
    Defaults are "basic mode" for physical channels, and "logical source
    logical destination" for logical channels.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 38bdbf020ad7ae1bca564a7db238cdf8b2f462a8
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:51 2010 +0000

    ste_dma40: move channel mode to a separate field
    
    And keep it logical by default.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 730c1871680774ea0700debc2981c7a53f51d92e
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:50 2010 +0000

    ste_dma40: move priority to separate field
    
    And keep it low priority by default.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ce2ca1252ba8688a4997b4104793540f4c28c0d8
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Tue Oct 12 13:00:49 2010 +0000

    ste_dma40: add variable to indicate valid dma_cfg
    
    Since we want to reduce the amount of required channel
    configuration and remove channel_type, don't depend on it
    to indicate whether the configuration is valid.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5fc6d897fde352bad5db5767e7260741a8cdd9e9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Oct 7 16:44:50 2010 -0700

    async_tx: make async_tx channel switching opt-in
    
    The majority of drivers in drivers/dma/ will never establish cross
    channel operation chains and do not need the extra overhead in struct
    dma_async_tx_descriptor.  Make channel switching opt-in by default.
    
    Cc: Anatolij Gustschin <agust@denx.de>
    Cc: Ira Snyder <iws@ovro.caltech.edu>
    Cc: Linus Walleij <linus.walleij@stericsson.com>
    Cc: Saeed Bishara <saeed@marvell.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 400fb7f6a0cfe13025cb0296fdb4737da7025a8a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Oct 7 15:25:04 2010 -0700

    move async raid6 test to lib/Kconfig.debug
    
    The prompt for "Self test for hardware accelerated raid6 recovery" does not
    belong in the top level configuration menu.  All the options in
    crypto/async_tx/Kconfig are selected and do not depend on CRYPTO.
    Kconfig.debug seems like a reasonable fit.
    
    Cc: Herbert Xu <herbert@gondor.apana.org.au>
    Cc: David Woodhouse <David.Woodhouse@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6391987d6f8ced7d0fafaa1440dcc57bb4b34d8f
Merge: 9646b79 e8689e6 0d68866 1f1846c 20dd639
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Oct 7 15:19:01 2010 -0700

    Merge branches 'dma40', 'pl08x', 'fsldma', 'imx' and 'intel-mid' into dmaengine

commit 1f1846c6ceed07c03ef036a27864befe0f773997
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Oct 6 10:25:55 2010 +0200

    dmaengine: Add Freescale i.MX1/21/27 DMA driver
    
    This driver is currently implemented as a user to the old i.MX
    DMA API. This allows us to convert each user of the old API to
    the dmaengine API one by one. Once this is done the old DMA
    driver can be merged into the i.MX dmaengine driver.
    
    V2: remove some debug leftovers and unused variables
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 20dd63900d238e17b122fe0c7376ff090867f528
Author: Koul, Vinod <vinod.koul@intel.com>
Date:   Mon Oct 4 10:38:43 2010 +0000

    intel_mid_dma: change the slave interface
    
    In 2.6.36 kernel, dma slave control command was introduced,
    this patch changes the intel-mid-dma driver to this
    new kernel slave interface
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8b6492231d2a92352a6371eebd622e3bc824a663
Author: Koul, Vinod <vinod.koul@intel.com>
Date:   Mon Oct 4 10:38:25 2010 +0000

    intel_mid_dma: fix the WARN_ONs
    
    Moved the WARN_ON to BUG_ON, as WARN_ON if hit,
    can cause null pointer derefrences
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 576e3c394a6c427c9a1378ec88ef7eb97e731992
Author: Ramesh Babu K V <ramesh.b.k.v@intel.com>
Date:   Mon Oct 4 10:37:53 2010 +0000

    intel_mid_dma: Add sg list support to DMA driver
    
    For a very high speed DMA various periphral devices need
    scatter-gather list support. The DMA hardware support link list items.
    This list can be circular also (adding new flag DMA_PREP_CIRCULAR_LIST)
    Right now this flag is in driver header and should be moved to
    dmaengine header file eventually
    
    Signed-off-by: Ramesh Babu K V <ramesh.b.k.v@intel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 03b96dca010145f3896abcd443b7fddb9813a0e6
Author: Yong Wang <yong.y.wang@intel.com>
Date:   Mon Oct 4 10:37:27 2010 +0000

    intel_mid_dma: Allow DMAC2 to share interrupt
    
    Allow DMAC2 to share interrupt since exclusive interrupt line
    for mrst DMAC2 is not provided on other platforms.
    
    Signed-off-by: Yong Wang <yong.y.wang@intel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b306df5e925bb584b2157f11f97c5eb20a13de4d
Author: Yong Wang <yong.y.wang@intel.com>
Date:   Mon Oct 4 10:37:02 2010 +0000

    intel_mid_dma: Allow IRQ sharing
    
    intel_mid_dma driver allows interrupt sharing. Thus it needs
    to check whether IRQ source is the DMA controller and return
    the appropriate IRQ return.
    
    Signed-off-by: Yong Wang <yong.y.wang@intel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 53a61badf47e674fb43d73cd22f0f8065098ddf6
Author: Koul, Vinod <vinod.koul@intel.com>
Date:   Mon Oct 4 10:42:40 2010 +0000

    intel_mid_dma: Add runtime PM support
    
    This patch adds runtime PM support in this dma driver
    for 4 PCI Controllers
    Whenever the driver is idle (no channels grabbed), it
    can go to low power state
    It also adds the PCI suspend and resume support
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9646b7985e906e5fcea9375f016b4519c8318c21
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed Oct 6 09:05:29 2010 +0000

    DMAENGINE: define a dummy filter function for ste_dma40
    
    All platform data has to be made conditional on CONFIG_STEDMA40
    or we can provide a simple dummy filter functions as to avoid
    cluttering the code with other #ifdef:s.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 661385f9c34e15c2f2c57b80e8cb2c7b910fdbd3
Author: Per Forlin <per.friden@stericsson.com>
Date:   Wed Oct 6 09:05:28 2010 +0000

    DMAENGINE: Remove stedma40_set_psize and pre_transfer hook in ste_dma40
    
    Remove obsolete pre_transfer hook in stedma40_chan_cfg. The
    intent of this hook is merely to handle burst size
    compensation for ux500 variant MMCI. Remove obsolete stedma40_set_psize
    since it is only called from pre_transfer. DMAEngine device_control
    replaces the functionality of stedma40_set_psize.
    
    Signed-off-by: Per Forlin <per.forlin@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a59670a40b4dd497630f9442feb259dde601e469
Author: Per Forlin <per.friden@stericsson.com>
Date:   Wed Oct 6 09:05:27 2010 +0000

    DMAENGINE: Set burst size for phy and log chans in ste_dma40 dev_control
    
    Set burst for physical or logical channels respectively.
    Convert the values in dma_cfg to dma reg bits
    for physical or logical channels.
    
    Signed-off-by: Per Forlin <per.forlin@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 819504f4861a5bc1e25c82409956388bb79fb635
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Wed Oct 6 08:20:38 2010 +0000

    DMAENGINE: ste_dma40: fix resource leaks in error paths.
    
    Fix some leaks of allocated descriptors in error paths.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a2c15fa4c122558472f8041515072218c8652c7e
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Wed Oct 6 08:20:37 2010 +0000

    DMAENGINE: ste_dma40: fix desc_get
    
    Fix desc_get to alloc a descriptor from the cache if the ones in the
    list are waiting for the ack.  Also, memzero the descriptor when
    allocated from the list to ensure all fields are cleared.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c6134c967c5b8b5986371de335fa4ec39de268bc
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Wed Oct 6 08:20:36 2010 +0000

    DMAENGINE: ste_dma40: fix clk_get failure path
    
    clk_get returns an ERR_PTR.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f57b407cfd5fbd70251e9fa0ea7aa083ac06d25c
Author: Rabin Vincent <rabin.vincent@stericsson.com>
Date:   Wed Oct 6 08:20:35 2010 +0000

    DMAENGINE: ste_dma40: fix disabled channels list
    
    The value in the array, not the index, specifies the channel to be
    disabled.
    
    Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0d688662aab9d80078be82aa5aea561346643298
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu Sep 30 11:46:47 2010 +0000

    ste_dma40: implement support for scatterlist to scatterlist copy
    
    Now that the DMAEngine API has support for scatterlist to scatterlist
    copy, implement support for the STE DMA40 DMA controller.
    
    Cc: Linus Walleij <linus.ml.walleij@gmail.com>
    Acked-by: Per Fridén <per.friden@stericsson.com>
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 968f19ae802fdc6b6b6b5af6fe79cf23d281be0f
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu Sep 30 11:46:46 2010 +0000

    fsldma: improved DMA_SLAVE support
    
    Now that the generic DMAEngine API has support for scatterlist to
    scatterlist copying, the device_prep_slave_sg() portion of the
    DMA_SLAVE API is no longer necessary and has been removed.
    
    However, the device_control() portion of the DMA_SLAVE API is still
    useful to control device specific parameters, such as externally
    controlled DMA transfers and maximum burst length.
    
    A special dma_ctrl_cmd has been added to enable externally controlled
    DMA transfers. This is currently specific to the Freescale DMA
    controller, but can easily be made generic when another user is found.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c14330417ef2050f4bf38ac20e125785fea14351
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu Sep 30 11:46:45 2010 +0000

    fsldma: implement support for scatterlist to scatterlist copy
    
    Now that the DMAEngine API has support for scatterlist to scatterlist
    copy, implement support for the Freescale DMA controller.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a86ee03ce6f279ebe581a7a8c0c4393eaeb789ee
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu Sep 30 11:46:44 2010 +0000

    dma: add support for scatterlist to scatterlist copy
    
    This adds support for scatterlist to scatterlist DMA transfers. A
    similar interface is exposed by the fsldma driver (through the DMA_SLAVE
    API) and by the ste_dma40 driver (through an exported function).
    
    This patch paves the way for making this type of copy operation a part
    of the generic DMAEngine API. Futher patches will add support in
    individual drivers.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1ec1e82f2510e2bdcb6268ed74aa79e1a7bc9594
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Thu Sep 30 13:56:34 2010 +0000

    dmaengine: Add Freescale i.MX SDMA support
    
    This patch adds support for the Freescale i.MX SDMA engine.
    
    The SDMA engine is a scatter/gather DMA engine which is implemented
    as a seperate coprocessor. SDMA needs its own firmware which is
    requested using the standard request_firmware mechanism. The firmware
    has different entry points for each peripheral type, so drivers
    have to pass the peripheral type to the DMA engine which in turn
    picks the correct firmware entry point from a table contained in
    the firmware image itself.
    The original Freescale code also supports support for transfering
    data to the internal SRAM which needs different entry points to
    the firmware. Support for this is currently not implemented. Also,
    support for the ASRC (asymmetric sample rate converter) is skipped.
    
    I took a very simple approach to implement dmaengine support. Only
    a single descriptor is statically assigned to a each channel. This
    means that transfers can't be queued up but only a single transfer
    is in progress. This simplifies implementation a lot and is sufficient
    for the usual device/memory transfers.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Reviewed-by: Linus Walleij <linus.ml.walleij@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6e3ecaf0ad49de0bed829d409a164e7107c02993
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Thu Sep 30 13:56:33 2010 +0000

    dmaengine: add wrapper functions for device control functions
    
    Add wrapper functions around the dma_device->device_control function
    to bring back type safety. Also, add a wrapper function around
    dma_async_tx_descriptor->tx_submit. This is named dmaengine_submit
    instead of dmaengine_tx_submit to get rid of the confusing 'tx' in the
    function name
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 782bc950d84e404422ba21008fd51ee894c8d231
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Thu Sep 30 13:56:32 2010 +0000

    dmaengine: add possibility for cyclic transfers
    
    Cyclic transfers are useful for audio where a single buffer divided
    in periods has to be transfered endlessly until stopped. After being
    prepared the transfer is started using the dma_async_descriptor->tx_submit
    function. dma_async_descriptor->callback is called after each period.
    The transfer is stopped using the DMA_TERMINATE_ALL callback.
    While being used for cyclic transfers the channel cannot be used
    for other transfer types.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e8689e63d4d2046079f2db9d494ac05c6885ac0c
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Sep 28 15:57:37 2010 +0200

    dmaengine: driver for the ARM PL080/PL081 PrimeCells v5
    
    This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
    based on the implementation earlier submitted by Peter Pearse.
    This is working like a charm for memcpy and slave DMA to the PL011
    PrimeCell on the PB11MPCore.
    
    This DMA controller is used in mostly unmodified form in the ARM
    RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
    in the ST SPEAr platform.
    
    It has been converted to use the header from the Samsung PL080
    derivate instead of its own defintions. The Samsungs have a custom
    driver in their mach-* folders though, atleast we can share the
    register definitions.
    
    Cc: Peter Pearse <peter.pearse@arm.com>
    Cc: Ben Dooks <ben-linux@fluff.org>
    Cc: Kukjin Kim <kgene.kim@samsung.com>
    Cc: Alessandro Rubini <rubini@unipv.it>
    Acked-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    [GFP_KERNEL to GFP_NOWAIT in pl08x_prep_dma_memcpy]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3c0f24019f69c5199996ed9c76d05c92c6186ba8
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:09:21 2010 +0000

    DMAENGINE: ste_dma40: added kernel doc for struct
    
    The half-channel struct was undocumented.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3ac012af3b1b3a6b373f3a9f19c5362974856c2c
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:09:12 2010 +0000

    DMAENGINE: ste_dma40: don't pause/resume non-executing channels
    
    There is no point in pausing what isn't running.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8f6fd7f50f7059e5725a36885af52e54b9df96b2
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:09:04 2010 +0000

    DMAENGINE: ste_dma40: removed non-used variable from struct
    
    The reqrite of the LCLA code rendered this variable unused.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 698e4732e7c9cf9f1f3eac2b8cdce8d4fe2b90bd
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:56 2010 +0000

    DMAENGINE: ste_dma40: rewrote LCLA entries allocation code
    
    LLI allocation is now done on job level instead of channel level.
    Previously the maximum length of a linked job in hw on a logical
    channel was 8, since the LLIs where evenly divided. Now only
    executing jobs have allocated LLIs which increase the length to
    a maximum of 64 links in HW.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 69f93faa57ed6c91b32aae1dcff7282fcb2872f5
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:49 2010 +0000

    DMAENGINE: ste_dma40: fix possible use of uninitialized variable
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9dbfbd35ce16e4f5a4d0d9e3f6e012b136fe80ea
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:41 2010 +0000

    DMAENGINE: ste_dma40: corrected is_paused behavior
    
    The handling of pause detection was slightly incorrect.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 767a9675c4a68ada55f0f30d629db627bd47f012
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:34 2010 +0000

    DMAENGINE: ste_dma40: code clean-up
    
    This patch includes non functional code clean up changes,
    file header updates and a few magic numbers got defined.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit aa182ae2621877e0c111922696c84c538b82ad14
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:26 2010 +0000

    DMAENGINE: ste_dma40: added support for link jobs in hw
    
    If a new job is added on a physical channel that already has
    a job, the new job is linked in hw to the old job instead of
    queueing up the jobs.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3ae0267fd569c2007235fb80cfe3b4a4c54c8f4b
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:18 2010 +0000

    DMAENGINE: ste_dma40: removed a few magic numbers
    
    Make sure to extract the revision field explicitly and document
    what bits are being accessed here without magic numbers.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0246e77b4d374bb37aa08c3fcadad20012e85ea0
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:10 2010 +0000

    DMAENGINE: ste_dma40: fix bug related to callback handling
    
    The callback got called even when it was not supposed to. Also
    removed some not needed interrupt trigger on/off code.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b55912c66a317d9aaf4749488ca43d510c8a8a87
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:08:02 2010 +0000

    DMAENGINE: ste_dma40: Code clean-up and removed an unneeded suspend request
    
    This patch cleans up some code and removes a suspend request that was pointless
    since the hw was never configured nor running when it was called.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1b00348d5d0b3423fe21f499bf30d40a4d1dc594
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:07:54 2010 +0000

    DMAENGINE: ste_dma40: No need reading, masking and setting a set register
    
    Removes an unnecessary register read and a few lines of code.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit be8cb7dfd92420b12dfd6831c2d638f4f46bdfdf
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Mon Aug 9 12:07:44 2010 +0000

    DMAENGINE: ste_dma40: Fix failed to restart logical channel bug
    
    A transfer that runs in the different direction on the same
    channel will now be resumed when the other is suspend/stopped.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0747c7bae5c93377f4ea81b55d6851eaddc677fe
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Aug 9 12:07:36 2010 +0000

    DMAENGINE: ste_dma40: config checks
    
    Added various configuration checks.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


