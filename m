Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2EUBOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 21:14:42 -0400
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:39075 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754522Ab2EUBOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 21:14:38 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Sun, 20 May 2012 18:14:28 -0700
Message-Id: <1337562868-9887-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-3.5

----------------------------------------------------------------

InfiniBand/RDMA changes for the 3.5 merge window:
 - Add ocrdma hardware driver for Emulex IB-over-Ethernet adapters
 - Add generic and mlx4 support for "raw" QPs: allow suitably privileged
   applications to send and receive arbitrary packets directly to/from
   the hardware
 - Add "doorbell drop" handling to the cxgb4 driver
 - A fairly large batch of qib hardware driver changes
 - A few fixes for lockdep-detected issues
 - A few other miscellaneous fixes and cleanups

----------------------------------------------------------------
Dan Carpenter (2):
      RDMA/ocrdma: Fix check for NULL instead of IS_ERR
      RDMA/ocrdma: Tiny locking cleanup

Jack Morgenstein (3):
      mlx4_core: Change bitmap allocator to work in round-robin fashion
      IB/core: Fix IB_SA_COMP_MASK macro
      IB/mlx4: Fix mlx4_ib_add() error flow

Jim Cromie (1):
      IB/ipath: Replace open-coded ARRAY_SIZE with macro

Jim Foraker (2):
      IB/qib: Fix M_Key lease timeout handling
      IB/qib: MADs with misset M_Keys should return failure

Mike Marciniszyn (5):
      IB/ipath: Replace open-coded ARRAY_SIZE with macro
      MAINTAINERS: Update qib and ipath entries from QLogic to Intel
      IB/qib: Add prefetch for eager buffers
      IB/qib: Optimize pio ack buffer allocation
      IB/qib: Add cache line awareness to qib_qp and qib_devdata structures

Mitko Haralanov (2):
      IB/qib: Display correct value for number of contexts
      IB/qib: Fix QLE734X link cycling

Or Gerlitz (4):
      IB/core: Use qp->usecnt to track multicast attach/detach
      IB/core: Add raw packet QP type
      IB/mlx4: Add raw packet QP support
      IB/iser: Fix error flow in iser ep connection establishment

Oren Duer (1):
      IB/mlx4: Put priority bits in WQE of IBoE MLX QP

Parav Pandit (3):
      be2net: Add function to issue mailbox cmd on MQ
      be2net: Add functionality to support RoCE driver
      RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter

Roland Dreier (8):
      IB/uverbs: Make lockdep output more readable
      IB/uverbs: Lock SRQ / CQ / PD objects in a consistent order
      RDMA/ocrdma: Fix warnings about uninitialized variables
      RDMA/ocrdma: Make needlessly global functions/structs static
      RDMA/ocrdma: Set event's device member in ocrdma_dispatch_ibevent()
      RDMA/ocrdma: Remove write-only variables
      RDMA/ocrdma: Fix build with IPV6=n
      Merge branches 'core', 'cxgb4', 'ipath', 'iser', 'lockdep', 'mlx4', 'nes', 'ocrdma', 'qib' and 'raw-qp' into for-linus

Sasha Levin (1):
      RDMA/ocrdma: Don't sleep in atomic notifier handler

Sean Hefty (1):
      RDMA/cma: Fix lockdep false positive recursive locking

Shlomo Pongratz (3):
      mlx4_core: Add second capabilities flags field
      IB/mlx4: Replace printk(KERN_yyy...) with pr_yyy(...)
      IB/mlx4: Increase the number of vectors (EQs) available for ULPs

Steve Wise (3):
      RDMA/cxgb4: Use dst parameter in import_ep()
      RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
      RDMA/cxgb4: Drop peer_abort when no endpoint found

Tatyana Nikolova (2):
      RDMA/nes: Fix for the ORD value of the connecting peer
      RDMA/nes: Don't call event handler if pointer is NULL

Todd Rimmer (1):
      IB/qib: Correct ordering of reregister vs. port active events

Vipul Pandya (10):
      cxgb4: Detect DB FULL events and notify RDMA ULD
      cxgb4: Common platform specific changes for DB Drop Recovery
      cxgb4: DB Drop Recovery for RDMA and LLD queues
      RDMA/cxgb4: Add debugfs RDMA memory stats
      RDMA/cxgb4: Add DB Overflow Avoidance
      RDMA/cxgb4: Disable interrupts in c4iw_ev_dispatch()
      RDMA/cxgb4: DB Drop Recovery for RDMA and LLD queues
      RDMA/cxgb4: Use vmalloc() for debugfs QP dump
      RDMA/cxgb4: Remove kfifo usage
      RDMA/cxgb4: Add query_qp support

Yishai Hadas (1):
      IB/core: Fix mismatch between locked and pinned pages

 MAINTAINERS                                     |    4 +-
 drivers/infiniband/Kconfig                      |    1 +
 drivers/infiniband/Makefile                     |    1 +
 drivers/infiniband/core/cma.c                   |   42 +-
 drivers/infiniband/core/umem.c                  |    2 +-
 drivers/infiniband/core/uverbs_cmd.c            |  108 +-
 drivers/infiniband/core/verbs.c                 |   15 +-
 drivers/infiniband/hw/cxgb4/Makefile            |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c                |   36 +-
 drivers/infiniband/hw/cxgb4/device.c            |  339 ++-
 drivers/infiniband/hw/cxgb4/ev.c                |    8 +-
 drivers/infiniband/hw/cxgb4/id_table.c          |  112 +
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h          |  134 +-
 drivers/infiniband/hw/cxgb4/mem.c               |   21 +-
 drivers/infiniband/hw/cxgb4/provider.c          |   19 +-
 drivers/infiniband/hw/cxgb4/qp.c                |  105 +-
 drivers/infiniband/hw/cxgb4/resource.c          |  180 +-
 drivers/infiniband/hw/cxgb4/t4.h                |   24 +
 drivers/infiniband/hw/cxgb4/user.h              |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c     |    3 +-
 drivers/infiniband/hw/ipath/ipath_intr.c        |    3 +-
 drivers/infiniband/hw/mlx4/cq.c                 |   13 +-
 drivers/infiniband/hw/mlx4/main.c               |  104 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h            |    2 +
 drivers/infiniband/hw/mlx4/mr.c                 |    2 +-
 drivers/infiniband/hw/mlx4/qp.c                 |   54 +-
 drivers/infiniband/hw/mlx4/srq.c                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c              |    7 +-
 drivers/infiniband/hw/ocrdma/Kconfig            |    8 +
 drivers/infiniband/hw/ocrdma/Makefile           |    5 +
 drivers/infiniband/hw/ocrdma/ocrdma.h           |  393 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h       |  134 ++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  172 ++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h        |   42 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c        | 2640 +++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h        |  132 ++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c      |  577 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h       | 1672 ++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     | 2537 ++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h     |   94 +
 drivers/infiniband/hw/qib/qib.h                 |   35 +-
 drivers/infiniband/hw/qib/qib_driver.c          |    5 +-
 drivers/infiniband/hw/qib/qib_iba6120.c         |    1 +
 drivers/infiniband/hw/qib/qib_iba7220.c         |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c         |    3 +-
 drivers/infiniband/hw/qib/qib_init.c            |    3 +-
 drivers/infiniband/hw/qib/qib_mad.c             |   63 +-
 drivers/infiniband/hw/qib/qib_qp.c              |    7 +
 drivers/infiniband/hw/qib/qib_rc.c              |    4 +-
 drivers/infiniband/hw/qib/qib_ruc.c             |   12 +-
 drivers/infiniband/hw/qib/qib_sysfs.c           |    7 +-
 drivers/infiniband/hw/qib/qib_tx.c              |   25 +-
 drivers/infiniband/hw/qib/qib_uc.c              |    4 +-
 drivers/infiniband/hw/qib/qib_ud.c              |   16 +-
 drivers/infiniband/hw/qib/qib_verbs.h           |  145 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c        |    5 +-
 drivers/infiniband/ulp/iser/iser_verbs.c        |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |   23 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  235 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  |   11 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c        |   22 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |   62 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h    |   53 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h   |   15 +
 drivers/net/ethernet/emulex/benet/Makefile      |    2 +-
 drivers/net/ethernet/emulex/benet/be.h          |   38 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c     |   39 +
 drivers/net/ethernet/emulex/benet/be_cmds.h     |    1 +
 drivers/net/ethernet/emulex/benet/be_hw.h       |    4 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |   88 +-
 drivers/net/ethernet/emulex/benet/be_roce.c     |  182 ++
 drivers/net/ethernet/emulex/benet/be_roce.h     |   75 +
 drivers/net/ethernet/mellanox/mlx4/alloc.c      |    3 -
 drivers/net/ethernet/mellanox/mlx4/fw.c         |   29 +
 drivers/net/ethernet/mellanox/mlx4/fw.h         |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c       |    2 +
 include/linux/mlx4/device.h                     |    8 +
 include/linux/mlx4/qp.h                         |    3 +-
 include/rdma/ib_mad.h                           |    2 +-
 include/rdma/ib_verbs.h                         |    4 +-
 80 files changed, 10546 insertions(+), 447 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/id_table.c
 create mode 100644 drivers/infiniband/hw/ocrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/ocrdma/Makefile
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_abi.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_ah.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_ah.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_hw.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_hw.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_main.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_sli.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
 create mode 100644 drivers/net/ethernet/emulex/benet/be_roce.c
 create mode 100644 drivers/net/ethernet/emulex/benet/be_roce.h
