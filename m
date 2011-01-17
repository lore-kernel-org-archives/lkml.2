Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1AQDzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 22:55:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:48602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1AQDzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 22:55:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="697477922"
Subject: [GIT] dmaengine update for 2.6.38
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 20:07:24 -0800
Message-ID: <1295237244.4100.9.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from: 

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ An overhaul of the amba-pl08x driver by Russell who caught a lot of
issues in this experimental driver that really should have been caught
before the initial merge.

2/ A collection of small updates and fixes across fsldma, dma40,
intel-mid, and iop-adma.

All but the last two amba-pl08x patches have appeared in a -next
release.

Thanks,
Dan


Dan Carpenter (1):
      dma/intel_mid_dma: remove unneeded null check

Dan Williams (3):
      Merge branches 'fsldma' and 'intel-mid' into dmaengine
      Merge branches 'amba' and 'dma40' into dmaengine
      ARM: PL08x: fix a warning

Eric Xu (1):
      dmaengine: at_hdmac: use subsys_initcall instead of module_init

Feng Tang (1):
      intel_mid_dma: add support for single item scatter-gather list

Li Yang (1):
      fsldma: add support to 36-bit physical address

Nicolas Ferre (5):
      dmaengine: at_hdmac: use dma_address to program DMA hardware
      dmaengine: at_hdmac: trivial add precision to unmapping comment
      dmaengine: at_hdmac: no need set ACK in new descriptor
      dmaengine: at_hdmac: flags located in first descriptor
      dmaengine: at_hdmac: fix race while monitoring channel status

Per Forlin (1):
      dmaengine: dma40: Add support to split up large elements

Russell King - ARM Linux (50):
      ARM: PL08x: fix spelling errors
      ARM: PL08x: fix array overflow in dma_set_runtime_config()
      ARM: PL08x: fix atomic_t usage and tx_submit() return value range
      ARM: PL08x: fix locking in tasklet
      ARM: PL08x: fix a leak when preparing TXDs
      ARM: PL08x: fix missed spin-unlock in pl08x_issue_pending()
      ARM: PL08x: fix deadlock in terminate_all
      ARM: PL08x: fix sparse warnings
      ARM: PL08x: add comment explaining the flow control methods
      ARM: PL08x: improve the announcement printk
      ARM: PL08x: prefix hex numbers with 0x
      ARM: PL08x: remove unnecessary includes
      ARM: PL08x: remove unnecessary NULL and BUG checks
      ARM: PL08x: remove circular buffer support
      ARM: PL08x: constify vendor data pointers
      ARM: PL08x: avoid 'void *' struct fields when we can type them properly
      ARM: PL08x: consolidate common txd initialization
      ARM: PL08x: consolidate physical channel release code
      ARM: PL08x: ensure loops use cpu_relax()
      ARM: PL08x: don't assume that the LLI pointer has the bus bit clear
      ARM: PL08x: don't try to use llis_bus as a pointer
      ARM: PL08x: use 'size_t' for lengths
      ARM: PL08x: use 'u32' for LLI structure members, not dma_addr_t
      ARM: PL08x: rename lli.next to lli.lli
      ARM: PL08x: clean up LLI lookup
      ARM: PL08x: combine functions to start DMA into one function
      ARM: PL08x: avoid duplicating registers in txd and phychan structures
      ARM: PL08x: move ccfg into txd structure
      ARM: PL08x: assign ccfg DMA request signal in prep_phy_channel()
      ARM: PL08x: move default cctl into txd structure
      ARM: PL08x: move cctl increment and protection setup to prep_slave_sg
      ARM: PL08x: move AHB master port selection into prep_* functions
      ARM: PL08x: allow AHB master port selection to be configured
      ARM: PL08x: move callback outside spinlock'd region
      ARM: PL08x: make pl08x_fill_lli_for_desc() return void
      ARM: PL08x: ensure pl08x_pre_boundary() works for any value of addr
      ARM: PL08x: use min() to calculate target_len
      ARM: PL08x: fix fill_bytes calculation
      ARM: PL08x: don't manipulate txd->srcbus or txd->dstbus during LLI fill
      ARM: PL08x: shrink srcbus/dstbus in txd structure
      ARM: PL08x: store prep_* flags in async_tx structure
      ARM: PL08x: implement unmapping of memcpy buffers
      ARM: PL08x: rename 'desc_list' as 'pend_list'
      ARM: PL08x: put txd's on the pending list in pl08x_tx_submit()
      ARM: PL08x: introduce 'phychan_hold' to hold on to physical channels
      ARM: PL08x: fix locking between prepare function and submit function
      ARM: PL08x: allow dma_set_runtime_config() to return errors
      ARM: PL08x: prevent dma_set_runtime_config() reconfiguring memcpy channels
      Fix dmaengine_submit() return type
      ARM: PL08x: cleanup comments

Tomoya MORINAGA (1):
      pch_dma: support new device ML7213 IOH

Wei Yongquan (1):
      Update CONFIG_MD_RAID6_PQ to CONFIG_RAID6_PQ in drivers/dma/iop-adma.c

 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    8 +
 drivers/dma/Kconfig                            |    9 +-
 drivers/dma/amba-pl08x.c                       | 1168 +++++++++++-------------
 drivers/dma/at_hdmac.c                         |   19 +-
 drivers/dma/fsldma.c                           |    4 +-
 drivers/dma/intel_mid_dma.c                    |   33 +-
 drivers/dma/iop-adma.c                         |    4 +-
 drivers/dma/pch_dma.c                          |   19 +-
 drivers/dma/ste_dma40.c                        |  191 +++-
 drivers/dma/ste_dma40_ll.c                     |  246 ++++--
 drivers/dma/ste_dma40_ll.h                     |   36 +-
 include/linux/amba/pl08x.h                     |   99 +-
 include/linux/dmaengine.h                      |    2 +-
 13 files changed, 994 insertions(+), 844 deletions(-)

commit 94ae85220a07d357d4937086c490854f63344de4
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Sun Jan 16 20:18:05 2011 +0000

    ARM: PL08x: cleanup comments
    
    Cleanup the formatting of comments, remove some which don't make sense
    anymore.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    [fix conflict with 96a608a4]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0261f7416362f6affc2d4fe7fea9320a6bdaaee6
Author: Wei Yongquan <weiyqlq@gmail.com>
Date:   Wed Dec 29 20:30:55 2010 +0800

    Update CONFIG_MD_RAID6_PQ to CONFIG_RAID6_PQ in drivers/dma/iop-adma.c
    
    Commit f5e70d0fe3ea990cfb3fc8d7f76a719adcb1e0b5 renamed MD_RAID6_PQ to RAID6_PQ,
    but iop-adma.c didn't update synchronously.
    
    Signed-off-by: Wei Yongquan <weiyqlq@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 96a608a4bfd8468c21881b3f92024923886eb015
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jan 14 17:51:11 2011 -0800

    ARM: PL08x: fix a warning
    
    drivers/dma/amba-pl08x.c: In function 'pl08x_start_txd':
    drivers/dma/amba-pl08x.c:205: warning: dereferencing 'void *' pointer
    
    We never dereference llis_va aside from assigning it to a struct
    pl08x_lli pointer or calculating the address of array element 0.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 98d530fe246b65fbd3cdeeeca319a80c46cb4793
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Sat Jan 1 23:00:23 2011 +0000

    Fix dmaengine_submit() return type
    
    desc->tx_submit's return type is dma_cookie_t, not int.  Therefore,
    dmaengine_submit() should match this return type as it's just
    wrapping this detail.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dda36f9821321edf65d69da5c0807df7e73d26fc
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Jan 12 15:39:10 2011 +0100

    dmaengine: at_hdmac: fix race while monitoring channel status
    
    We were reading channel status then taking a lock. This lead to a race because
    this lock may delay us and then make this channel not idle anymore.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 568f7f0c2e597671d3e646e0b85c95c4a5756fef
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Jan 12 15:39:09 2011 +0100

    dmaengine: at_hdmac: flags located in first descriptor
    
    Place flags on first descriptor of chain instead of last.
    This is the one used by atc_chain_complete() function while unmapping.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 93d0bec2be4b0f036a27da207ecab97fc3d3bbbe
Author: Eric Xu <hong.xu@atmel.com>
Date:   Wed Jan 12 15:39:08 2011 +0100

    dmaengine: at_hdmac: use subsys_initcall instead of module_init
    
    Use subsys_initcall instead of module_init in order to keep DMA engine rolling
    before other peripheral drivers.
    
    Signed-off-by: Eric Xu <hong.xu@atmel.com>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 58344f25cf5f3453bfcf4b845ea9ec71153e45c3
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Jan 12 15:39:07 2011 +0100

    dmaengine: at_hdmac: no need set ACK in new descriptor
    
    Following descriptor flow in at_hdmac driver, descriptor comming from
    atc_desc_get() as already DMA_CTRL_ACK flag set. No need to set it again.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ebcf9b80f9657f44fcb60ee17abe14eadebf3386
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Jan 12 15:39:06 2011 +0100

    dmaengine: at_hdmac: trivial add precision to unmapping comment
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0f70e8cea3ac6a765289811c590a16934bf47711
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Dec 15 18:50:16 2010 +0100

    dmaengine: at_hdmac: use dma_address to program DMA hardware
    
    In atc_prep_slave_sg() function we use dma_address field of scatterlist with
    sg_dma_address() macro instead of sg_phys(). DMA address is already computed
    by dma_map_sg() or another mapping function in calling driver.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2cdf2455a660ea860272ef3f833f0e5c4cc80205
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Wed Jan 5 17:43:52 2011 +0900

    pch_dma: support new device ML7213 IOH
    
    Support new device OKI SEMICONDUCTOR's ML7213 IOH(Input/Output Hub) which is for
    IVI(In-Vehicle Infotainment) use.
    The ML7213 is companion chip for Intel Atom E6xx series.
    The ML7213 is completely compatible for Intel EG20T PCH.
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bc0fa81473c077bf4403e3b7b3397326204b65cd
Merge: 0a4bbdd b7f7586 d49278e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jan 7 12:47:05 2011 -0800

    Merge branches 'amba' and 'dma40' into dmaengine

commit b7f758659265c173380b792862aaad1c23c0e004
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:46:17 2011 +0000

    ARM: PL08x: prevent dma_set_runtime_config() reconfiguring memcpy channels
    
    Prevent dma_set_runtime_config() being used to alter the configuration
    supplied by the platform for memcpy channel configuration.  No one
    should be trying to change this configuration.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f0fd944625b6e406dc273b8dffa16e0728c973e6
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:45:57 2011 +0000

    ARM: PL08x: allow dma_set_runtime_config() to return errors
    
    There are cases in dma_set_runtime_config() where we fail to perform
    the requested action - and we just issue a KERN_ERR message in that
    case.  We have the facility to return an error to the caller, so that
    is what we should do.
    
    When we encounter an error due to invalid parameters, we should not
    modify driver state.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c370e594efe2993620d24d41a78f325102e99d1c
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:45:37 2011 +0000

    ARM: PL08x: fix locking between prepare function and submit function
    
    The PL08x driver holds on to the channel lock with interrupts disabled
    between the prepare and the subsequent submit API functions.  This
    means that the locking state when the prepare function returns is
    dependent on whether it suceeeds or not.
    
    It did this to ensure that the physical channel wasn't released, and
    as it used to add the descriptor onto the pending list at prepare time
    rather than submit time.
    
    Now that we have reorganized the code to remove those reasons, we can
    now safely release the spinlock at the end of preparation and reacquire
    it in our submit function.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8087aacda040bdbf84940712d132ce80c30b9d5d
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:45:17 2011 +0000

    ARM: PL08x: introduce 'phychan_hold' to hold on to physical channels
    
    Introduce 'phychan_hold' to hold on to physical DMA channels while we're
    preparing a new descriptor for it.  This will be incremented when we
    allocate a physical channel and set the MUX registers during the
    preparation of the TXD, and will only be decremented when the TXD is
    submitted.
    
    This prevents the physical channel being given up before the new TXD
    is placed on the queue.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 501e67e82dee68d0a594ec0549f3d6a2943c91f5
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:44:57 2011 +0000

    ARM: PL08x: put txd's on the pending list in pl08x_tx_submit()
    
    Don't place TXDs on the pending list when they're prepared - place
    them on the list when they're ready to be submitted.  Also, only
    place memcpy requests in the wait state when they're submitted and
    don't have a physical channel associated.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 15c17232fbd1f7687c740c3c26f9e7f337bd9e36
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:44:36 2011 +0000

    ARM: PL08x: rename 'desc_list' as 'pend_list'
    
    This 'desc_list' is actually a list of pending descriptors, so name
    it after its function (pending list) rather than what it contains
    (descriptors).
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3d992e1a6f8465db3921ef75bfc490fbd2f40cd3
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:44:16 2011 +0000

    ARM: PL08x: implement unmapping of memcpy buffers
    
    The DMA engine API requires DMA engine implementations to unmap buffers
    passed into the non-slave DMA methods unless the relevant completion
    flag is set.  We aren't doing this, so implement this facility.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c04287948ec8308fceedda980373bc7d53620255
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:43:56 2011 +0000

    ARM: PL08x: store prep_* flags in async_tx structure
    
    Like other DMA engine drivers do, store the passed flags into the
    async_tx structure, so they can be checked when the operation
    completes.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d7244e9a27a3da27d62aabf560ee828d7991493e
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:43:35 2011 +0000

    ARM: PL08x: shrink srcbus/dstbus in txd structure
    
    We only need to store the dma address.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 542361f8e385355c68e263eba49d4306739b9220
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:43:15 2011 +0000

    ARM: PL08x: don't manipulate txd->srcbus or txd->dstbus during LLI fill
    
    Don't alter any txd->srcbus or txd->dstbus values while building the
    LLI list.  This allows us to see the original dma_addr_t values passed
    in via the prep_memcpy() method.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5f638b4f313e345bf02700910e581bccf71212f5
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:42:55 2011 +0000

    ARM: PL08x: fix fill_bytes calculation
    
    The number of bytes we want to fill into any LLI is the minimum of:
    - number of bytes remaining in the transfer
    - number of bytes we can transfer in a single LLI
    - number of bytes we can transfer without overflowing the source boundary
    - number of bytes we can transfer without overflowing the destination boundary
    
    The minimum of the first two is already calculated (target_len).  We
    limit the boundary calculations to this number of bytes, which will
    then give us the number of bytes we can place into this LLI.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d6cf7b597f7158616106068930d1c6203d9359eb
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:42:34 2011 +0000

    ARM: PL08x: use min() to calculate target_len
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b61be8d728abad7fd98e62e98f22325f8f254b51
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:42:14 2011 +0000

    ARM: PL08x: ensure pl08x_pre_boundary() works for any value of addr
    
    pl08x_pre_boundary() was unsafe with addresses towards the top of
    memory space:
    
    	boundary = ((addr >> PL08X_BOUNDARY_SHIFT) + 1)
    			<< PL08X_BOUNDARY_SHIFT;
    
    This can overflow a 32-bit number, producing zero.  When it does:
    
    	if (boundary < addr + len)
    		return boundary - addr;
    	else
    		return len;
    
    results in (boundary - addr) returning either a large positive value.
    Also if addr + len overflows, this calculation also fails.
    
    We can fix this trivially as the only thing we're actually interested
    in is the value of the least significant PL08X_BOUNDARY_SHIFT bits:
    
    	boundary_len = PL08X_BOUNDARY_SIZE -
    		(addr & (PL08X_BOUNDARY_SIZE - 1));
    
    gives us the number of bytes before 'addr' becomes a multiple of
    PL08X_BOUNDARY_SIZE.  We can then just take the min() of the two
    calculated lengths.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0059005f2cbf4847551b9ad9915ffffe23aef0b9
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:41:54 2011 +0000

    ARM: PL08x: make pl08x_fill_lli_for_desc() return void
    
    We don't need pl08x_fill_lli_for_desc() to return num_llis + 1 as
    we know that's what it always does.  We can just pass in num_llis
    and use post-increment in the caller.
    
    This makes the code slightly easier to read.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 858c21c0f380fb9c78f47f3e372f9baadc54dffe
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:41:34 2011 +0000

    ARM: PL08x: move callback outside spinlock'd region
    
    Calling the callback handler with spinlocks in the tasklet held leads
    to deadlock when dmaengine functions are called:
    
    BUG: spinlock lockup on CPU#0, sh/417, c1870a08
    Backtrace:
    ...
    [<c017b408>] (do_raw_spin_lock+0x0/0x154) from [<c02c4b98>] (_raw_spin_lock_irqsave+0x54/0x60)
    [<c02c4b44>] (_raw_spin_lock_irqsave+0x0/0x60) from [<c01f5828>] (pl08x_prep_channel_resources+0x718/0x8b4)
    [<c01f5110>] (pl08x_prep_channel_resources+0x0/0x8b4) from [<c01f5bb4>] (pl08x_prep_slave_sg+0x120/0x19c)
    [<c01f5a94>] (pl08x_prep_slave_sg+0x0/0x19c) from [<c01be7a0>] (pl011_dma_tx_refill+0x164/0x224)
    [<c01be63c>] (pl011_dma_tx_refill+0x0/0x224) from [<c01bf1c8>] (pl011_dma_tx_callback+0x7c/0xc4)
    [<c01bf14c>] (pl011_dma_tx_callback+0x0/0xc4) from [<c01f4d34>] (pl08x_tasklet+0x60/0x368)
    [<c01f4cd4>] (pl08x_tasklet+0x0/0x368) from [<c004d978>] (tasklet_action+0xa0/0x100)
    
    Dan quoted the documentation:
    > 2/ Completion callback routines cannot submit new operations.  This
    >    results in recursion in the synchronous case and spin_locks being
    >    acquired twice in the asynchronous case.
    
    but then followed up to say:
    > I should clarify, this is the async_memcpy() api requirement which is
    > not used outside of md/raid5.  DMA drivers can and do allow new
    > submissions from callbacks, and the ones that do so properly move the
    > callback outside of the driver lock.
    
    So let's fix it by moving the callback out of the spinlocked region.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 30749cb4a40f02a199640011e5ab5c5f60b8482e
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:41:13 2011 +0000

    ARM: PL08x: allow AHB master port selection to be configured
    
    Platforms need to be able to control which AHB master interface is used,
    as each AHB master interface may be asymetric.  Allow the interfaces
    used for fetching LLIs, memory, and each peripheral to be configured
    individually.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c7da9a56d608145cc763bcfc9329b92c4244d8d9
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:40:53 2011 +0000

    ARM: PL08x: move AHB master port selection into prep_* functions
    
    As we initialize the default cctl value in the prep_* functions along
    with the increment settings, we don't need to repeat the selection of
    the AHB ports each time we create a LLI entry.  Do this in the prep_*
    functions once per transfer.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1cae78f12028eebdc9107eaf168add46e66fb3f8
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:40:33 2011 +0000

    ARM: PL08x: move cctl increment and protection setup to prep_slave_sg
    
    We don't need to initialize the cctl increment and protection values
    in the runtime_config method - we have all the inforamtion to setup
    these values in prep_slave_sg().  Move their initialization there.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 70b5ed6b6d72cd8b1a3d4b7b878a0dd132bec7ba
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:40:13 2011 +0000

    ARM: PL08x: move default cctl into txd structure
    
    Rather than modifying platform data while preparing a transfer, copy
    the cctl value into the txd structure and modify the value there.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 09b3c323332206aaadfb7aa13efffa82e7719b35
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:39:53 2011 +0000

    ARM: PL08x: assign ccfg DMA request signal in prep_phy_channel()
    
    There is no need to wait until we start processing a tx descriptor
    before setting up the DMA request selection in the ccfg register.
    We know which channel and request will be used in prep_phy_channel(),
    so setup the ccfg request selection at txd creation time in
    prep_phy_channel().
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4983a04fd2562986360b646b378f267308bc22c0
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:39:33 2011 +0000

    ARM: PL08x: move ccfg into txd structure
    
    The ccfg register is used to configure the channel parameters - the type
    and direction of transfer, the flow control signal and IRQ mask enables.
    The type and direction of transfer is known in the relevent prep_*
    function where a txd is created.  The IRQ mask enables are always set,
    and the flow control signals are always set when we start processing a
    txd according to phychan->signal.
    
    If we store the ccfg value in the txd structure, we can avoid modifying
    platform data - and even having it in platform data at all.
    
    So, remove it from platform data too.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 19524d77ec34faf58d313ba34fb755ef6e159216
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:39:13 2011 +0000

    ARM: PL08x: avoid duplicating registers in txd and phychan structures
    
    As we now have all the code accessing the phychan {csrc,cdst,clli,cctl,
    ccfg} members in one function, there's no point storing the data into
    the struct.  Get rid of the struct members.  Re-order the register dump
    in the dev_dbg() to reflect the order we write the registers to the DMA
    device.
    
    The txd {csrc,cdst,clli,cctl} values are duplicates of the lli[0]
    values, so there's no point duplicating these either.  Program the DMAC
    registers directly from the lli[0] values.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c885bee4f10323a1ff3f19e1aa2aa6f4e7f89dd8
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:38:52 2011 +0000

    ARM: PL08x: combine functions to start DMA into one function
    
    There is no need for pl08x_config_phychan_for_txd(), pl08x_set_cregs()
    and pl08x_enable_phy_chan() to be separate - they are always called in
    sequence.  Combine them into one function.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit db9f136a60c8727c8e1c9c4f2494821caebf5a7b
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:38:32 2011 +0000

    ARM: PL08x: clean up LLI lookup
    
    As the LLI list is an array, we can use maths to locate which LLI
    index we're currently at, and then sum up the remaining LLI entries
    until we reach the end of the list.
    
    This makes the code much easier to read, and much less susceptible
    to falling off the end of the array.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bfddfb45056fa95a778f0baf463ac0f9fc926d5c
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:38:12 2011 +0000

    ARM: PL08x: rename lli.next to lli.lli
    
    The LLI pointer in the documentation is placed into the LLI register,
    so name it LLI rather than 'next'.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e25761d72c80751c8741f5f93abab14232eef347
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:37:52 2011 +0000

    ARM: PL08x: use 'u32' for LLI structure members, not dma_addr_t
    
    Use 'u32' for the LLI structure members, which are defined by hardware
    to be 32-bit.  dma_addr_t is much more vague about its actual size.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cace658572ba5d1075f3891e823130a66f3e330f
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:37:31 2011 +0000

    ARM: PL08x: use 'size_t' for lengths
    
    Use size_t for variables denoting lengths throughout, and use the 'z'
    qualifier for printing the value.  For safety, add a BUG_ON() in
    pl08x_fill_lli_for_desc() to catch the remainder potentially becoming
    negative.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 56b618820c92a5efa2145fbbac373fffbb024a94
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:37:10 2011 +0000

    ARM: PL08x: don't try to use llis_bus as a pointer
    
    llis_bus is the DMA address of the LLI array.  Casting it to be a
    pointer just to be able to use pointer arithmetic on it is not nice.
    We can trivially deal with the places where we do arithmetic on it,
    and it's actually cleaner this way.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4c0df6a3ce8eb947647c7ed2640d0172936d8ef3
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:36:50 2011 +0000

    ARM: PL08x: don't assume that the LLI pointer has the bus bit clear
    
    We only want use the address of the LLI pointer when locating the
    corresponding structure in memory, so clear the master bus selection
    bit.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 19386b3234fdbe4d33492574d83e63a8dace18d3
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:36:29 2011 +0000

    ARM: PL08x: ensure loops use cpu_relax()
    
    Tight loops should use cpu_relax() to allow CPUs to reduce power
    consumption while waiting for events.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8c8cc2b1040f51a2f89724edbf976774128339eb
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:36:09 2011 +0000

    ARM: PL08x: consolidate physical channel release code
    
    Consolidate duplicated channel release code into release_phy_channel()
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ac3cd20df9d74bb205bb34f69407477a884ff8a3
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:35:49 2011 +0000

    ARM: PL08x: consolidate common txd initialization
    
    Consolidate code which allocates and initializes txds.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7cb72ad959b16ac594118977b7954a7d2ec7a052
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:35:28 2011 +0000

    ARM: PL08x: avoid 'void *' struct fields when we can type them properly
    
    Avoid using 'void *' struct fields when the structs are not defined
    in linux/amba/pl08x.h - instead, forward declare the struct names, and
    use these instead.  This ensures we have proper typechecking.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f96ca9ec27159c1c8718aa8d0ed03051cd12e884
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:35:08 2011 +0000

    ARM: PL08x: constify vendor data pointers
    
    We should never modify the vendor data structure so make it const.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b58b6b5bedf4d5da7a0cb2dce3b42d010c3aef03
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:34:48 2011 +0000

    ARM: PL08x: remove circular buffer support
    
    The driver already won't initialize a channel with a circular buffer;
    the check in pl08x_prep_channel_resources() sees to that.  Remove
    circular buffer support for the time being.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ad0a3ad33c96cbba98ba62116771fb836c551e60
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:34:27 2011 +0000

    ARM: PL08x: remove unnecessary NULL and BUG checks
    
    The tasklet always is initialized with a non-NULL data argument.  It
    is not possible for it to be called with a NULL data argument (unless
    something is very wrong in the tasklet code - in which case lots of
    stuff will break).  Therefore, as plchan can never be NULL, remove
    this unnecessary BUG check.
    
    In pl08x_tasklet(), we've already dereferenced plchan->at, so it can't
    be NULL here.  Remove this unnecessary BUG check.
    
    pl08x_fill_llis_for_desc() and pl08x_free_txd() are always called with
    a non-NULL txd argument - either as a consequence of the code paths or
    as a result of other checks already in place.  We don't need to repeat
    the non-NULL check in these functions.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 730404ac1c47403af67420705980c99e90bf182f
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:34:07 2011 +0000

    ARM: PL08x: remove unnecessary includes
    
    We don't need to include linux/pci.h as we aren't a PCI driver.  We
    aren't doing any processor specific functions, so asm/processor.h is
    not required.  asm/cacheflush.h shouldn't be used, we have the DMA API
    for this.  DMA interfaces aren't required as we're only implementing
    the dmaengine API and not a platform-private DMA API.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9c132992689d7d27a4e17545b6279db4e03c0943
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:33:47 2011 +0000

    ARM: PL08x: prefix hex numbers with 0x
    
    A driver which emits both decimal and hex numbers in its printk
    creates confusion as to what is what.  Prefix hex numbers with 0x.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b05cd8f4c04a29eebfa65c45fabc78a02f16a782
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:33:26 2011 +0000

    ARM: PL08x: improve the announcement printk
    
    Include the revision number of the PL08x primecell in the boot-time
    printk to allow proper identification of the peripheral.  Reformat
    the announcement printk format reflect what we do for other primecell
    drivers - generally "PLXXX revX at 0xNNNNNNNN irq X".
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9dc2c200a0551754f91e1b322dcb3d782cd709b2
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:33:06 2011 +0000

    ARM: PL08x: add comment explaining the flow control methods
    
    Explain the two flow control methods which the PL08x implements, along
    with the problem which peripheral flow control presents.  This helps
    people understand why we are unable to use these DMA controllers with
    (eg) the MMCI.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3e2a037c1de79af999a54581cbf1e8a5c933fd95
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:32:46 2011 +0000

    ARM: PL08x: fix sparse warnings
    
    drivers/dma/amba-pl08x.c:1895:40: warning: Unknown escape '%'
    drivers/dma/amba-pl08x.c:1903:40: warning: Unknown escape '%'
    drivers/dma/amba-pl08x.c:513:6: warning: symbol 'pl08x_choose_master_bus' was not declared. Should it be static?
    drivers/dma/amba-pl08x.c:604:5: warning: symbol 'pl08x_fill_llis_for_desc' was not declared. Should it be static?
    drivers/dma/amba-pl08x.c:1442:32: warning: symbol 'pl08x_prep_slave_sg' was not declared. Should it be static?
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 98838f90d92f6f0abf6d6a99880c0ff3127633b8
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:32:26 2011 +0000

    ARM: PL08x: fix deadlock in terminate_all
    
    Trying to disable a tasklet while holding a spinlock which the tasklet
    will take is a recipe for deadlock - tasklet_disable() will wait for the
    tasklet to finish running, which it will never do.  In any case, there
    is not a corresponding tasklet_enable(), so once the tasklet is disabled,
    it will never run again until reboot.
    
    It's safe to just remove the tasklet_disable() as we remove all current
    and pending descriptors before releasing this spinlock.  This means that
    the tasklet will find no remaining work if it subsequently runs.
    
    The only remaining issue is that the callback for an already submitted
    txd may be in progress, or even called after terminate_all() returns.
    There's not much that can be done about that as waiting for the callback
    to complete before returning will also lead to deadlocks.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9c0bb43bbd02fba0b235f8993d1f175734fa8735
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:32:05 2011 +0000

    ARM: PL08x: fix missed spin-unlock in pl08x_issue_pending()
    
    pl08x_issue_pending() returns with the spinlock locked and interrupts
    disabled if the channel is waiting for a physical DMA to become free.
    This is wrong - especially as pl08x_issue_pending() is an API function
    as it leads to deadlocks.  Fix it to always return with the spinlock
    unlocked.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dafa73171be8dd31b485f5839e3376b1ca908e24
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:31:45 2011 +0000

    ARM: PL08x: fix a leak when preparing TXDs
    
    If we fail to allocate the LLI, the prep_* function will return NULL.
    However, the TXD we allocated will not be placed on any list, nor
    will it be freed - we'll just drop all references to it.  Make sure
    we free it rather than leaking TXDs.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bf072af461c166964fb110cfcafccd752fbb4c64
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:31:24 2011 +0000

    ARM: PL08x: fix locking in tasklet
    
    Tasklets are run from an interruptible context.  The slave DMA functions
    can be called from within IRQ handlers.  Taking the spinlock without
    disabling interrupts allows an interrupt handler to run, which may try
    to take the spinlock again, resulting in deadlock.  Fix this by using
    the irqsave spinlocks.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 91aa5fadb831e7b6ea473a526a6b49c6dc4819ce
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:31:04 2011 +0000

    ARM: PL08x: fix atomic_t usage and tx_submit() return value range
    
    The last_issued variable uses an atomic type, which is only
    incremented inside a protected region, and then read.  Everywhere else
    only reads the value, so it isn't using atomic_t correctly, and it
    doesn't even need to.  Moreover, the DMA engine code provides us with
    a variable for this already - chan.cookie.  Use chan.cookie instead.
    
    Also, avoid negative dma_cookie_t values - negative returns from
    tx_submit() mean failure, yet in reality we always succeed.  Restart
    from cookie 1, just like other DMA engine drivers do.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4440aacf3a171a0ab498feda58d100a320c5d9ff
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:30:44 2011 +0000

    ARM: PL08x: fix array overflow in dma_set_runtime_config()
    
    If maxburst was passed in as zero, we would overflow the burst_sizes[]
    array.  Fix this by checking for this condition, and defaulting to
    single transfer 'bursts'.
    
    Improve the readability of the loop using a for() loop rather than
    a while() loop with the iterator initialized far from the loop.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e8b5e11df3d02e7bbd85c025cc705a8e67746f73
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Mon Jan 3 22:30:24 2011 +0000

    ARM: PL08x: fix spelling errors
    
    Correct mis-spellings in comments and printk strings.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d49278e3351b34870cbffffc5067348a318e7b06
Author: Per Forlin <per.forlin@stericsson.com>
Date:   Mon Dec 20 18:31:38 2010 +0100

    dmaengine: dma40: Add support to split up large elements
    
    The maximum transfer size of the stedma40 is (64k-1) x data-width.
    If the transfer size of one element exceeds this limit
    the job is split up and sent as linked transfer.
    
    Signed-off-by: Per Forlin <per.forlin@linaro.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0a4bbddde29c038f2c51a7abb03d6d07e679d8af
Merge: c989a7f e2c8e42 0be035f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 7 17:10:52 2010 -0800

    Merge branches 'fsldma' and 'intel-mid' into dmaengine

commit 0be035f3485379d812d617ee7eaa255cde97dbfa
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Dec 2 17:14:30 2010 +0800

    intel_mid_dma: add support for single item scatter-gather list
    
    Current driver's device_prep_slave_sg can't be used by DMAC2 even
    the sg list contains one item, this patch will enable DMAC2 to
    use this API.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e2c8e425baa01a4c8e6ae1b90194ed3d3cde0c66
Author: Li Yang <leoli@freescale.com>
Date:   Thu Nov 11 20:16:29 2010 +0800

    fsldma: add support to 36-bit physical address
    
    Expand the dma_mask of fsldma device to 36-bit, indicating that the
    DMA engine can deal with 36-bit physical address and does not need
    the SWIOTLB to create bounce buffer for it when doing dma_map_*().
    
    Signed-off-by: Li Yang <leoli@freescale.com>
    Acked-by: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 66bde0b70aa2e348ac2c9b9626743c1402b9d466
Author: Dan Carpenter <error27@gmail.com>
Date:   Thu Oct 28 15:41:56 2010 +0200

    dma/intel_mid_dma: remove unneeded null check
    
    Smatch complains because we dereference "mid" before checking it.  It
    turns out that "mid" is always a valid pointer here so we can just
    remove the check.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>



