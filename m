Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0EQQgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:36:21 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:53569 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0EQQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:36:19 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMcN8UurR7H+/2dsb2JhbACdeXGiXZlKhRAEg0A
X-IronPort-AV: E=Sophos;i="4.53,248,1272844800"; 
   d="scan'208";a="326656187"
From: Roland Dreier <rdreier@cisco.com>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: InfiniBand/RDMA merge plans for 2.6.35
X-Message-Flag: Warning: May contain useful information
Date: Mon, 17 May 2010 09:36:09 -0700
Message-ID: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.34 is here, it's probably a good time to talk about 2.6.35
merge plans.  All the pending things that I'm aware of are listed below.

Boilerplate:

If something isn't already in my tree and it isn't listed below, I
probably missed it or dropped it unintentionally.  Please remind me.

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch now, or trying to understand it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Check your patch over at least enough so I don't see a memory leak
   or deadlock as soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  We currently
have a big imbalance between people who are writing patches (many) and
people who are reviewing patches (mostly me).  None of this means you
shouldn't remind me about pending patches, since I often lose track of
things and drop them accidentally.

Core:

 - Added support for masked atomic operations.

ULPs:

 - Merged a series of iSER failover improvements.

HW specific:

 - Added the iw_cxgb4 driver for new Chelsio T4 adapters.

 - Added masked atomic support to mlx4.

 - Removed use of the older PCI state API in favor of the new DMA
   state API.

 - A few other fixes here and there.

Here are a few topics that are not ready in time for the 2.6.35 window
and will need to wait for 2.6.36 at least:

 - XRC.  While I think we made significant progress here, the fact is
   that this is not ready to merge at the beginning of the merge
   window, and so we'll need to keep working on it and wait for the
   next merge window.

 - IBoE.  Same as XRC; we made significant progress (and I opened an
   iboe branch to track this), but we still do not have even the
   user-kernel interface really nailed down yet.

 - New QLogic qib driver.  If a new set of patches shows up soon, we
   can probably sneak this in, since it is essentially a new hardware
   driver that affects little else.  However the sheer size of the
   driver means we need to get this in early in the release cycle.

Here all the patches I already have in my for-next branch:

Chien Tung (1):
      RDMA/nes: Make nesadapter->phy_lock usage consistent

Dan Carpenter (1):
      IB/iser: Fix error flow in iser_create_ib_conn_res()

FUJITA Tomonori (3):
      RDMA/cxgb3: Use the dma state API instead of pci equivalents
      RDMA/amso1100: Use the dma state API instead of pci equivalents
      IB/mthca: Use the dma state API instead of pci equivalents

Julia Lawall (1):
      IB/core: Use kmemdup() instead of kmalloc()+memcpy()

Or Gerlitz (4):
      IPoIB: Allow disabling/enabling TSO on the fly through ethtool
      IB/iser: Add asynchronous event handler
      IB/iser: Remove buggy back-pointer setting
      IB/iser: Enhance disconnection logic for multi-pathing

Roland Dreier (4):
      IB: Explicitly rule out llseek to avoid BKL in default_llseek()
      RDMA/nes: Make unnecessarily global functions static
      RDMA/cxgb3: Shrink .text with compile-time init of handlers arrays
      MAINTAINERS: Add cxgb4 and iw_cxgb4 entries

Steve Wise (2):
      RDMA/cxgb3: Don't free skbs on NET_XMIT_* indications from LLD
      RDMA/cxgb4: Add driver for Chelsio T4 RNIC

Tetsuo Handa (1):
      RDMA/cma: Randomize local port allocation

Vladimir Sokolovsky (2):
      IB/core: Add support for masked atomic operations
      IB/mlx4: Add support for masked atomic operations
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
