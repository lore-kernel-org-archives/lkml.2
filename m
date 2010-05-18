Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0ERDh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:37:27 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:3890 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0ERDhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:37:24 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALKo8UurR7Ht/2dsb2JhbACdenGhaJoChRAEg0A
X-IronPort-AV: E=Sophos;i="4.53,252,1272844800"; 
   d="scan'208";a="326871925"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 17 May 2010 20:37:19 -0700
Message-ID: <adaocgdnamo.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch InfinBand/RDMA changes for the 2.6.35
merge window:

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

Roland Dreier (5):
      IB: Explicitly rule out llseek to avoid BKL in default_llseek()
      RDMA/nes: Make unnecessarily global functions static
      RDMA/cxgb3: Shrink .text with compile-time init of handlers arrays
      MAINTAINERS: Add cxgb4 and iw_cxgb4 entries
      Merge branches 'amso1100', 'bkl', 'cma', 'cxgb3', 'cxgb4', 'ipoib', 'iser', 'masked-atomics', 'misc', 'mthca' and 'nes' into for-next

Steve Wise (2):
      RDMA/cxgb3: Don't free skbs on NET_XMIT_* indications from LLD
      RDMA/cxgb4: Add driver for Chelsio T4 RNIC

Tetsuo Handa (1):
      RDMA/cma: Randomize local port allocation

Vladimir Sokolovsky (2):
      IB/core: Add support for masked atomic operations
      IB/mlx4: Add support for masked atomic operations

 MAINTAINERS                                   |   14 +
 drivers/infiniband/Kconfig                    |    1 +
 drivers/infiniband/Makefile                   |    1 +
 drivers/infiniband/core/cma.c                 |   74 +-
 drivers/infiniband/core/mad.c                 |    4 +-
 drivers/infiniband/core/ucm.c                 |    3 +-
 drivers/infiniband/core/ucma.c                |    4 +-
 drivers/infiniband/core/user_mad.c            |   12 +-
 drivers/infiniband/core/uverbs_main.c         |   11 +-
 drivers/infiniband/hw/amso1100/c2.h           |    2 +-
 drivers/infiniband/hw/amso1100/c2_alloc.c     |    4 +-
 drivers/infiniband/hw/amso1100/c2_cq.c        |    4 +-
 drivers/infiniband/hw/amso1100/c2_mq.h        |    2 +-
 drivers/infiniband/hw/amso1100/c2_provider.h  |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c      |   12 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c        |   12 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.h        |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h         |    4 +-
 drivers/infiniband/hw/cxgb3/iwch.c            |    2 -
 drivers/infiniband/hw/cxgb3/iwch_cm.c         |  133 +-
 drivers/infiniband/hw/cxgb4/Kconfig           |   18 +
 drivers/infiniband/hw/cxgb4/Makefile          |    5 +
 drivers/infiniband/hw/cxgb4/cm.c              | 2374 +++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/cq.c              |  882 +++++++++
 drivers/infiniband/hw/cxgb4/device.c          |  520 ++++++
 drivers/infiniband/hw/cxgb4/ev.c              |  193 ++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |  745 ++++++++
 drivers/infiniband/hw/cxgb4/mem.c             |  811 +++++++++
 drivers/infiniband/hw/cxgb4/provider.c        |  518 ++++++
 drivers/infiniband/hw/cxgb4/qp.c              | 1577 ++++++++++++++++
 drivers/infiniband/hw/cxgb4/resource.c        |  417 +++++
 drivers/infiniband/hw/cxgb4/t4.h              |  550 ++++++
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h     |  829 +++++++++
 drivers/infiniband/hw/cxgb4/user.h            |   66 +
 drivers/infiniband/hw/mlx4/cq.c               |    8 +
 drivers/infiniband/hw/mlx4/main.c             |    1 +
 drivers/infiniband/hw/mlx4/qp.c               |   50 +-
 drivers/infiniband/hw/mthca/mthca_allocator.c |    8 +-
 drivers/infiniband/hw/mthca/mthca_eq.c        |    6 +-
 drivers/infiniband/hw/mthca/mthca_provider.h  |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c            |   12 +-
 drivers/infiniband/hw/nes/nes_nic.c           |   16 +-
 drivers/infiniband/hw/nes/nes_utils.c         |   10 -
 drivers/infiniband/hw/nes/nes_verbs.c         |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c  |   20 +
 drivers/infiniband/ulp/iser/iscsi_iser.c      |    9 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h      |    4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c      |  115 +-
 include/linux/mlx4/device.h                   |    4 +-
 include/linux/mlx4/qp.h                       |    7 +
 include/rdma/ib_verbs.h                       |    7 +
 51 files changed, 9838 insertions(+), 251 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/Kconfig
 create mode 100644 drivers/infiniband/hw/cxgb4/Makefile
 create mode 100644 drivers/infiniband/hw/cxgb4/cm.c
 create mode 100644 drivers/infiniband/hw/cxgb4/cq.c
 create mode 100644 drivers/infiniband/hw/cxgb4/device.c
 create mode 100644 drivers/infiniband/hw/cxgb4/ev.c
 create mode 100644 drivers/infiniband/hw/cxgb4/iw_cxgb4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/mem.c
 create mode 100644 drivers/infiniband/hw/cxgb4/provider.c
 create mode 100644 drivers/infiniband/hw/cxgb4/qp.c
 create mode 100644 drivers/infiniband/hw/cxgb4/resource.c
 create mode 100644 drivers/infiniband/hw/cxgb4/t4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
 create mode 100644 drivers/infiniband/hw/cxgb4/user.h
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
