Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2GWQR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:17:27 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:60950 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753470Ab2GWQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:17:26 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 23 Jul 2012 09:17:08 -0700
Message-Id: <1343060228-19414-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-3.6

----------------------------------------------------------------

InfiniBand/RDMA changes for the 3.6 merge window:
 - Updates to the qib low-level driver
 - First chunk of changes for SR-IOV support for mlx4 IB
 - RDMA CM support for IPv6-only binding
 - Other misc cleanups and fixes

----------------------------------------------------------------
Betty Dall (1):
      IB/qib: Fix an incorrect log message

Dotan Barak (6):
      IB/mthca: Warning about event for non-existent QPs should show event type
      IB/mthca: Fill in sq_sig_type in query QP
      IB/mlx4: Fill the masked_atomic_cap attribute in query device
      mlx4_core: Remove double function declarations
      IB/cm: Destroy idr as part of the module init error flow
      net/mlx4_core: Free ICM table in case of error

Erez Shitrit (1):
      IB/sa: Add GuidInfoRecord query support

Jack Morgenstein (8):
      mlx4_core: Pass an invalid PCI id number to VFs
      IB/mlx4: Add debug prints
      IB/core: Move CM_xxx_ATTR_ID macros from cm_msgs.h to ib_cm.h
      mlx4: Use port management change event instead of smp_snoop
      net/mlx4_core: Initialize IB port capabilities for all slaves
      mlx4_core: Implement mechanism for reserved Q_Keys
      mlx4_core: Allow guests to have IB ports
      mlx4: Put physical GID and P_Key table sizes in mlx4_phys_caps struct and paravirtualize them

Mike Marciniszyn (8):
      IB/qib: Fix UC MR refs for immediate operations
      IB/qib: Avoid returning EBUSY from MR deregister
      IB/qib: RCU locking for MR validation
      IB/qib: Fix sparse RCU warnings in qib_keys.c
      IB/qib: Fix QP RCU sparse warnings
      IB/qib: Reduce sdma_lock contention
      IB/qib: Add congestion control agent implementation
      IB/qib: checkpatch fixes

Roland Dreier (4):
      RDMA/ocrdma: Fix assignment of max_srq_sge in device query
      RDMA/cxgb4: Fix endianness of addition to mpa->private_data_size
      IB: Use IS_ENABLED(CONFIG_IPV6)
      Merge branches 'cma', 'cxgb4', 'misc', 'mlx4-sriov', 'mlx-cleanups', 'ocrdma' and 'qib' into for-linus

Sean Hefty (3):
      RDMA/cma: Bind to a specific address family
      RDMA/cma: Listen on specific address family
      RDMA/cma: Allow user to restrict listens to bound address family

 drivers/infiniband/core/addr.c               |    4 +-
 drivers/infiniband/core/cm.c                 |   16 +-
 drivers/infiniband/core/cm_msgs.h            |   12 -
 drivers/infiniband/core/cma.c                |   77 ++++--
 drivers/infiniband/core/sa_query.c           |  133 +++++++++++
 drivers/infiniband/core/ucma.c               |    7 +
 drivers/infiniband/hw/cxgb4/cm.c             |   12 +-
 drivers/infiniband/hw/mlx4/mad.c             |  141 ++++++++---
 drivers/infiniband/hw/mlx4/main.c            |   33 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |   19 ++
 drivers/infiniband/hw/mlx4/qp.c              |   27 ++-
 drivers/infiniband/hw/mthca/mthca_qp.c       |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    2 +-
 drivers/infiniband/hw/qib/qib.h              |   45 +++-
 drivers/infiniband/hw/qib/qib_diag.c         |   13 +-
 drivers/infiniband/hw/qib/qib_driver.c       |   15 +-
 drivers/infiniband/hw/qib/qib_eeprom.c       |   41 ++--
 drivers/infiniband/hw/qib/qib_file_ops.c     |   63 ++---
 drivers/infiniband/hw/qib/qib_fs.c           |   21 +-
 drivers/infiniband/hw/qib/qib_iba6120.c      |   91 +++----
 drivers/infiniband/hw/qib/qib_iba7220.c      |   92 ++++----
 drivers/infiniband/hw/qib/qib_iba7322.c      |  160 +++++++------
 drivers/infiniband/hw/qib/qib_init.c         |  238 +++++++++++++++----
 drivers/infiniband/hw/qib/qib_intr.c         |    8 +-
 drivers/infiniband/hw/qib/qib_keys.c         |  152 +++++++-----
 drivers/infiniband/hw/qib/qib_mad.c          |  327 +++++++++++++++++++++++++-
 drivers/infiniband/hw/qib/qib_mad.h          |  198 +++++++++++++++-
 drivers/infiniband/hw/qib/qib_mr.c           |  247 ++++++++++---------
 drivers/infiniband/hw/qib/qib_pcie.c         |   25 +-
 drivers/infiniband/hw/qib/qib_qp.c           |   56 +++--
 drivers/infiniband/hw/qib/qib_rc.c           |   24 +-
 drivers/infiniband/hw/qib/qib_ruc.c          |   14 +-
 drivers/infiniband/hw/qib/qib_sd7220.c       |   41 ++--
 drivers/infiniband/hw/qib/qib_sdma.c         |   11 +-
 drivers/infiniband/hw/qib/qib_sysfs.c        |  246 +++++++++++++------
 drivers/infiniband/hw/qib/qib_twsi.c         |    8 +-
 drivers/infiniband/hw/qib/qib_uc.c           |   31 +--
 drivers/infiniband/hw/qib/qib_ud.c           |   12 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |   66 +++++-
 drivers/infiniband/hw/qib/qib_verbs.h        |   56 +++--
 drivers/infiniband/hw/qib/qib_wc_x86_64.c    |   14 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c      |   22 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c      |  132 ++++++++---
 drivers/net/ethernet/mellanox/mlx4/icm.c     |    2 +
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    6 -
 drivers/net/ethernet/mellanox/mlx4/intf.c    |    5 +-
 drivers/net/ethernet/mellanox/mlx4/main.c    |   86 +++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |   67 +-----
 drivers/net/ethernet/mellanox/mlx4/port.c    |   11 +-
 include/linux/mlx4/device.h                  |  119 +++++++++-
 include/linux/mlx4/driver.h                  |    3 +-
 include/rdma/ib_cm.h                         |   12 +
 include/rdma/ib_sa.h                         |   33 +++
 include/rdma/rdma_cm.h                       |   10 +
 include/rdma/rdma_user_cm.h                  |    1 +
 58 files changed, 2414 insertions(+), 911 deletions(-)
