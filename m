Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1KAQyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:54:53 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:32794 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755457Ab1KAQyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:54:51 -0400
From: Roland Dreier <roland@purestorage.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue,  1 Nov 2011 09:54:43 -0700
Message-Id: <1320166483-21817-1-git-send-email-roland@purestorage.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@kernel.org>

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the main batch of changes for 3.2.  One note: my tree is
based on 3.1-rc9, and I have some changes to drivers/net/mlx4, but in
your tree that driver has moved to drivers/net/ethernet/mellanox/mlx4.
With a high enough merge.renamelimit, git handles this merge fine in
my test, so I'm assuming you would want to do the merge yourself.

Anyway, the main things here are:
 - Finally we get XRC support upstream, thanks to Sean Hefty's
   cleaning up of the series.
 - MPAv2 support for iWARP devices, which makes negotiating limits
   during connection much cleaner.
 - Support for reporting new higher link speeds (FDR, FDR-10, EDR).
 - Optimizations to the qib driver.
 - Various fixes and cleanups, mostly to low-level hardware drivers.

Andy Shevchenko (1):
      RDMA/amso1100: Use '%pM' format option to print MAC

Dotan Barak (2):
      mlx4_core: Use the right function to free eq->page_list entries
      IPoIB: Use the right function to do DMA unmap pages

Eli Cohen (1):
      mlx4_core: Fix buddy->num_free allocation size

Faisal Latif (3):
      RDMA/nes: Fix terminate connection
      RDMA/nes: Print IP address for critcal errors
      RDMA/nes: Support for Packed And Unaligned fpdus

Hefty, Sean (4):
      RDMA/cma: Fix crash in cma_req_handler
      RDMA/cma: Check for NULL conn_param in rdma_accept
      IB/mad: Verify mgmt class in received MADs
      RDMA/ucm: Removed checks for unsigned value < 0

Jonathan Lallinger (1):
      RDMA/cxgb4: Use correct QID in insert_recv_cqe()

Julia Lawall (1):
      RDMA/nes: Add missing calls to ib_umem_release()

Kumar Sanghvi (6):
      RDMA/iwcm: Propagate ird/ord values upwards
      RDMA/{amso1100,cxgb3}: Minimal MPAv2 support
      RDMA/cxgb4: Add support for MPAv2 Enhanced RDMA Negotiation
      RDMA/cxgb4: Make sure flush CQ entries are collected on connection close
      RDMA/cxgb3: Serialize calls to CQ's comp_handler
      RDMA/cxgb4: Serialize calls to CQ's comp_handler

Marcel Apfelbaum (4):
      IB: Add new InfiniBand link speeds
      IPoIB: Handle extended rates in debugfs
      mlx4_core: Add extended port capabilities support
      IB/mlx4: Configure extended active speeds

Mike Marciniszyn (8):
      IB/qib: Correct nfreectxts for multiple HCAs
      IB/qib: Optimize RC/UC code by IB operation
      IB/qib: Decode path MTU optimization
      IB/qib: Eliminate divide/mod in converting idx to egr buf pointer
      IB/qib: Use RCU for qpn lookup
      IB/qib: Precompute timeout jiffies to optimize latency
      IB/qib: Remove s_lock around header validation
      IB/qib: Clean up checkpatch issue

Mitko Haralanov (2):
      IB/qib: Hold links until tuning data is available
      IB/qib: Fix issue with link states and QSFP cables

Or Gerlitz (3):
      IB/mlx4: Enable 4K mtu for IBoE
      IB/mlx4: Don't set VLAN in IBoE WQEs' control segment
      mlx4_core: Deprecate log_num_vlan module param

Randy Dunlap (1):
      IB/ipath: Add missing <linux/stat.h> in ipath_chip_init.c

Roland Dreier (2):
      mlx4_core: Clean up error flow in mlx4_register_mac()
      Merge branches 'amso1100', 'cma', 'cxgb3', 'cxgb4', 'fdr', 'ipath', 'ipoib', 'misc', 'mlx4', 'misc', 'nes', 'qib' and 'xrc' into for-next

Sean Hefty (20):
      RDMA/core: Add XRC domain support
      RDMA/core: Add SRQ type field
      RDMA/core: Add XRC SRQ type
      RDMA/core: Add XRC QPs
      RDMA/verbs: Cleanup XRC TGT QPs when destroying XRCD
      RDMA/uverbs: Export XRC domains to user space
      RDMA/uverbs: Export XRC SRQs to user space
      RDMA/uverbs: Export XRC INI QPs to userspace
      RDMA/uverbs: Export XRC TGT QPs to user space
      IB/cm: Update protocol to support XRC
      IB/cm: Update XRC support based on XRC annex errata
      RDMA/cm: Define new RDMA port space specific to IB
      RDMA/ucm: Allow user to specify QP type when creating id
      RDMA/cma: Support XRC QPs
      IB/cm: Do not automatically disconnect XRC TGT QPs
      IB/mlx4: Add support for XRC domains
      IB/mlx4: Add support for XRC SRQs
      IB/mlx4: Add support for XRC QPs
      RDMA/core: Export ib_open_qp() to share XRC TGT QPs
      RDMA/uverbs: Export ib_open_qp() capability to user space

Steve Wise (1):
      RDMA/cxgb4: Fail RDMA initialization for unsupported cards

Tatyana Nikolova (1):
      RDMA/nes: Add support for MPAv2 Enhanced RDMA Negotiation

Tom Tucker (1):
      RDMA/cxgb4: Mark QP in error before disabling the queue in firmware

Yong Zhang (1):
      IB/ehca: Remove IRQF_DISABLED, since it's a no-op

 drivers/infiniband/core/cm.c                  |   63 +-
 drivers/infiniband/core/cm_msgs.h             |   32 +-
 drivers/infiniband/core/cma.c                 |   67 +-
 drivers/infiniband/core/mad.c                 |    3 +
 drivers/infiniband/core/sysfs.c               |   26 +-
 drivers/infiniband/core/ucm.c                 |    2 +-
 drivers/infiniband/core/ucma.c                |    7 +-
 drivers/infiniband/core/user_mad.c            |    5 +-
 drivers/infiniband/core/uverbs.h              |   18 +
 drivers/infiniband/core/uverbs_cmd.c          |  703 ++++++++++++++--
 drivers/infiniband/core/uverbs_main.c         |   30 +-
 drivers/infiniband/core/verbs.c               |  376 ++++++++-
 drivers/infiniband/hw/amso1100/c2_ae.c        |    5 +
 drivers/infiniband/hw/amso1100/c2_intr.c      |    5 +
 drivers/infiniband/hw/amso1100/c2_provider.c  |    5 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c         |   10 +
 drivers/infiniband/hw/cxgb3/iwch_ev.c         |    6 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.h   |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c         |   14 +-
 drivers/infiniband/hw/cxgb4/cm.c              |  469 +++++++++-
 drivers/infiniband/hw/cxgb4/cq.c              |    3 +-
 drivers/infiniband/hw/cxgb4/device.c          |   41 +-
 drivers/infiniband/hw/cxgb4/ev.c              |   10 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   23 +-
 drivers/infiniband/hw/cxgb4/qp.c              |   39 +-
 drivers/infiniband/hw/ehca/ehca_eq.c          |    4 +-
 drivers/infiniband/hw/ehca/ehca_qp.c          |    3 +
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    1 +
 drivers/infiniband/hw/ipath/ipath_srq.c       |    5 +
 drivers/infiniband/hw/mlx4/main.c             |  106 +++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   13 +
 drivers/infiniband/hw/mlx4/qp.c               |  131 ++-
 drivers/infiniband/hw/mlx4/srq.c              |   10 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |    3 +
 drivers/infiniband/hw/nes/Makefile            |    2 +-
 drivers/infiniband/hw/nes/nes.c               |    8 +-
 drivers/infiniband/hw/nes/nes.h               |   17 +-
 drivers/infiniband/hw/nes/nes_cm.c            | 1121 ++++++++++++++----------
 drivers/infiniband/hw/nes/nes_cm.h            |   75 ++-
 drivers/infiniband/hw/nes/nes_hw.c            |   99 ++-
 drivers/infiniband/hw/nes/nes_hw.h            |   35 +-
 drivers/infiniband/hw/nes/nes_mgt.c           | 1162 +++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_mgt.h           |   97 ++
 drivers/infiniband/hw/nes/nes_nic.c           |    4 +
 drivers/infiniband/hw/nes/nes_utils.c         |   53 +-
 drivers/infiniband/hw/nes/nes_verbs.c         |    8 +-
 drivers/infiniband/hw/nes/nes_verbs.h         |   12 +-
 drivers/infiniband/hw/qib/qib.h               |   15 +-
 drivers/infiniband/hw/qib/qib_driver.c        |   20 +-
 drivers/infiniband/hw/qib/qib_file_ops.c      |    2 +
 drivers/infiniband/hw/qib/qib_iba6120.c       |    2 +
 drivers/infiniband/hw/qib/qib_iba7220.c       |    2 +
 drivers/infiniband/hw/qib/qib_iba7322.c       |  135 ++-
 drivers/infiniband/hw/qib/qib_init.c          |    8 +-
 drivers/infiniband/hw/qib/qib_qp.c            |   90 ++-
 drivers/infiniband/hw/qib/qib_qsfp.c          |   25 +-
 drivers/infiniband/hw/qib/qib_qsfp.h          |    3 +
 drivers/infiniband/hw/qib/qib_rc.c            |   36 +-
 drivers/infiniband/hw/qib/qib_ruc.c           |    7 +-
 drivers/infiniband/hw/qib/qib_srq.c           |    5 +
 drivers/infiniband/hw/qib/qib_sysfs.c         |    3 +-
 drivers/infiniband/hw/qib/qib_uc.c            |   25 +-
 drivers/infiniband/hw/qib/qib_verbs.c         |   36 +-
 drivers/infiniband/hw/qib/qib_verbs.h         |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c       |    7 +-
 drivers/net/mlx4/eq.c                         |    2 +-
 drivers/net/mlx4/fw.c                         |    6 +
 drivers/net/mlx4/fw.h                         |    2 +
 drivers/net/mlx4/main.c                       |   36 +-
 drivers/net/mlx4/mlx4.h                       |    4 +
 drivers/net/mlx4/mr.c                         |    2 +-
 drivers/net/mlx4/pd.c                         |   30 +
 drivers/net/mlx4/port.c                       |   72 ++-
 drivers/net/mlx4/qp.c                         |    3 +
 drivers/net/mlx4/srq.c                        |   20 +-
 include/linux/mlx4/device.h                   |   16 +-
 include/linux/mlx4/qp.h                       |    3 +-
 include/rdma/ib_user_verbs.h                  |   48 +-
 include/rdma/ib_verbs.h                       |  106 +++-
 include/rdma/iw_cm.h                          |    4 +-
 include/rdma/rdma_cm.h                        |    1 +
 include/rdma/rdma_user_cm.h                   |    3 +-
 84 files changed, 4738 insertions(+), 984 deletions(-)
 create mode 100644 drivers/infiniband/hw/nes/nes_mgt.c
 create mode 100644 drivers/infiniband/hw/nes/nes_mgt.h
