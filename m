Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0EUXVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:21:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:25778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0EUXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,280,1272870000"; 
   d="scan'208";a="800822924"
Subject: Re: [GIT PULL] dmaengine/async_tx update for 2.6.35
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1274308081.12124.24.camel@dwillia2-linux>
References: <1274308081.12124.24.camel@dwillia2-linux>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 16:20:15 -0700
Message-ID: <1274484015.20755.4.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 15:28 -0700, Dan Williams wrote:
> Hi Linus, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
> 
> ...to receive:

I think this got overlooked (other pull requests from later in the week
have gone in).

Thanks,
Dan

> 
> 1/ Two new dma drivers ste_dma40 and timb_dma.
> 2/ A rework of the existing channel-status and channel-control api's to
> make them more generic/extensible.  Hence the touch-ups to existing dma
> drivers and the excursions into drivers/video/, drivers/serial/, and
> sound/.
> 3/ An update to the ioat driver to allow descriptor submission to run
> unlocked against descriptor cleanup.
> 4/ Other cleanups and fixes
> 
> There is one more driver to submit, but it depended on the merge of the
> ARM tree and will be sent separately.  As you can see below there were a
> few late patches, but they have seen at least one -next release.
> 
> Thanks,
> Dan
> 
> Dan Williams (6):
>       dmaengine: provide helper for setting txstate
>       ioat: convert to circ_buf
>       ioat2,3: convert to producer/consumer locking
>       ioat3: disable cacheline-unaligned transfers for raid operations
>       async_tx: trim dma_async_tx_descriptor in 'no channel switch' case
>       Merge branch 'ioat' into dmaengine
> 
> Jassi Brar (1):
>       DMA ENGINE: Do not reset 'private' of channel
> 
> Jonas Aaberg (1):
>       DMAENGINE: DMA40 support paused channel status
> 
> Linus Walleij (6):
>       DMAENGINE: COH 901 318 rename confusing vars
>       DMAENGINE: COH 901 318 fix bytesleft
>       DMAENGINE: generic slave control v2
>       DMAENGINE: generic channel status v2
>       DMAENGINE: Support for ST-Ericssons DMA40 block v3
>       DMAENGINE: extend the control command to include an arg
> 
> Marcin Mielczarczyk (1):
>       DMAENGINE: DMA40 fix for allocation of logical channel 0
> 
> Minskey Guo (1):
>       ioat: Remove duplicated devm_kzalloc() calls for ioatdma_device
> 
> Richard Röjfors (2):
>       dma: Add timb-dma
>       dma: timb-dma: Update comment and fix compiler warning
> 
> Stephen Rothwell (1):
>       async_tx: use of kzalloc/kfree requires the include of slab.h
> 
> Tobias Klauser (1):
>       dmaengine: mpc512x: Use resource_size
> 
>  arch/arm/mach-u300/include/mach/coh901318.h    |   21 -
>  arch/arm/plat-nomadik/include/plat/ste_dma40.h |  239 +++
>  crypto/async_tx/async_tx.c                     |   46 +-
>  drivers/dma/Kconfig                            |   14 +
>  drivers/dma/Makefile                           |    2 +
>  drivers/dma/at_hdmac.c                         |   35 +-
>  drivers/dma/coh901318.c                        |  263 ++-
>  drivers/dma/dmaengine.c                        |   22 +-
>  drivers/dma/dw_dmac.c                          |   24 +-
>  drivers/dma/fsldma.c                           |   28 +-
>  drivers/dma/ioat/dma.c                         |   12 +-
>  drivers/dma/ioat/dma.h                         |   19 +-
>  drivers/dma/ioat/dma_v2.c                      |  186 +-
>  drivers/dma/ioat/dma_v2.h                      |   33 +-
>  drivers/dma/ioat/dma_v3.c                      |  143 +-
>  drivers/dma/ioat/pci.c                         |    7 +-
>  drivers/dma/iop-adma.c                         |   39 +-
>  drivers/dma/ipu/ipu_idmac.c                    |   34 +-
>  drivers/dma/mpc512x_dma.c                      |   15 +-
>  drivers/dma/mv_xor.c                           |   25 +-
>  drivers/dma/ppc4xx/adma.c                      |   19 +-
>  drivers/dma/shdma.c                            |   27 +-
>  drivers/dma/ste_dma40.c                        | 2657 ++++++++++++++++++++++++
>  drivers/dma/ste_dma40_ll.c                     |  454 ++++
>  drivers/dma/ste_dma40_ll.h                     |  354 ++++
>  drivers/dma/timb_dma.c                         |  860 ++++++++
>  drivers/dma/txx9dmac.c                         |   23 +-
>  drivers/mmc/host/atmel-mci.c                   |    2 +-
>  drivers/serial/sh-sci.c                        |    2 +-
>  drivers/video/mx3fb.c                          |    3 +-
>  include/linux/dmaengine.h                      |  127 ++-
>  include/linux/timb_dma.h                       |   55 +
>  sound/soc/txx9/txx9aclc.c                      |    7 +-
>  33 files changed, 5286 insertions(+), 511 deletions(-)
>  create mode 100644 arch/arm/plat-nomadik/include/plat/ste_dma40.h
>  create mode 100644 drivers/dma/ste_dma40.c
>  create mode 100644 drivers/dma/ste_dma40_ll.c
>  create mode 100644 drivers/dma/ste_dma40_ll.h
>  create mode 100644 drivers/dma/timb_dma.c
>  create mode 100644 include/linux/timb_dma.h
> 
> commit 0b28330e39bbe0ffee4c56b09fc415fcec595ea3
> Merge: 0582763 caa20d97
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Mon May 17 16:30:58 2010 -0700
> 
>     Merge branch 'ioat' into dmaengine
> 
> commit 058276303dbc4ed089c1f7dad0871810b1f5ddf1
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Mon May 17 16:30:42 2010 -0700
> 
>     DMAENGINE: extend the control command to include an arg
>     
>     This adds an argument to the DMAengine control function, so that
>     we can later provide control commands that need some external data
>     passed in through an argument akin to the ioctl() operation
>     prototype.
>     
>     [dan.j.williams@intel.com: fix up some missed conversions]
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit caa20d974c86af496b419eef70010e63b7fab7ac
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Mon May 17 16:24:16 2010 -0700
> 
>     async_tx: trim dma_async_tx_descriptor in 'no channel switch' case
>     
>     Saves 24 bytes per descriptor (64-bit) when the channel-switching
>     capabilities of async_tx are not required.
>     
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 4aed79b2818e7330b5d00143e4c20bc6555df91f
> Author: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
> Date:   Tue May 18 00:41:21 2010 +0200
> 
>     DMAENGINE: DMA40 fix for allocation of logical channel 0
>     
>     Fix for allocation failure of logical channel when event line
>     happens to be number 0.
>     
>     Signed-off-by: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit a5ebca4769f28ceade28ff59fcbffb8e184e599c
> Author: Jonas Aaberg <jonas.aberg@stericsson.com>
> Date:   Tue May 18 00:41:09 2010 +0200
> 
>     DMAENGINE: DMA40 support paused channel status
>     
>     Support determining whether a channel is paused or
>     not using the status function.
>     
>     Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 8381fc35244dbdf58cfc49e04e0d7c3498c8aa03
> Author: Tobias Klauser <tklauser@distanz.ch>
> Date:   Thu May 6 11:58:55 2010 +0200
> 
>     dmaengine: mpc512x: Use resource_size
>     
>     Use the resource_size function instead of manually calculating the
>     resource size.  This reduces the chance of introducing off-by-one
>     errors.
>     
>     Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit cc05ea0cd63437da2033b3ce6e033b1f1aaaf640
> Author: Jassi Brar <jassi.brar@samsung.com>
> Date:   Tue May 4 18:22:15 2010 +0900
> 
>     DMA ENGINE: Do not reset 'private' of channel
>     
>     The member 'private' of 'struct dma_chan' is meant for passing
>     data between client and the controller driver.
>     
>     The DMA client driver may point it to platform specific stuff after
>     acquiring the channel. So, it is the responsiblity of the same code
>     to reset it, if it must.
>     
>     The DMA engine doesn't set it and hence, shouldn't reset it either.
>     
>     This reseting of private by DMA Engine comes in the way of implementing
>     default channel settings during DMAC probe. That capability is useful
>     for not having the clients to always provide platform specific data,
>     like Rx/Tx FIFO addresses, which usually doesn't change across channel
>     requests.
>     
>     Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit c86e1401c9f2ba8d989fa1c4b33d0f0ec3ba8aaf
> Author: Minskey Guo <chaohong_guo@linux.intel.com>
> Date:   Sun May 2 12:52:35 2010 -0700
> 
>     ioat: Remove duplicated devm_kzalloc() calls for ioatdma_device
>     
>     The memory for ioatdma_device structure is being allocated in
>     alloc_ioatdma()
>     
>     Signed-off-by: Minskey Guo <chaohong_guo@linux.intel.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 2adfc550b6d9646301c810643bc309fa49375987
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Sat May 1 15:22:56 2010 -0700
> 
>     ioat3: disable cacheline-unaligned transfers for raid operations
>     
>     There are cases where cacheline-unaligned raid operations can hang the
>     dma channel.  Simply disable these operations by increasing the
>     alignment constraints published to async_tx.  The raid456 driver always
>     issues page aligned requests, so the only in-kernel user of the ioatdma
>     driver that is affected by this change is dmatest.
>     
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 074cc47679f8b0931d7d5384e95822d82768f149
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Sat May 1 15:22:55 2010 -0700
> 
>     ioat2,3: convert to producer/consumer locking
>     
>     Use separate locks for the descriptor prep (producer) and descriptor
>     cleanup (consumer) paths.  Allows the producer path to run concurrently
>     with the cleanup path.  Inspired by Documentation/circular-buffer.txt.
>     
>     Cc: David Howells <dhowells@redhat.com>
>     Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit abb12dfd50c7580d7dcbd581cf6265ba4d01ea7e
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Sat May 1 15:22:54 2010 -0700
> 
>     ioat: convert to circ_buf
>     
>     Use the common power-of-2 circular buffer macros.
>     
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 8d318a50b3d72e3daf94131f91e1ab799a8d5ad4
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Tue Mar 30 15:33:42 2010 +0200
> 
>     DMAENGINE: Support for ST-Ericssons DMA40 block v3
>     
>     This is a straightforward driver for the ST-Ericsson DMA40 DMA
>     controller found in U8500, implemented akin to the existing
>     COH 901 318 driver.
>     
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Acked-by: Srinidh Kasagar <srinidhi.kasagar@stericsson.com>
>     Cc: STEricsson_nomadik_linux@list.st.com
>     Cc: Alessandro Rubini <rubini@unipv.it>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 6a3cd3ea48584d14f60dce0b3c4e9e4428beb0fe
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Mar 29 15:54:40 2010 +1100
> 
>     async_tx: use of kzalloc/kfree requires the include of slab.h
>     
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit bca3469205402d9fb14060d255d8786ae2256640
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Fri Mar 26 16:52:10 2010 -0700
> 
>     dmaengine: provide helper for setting txstate
>     
>     Simple conditional struct filler to cut out some duplicated code.
>     
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 0793448187643b50af89d36b08470baf45a3cab4
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Fri Mar 26 16:50:49 2010 -0700
> 
>     DMAENGINE: generic channel status v2
>     
>     Convert the device_is_tx_complete() operation on the
>     DMA engine to a generic device_tx_status()operation which
>     can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
>     DMA_TX_PAUSED.
>     
>     [dan.j.williams@intel.com: update for timberdale]
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>     Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
>     Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>     Cc: Pavel Machek <pavel@ucw.cz>
>     Cc: Li Yang <leoli@freescale.com>
>     Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>     Cc: Paul Mundt <lethal@linux-sh.org>
>     Cc: Ralf Baechle <ralf@linux-mips.org>
>     Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
>     Cc: Magnus Damm <damm@opensource.se>
>     Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>     Cc: Joe Perches <joe@perches.com>
>     Cc: Roland Dreier <rdreier@cisco.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit c3635c78e500a52c9fcd55de381a72928d9e054d
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Fri Mar 26 16:44:01 2010 -0700
> 
>     DMAENGINE: generic slave control v2
>     
>     Convert the device_terminate_all() operation on the
>     DMA engine to a generic device_control() operation
>     which can now optionally support also pausing and
>     resuming DMA on a certain channel. Implemented for the
>     COH 901 318 DMAC as an example.
>     
>     [dan.j.williams@intel.com: update for timberdale]
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>     Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
>     Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>     Cc: Pavel Machek <pavel@ucw.cz>
>     Cc: Li Yang <leoli@freescale.com>
>     Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>     Cc: Paul Mundt <lethal@linux-sh.org>
>     Cc: Ralf Baechle <ralf@linux-mips.org>
>     Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
>     Cc: Magnus Damm <damm@opensource.se>
>     Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>     Cc: Joe Perches <joe@perches.com>
>     Cc: Roland Dreier <rdreier@cisco.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 0f65169b1bf44220308e1ce1f6666ad03ddc27af
> Author: Richard Röjfors <richard.rojfors@pelagicore.com>
> Date:   Fri Mar 26 08:23:58 2010 +0100
> 
>     dma: timb-dma: Update comment and fix compiler warning
>     
>     An incremental patch which clarifies what the spinlock is used for
>     and fixes a compiler warning.
>     
>     Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit de5d4453c5b224eefd02b6a141ed411a76d458af
> Author: Richard Röjfors <richard.rojfors@pelagicore.com>
> Date:   Thu Mar 25 19:44:21 2010 +0100
> 
>     dma: Add timb-dma
>     
>     Adds the support for the DMA engine withing the timberdale FPGA.
>     
>     The DMA channels are strict device to host, or host to device
>     and can not be used for generic memcpy.
>     
>     Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit 84c8447c544bc7579097649273bc3f4e1b5de6af
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Thu Mar 4 14:40:30 2010 +0100
> 
>     DMAENGINE: COH 901 318 fix bytesleft
>     
>     This makes the function to get the number of bytes left in the
>     ongoing DMA transaction actually work: the old code did not take
>     neither lli:s nor queued jobs into account. Also fix a missing
>     spinlock while we're at it.
>     
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> commit cecd87da83869ad4157295b87a2e51e38c3e03bf
> Author: Linus Walleij <linus.walleij@stericsson.com>
> Date:   Thu Mar 4 14:31:47 2010 +0100
> 
>     DMAENGINE: COH 901 318 rename confusing vars
>     
>     This fixes up the code with a lot of comments that make it readable,
>     rename things with opaque names like "data" into something more
>     appropriate, and remove some very confusing BUG() statements.
>     
>     Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 


