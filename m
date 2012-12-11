Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2LKF7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:59:50 -0500
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:40123 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223Ab2LKF7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:59:48 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 10 Dec 2012 21:59:41 -0800
Message-Id: <1355205581-10573-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

First batch of InfiniBand/RDMA changes for the 3.8 merge window:
 - A good chunk of Bart Van Assche's SRP fixes
 - UAPI disintegration from David Howells
 - mlx4 support for "64-byte CQE" hardware feature from Or Gerlitz
 - Other miscellaneous fixes

----------------------------------------------------------------
Alan Cox (2):
      IB/ipath: Remove unreachable code
      RDMA/amsol1100: Fix missing break

Bart Van Assche (14):
      IB/srp: Increase block layer timeout
      IB/srp: Eliminate state SRP_TARGET_CONNECTING
      IB/srp: Keep processing commands during host removal
      IB/srp: Simplify SCSI error handling
      IB/srp: Introduce srp_handle_qp_err()
      IB/srp: Process all error completions
      IB/srp: Suppress superfluous error messages
      IB/srp: Introduce the helper function srp_remove_target()
      IB/srp: Eliminate state SRP_TARGET_DEAD
      IB/srp: Document sysfs attributes
      srp_transport: Fix attribute registration
      srp_transport: Simplify attribute initialization code
      srp_transport: Document sysfs attributes
      IB/srp: Allow SRP disconnect through sysfs

David Howells (1):
      UAPI: (Scripted) Disintegrate include/rdma

Ishai Rabinovitz (1):
      IB/srp: destroy and recreate QP and CQs when reconnecting

Jack Morgenstein (2):
      IB/mlx4: Fix spinlock order to avoid lockdep warnings
      mlx4_core: Fix potential deadlock in mlx4_eq_int()

Julia Lawall (3):
      RDMA/nes: Use WARN()
      RDMA/cxgb4: use WARN
      RDMA/cxgb3: use WARN

Or Gerlitz (1):
      mlx4: 64-byte CQE/EQE support

Roland Dreier (4):
      Merge branches 'cxgb4', 'misc', 'mlx4', 'nes' and 'uapi' into for-next
      Merge branches 'cma' and 'mlx4' into for-next
      Merge branch 'srp' into for-next
      Merge branch 'nes' into for-next

Tatyana Nikolova (7):
      RDMA/nes: Fix incorrect address of IP header
      RDMA/nes: Fix for unlinking skbs from empty list
      RDMA/nes: Fix for sending fpdus in order to hardware
      RDMA/nes: Fix for incorrect multicast address in the perfect filter table
      RDMA/nes: Fix for BUG_ON due to adding already-pending timer
      RDMA/nes: Fix for terminate timer crash
      RDMA/nes: Fix for crash when registering zero length MR for CQ

Vu Pham (1):
      IB/srp: send disconnect request without waiting for CM timewait exit

shefty (1):
      RDMA/cm: Change return value from find_gid_port()

 Documentation/ABI/stable/sysfs-driver-ib_srp   |  156 ++++++++++++
 Documentation/ABI/stable/sysfs-transport-srp   |   19 ++
 drivers/infiniband/core/cma.c                  |    9 +-
 drivers/infiniband/hw/amso1100/c2_ae.c         |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    6 +-
 drivers/infiniband/hw/cxgb4/cm.c               |    6 +-
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |   10 -
 drivers/infiniband/hw/mlx4/cm.c                |    4 +-
 drivers/infiniband/hw/mlx4/cq.c                |   34 ++-
 drivers/infiniband/hw/mlx4/main.c              |   27 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    1 +
 drivers/infiniband/hw/mlx4/user.h              |   12 +-
 drivers/infiniband/hw/nes/nes.h                |    1 +
 drivers/infiniband/hw/nes/nes_cm.c             |   32 +--
 drivers/infiniband/hw/nes/nes_hw.c             |    9 +-
 drivers/infiniband/hw/nes/nes_mgt.c            |   42 ++--
 drivers/infiniband/hw/nes/nes_nic.c            |   13 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |    9 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |  314 ++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h            |   11 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c       |   11 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c        |   36 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.c        |   30 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h        |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c      |   38 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1 +
 drivers/scsi/scsi_transport_srp.c              |   51 ++--
 include/linux/mlx4/device.h                    |   21 ++
 include/rdma/Kbuild                            |    6 -
 include/rdma/rdma_netlink.h                    |   36 +--
 include/scsi/scsi_transport_srp.h              |    8 +
 include/uapi/rdma/Kbuild                       |    6 +
 include/{ => uapi}/rdma/ib_user_cm.h           |    0
 include/{ => uapi}/rdma/ib_user_mad.h          |    0
 include/{ => uapi}/rdma/ib_user_sa.h           |    0
 include/{ => uapi}/rdma/ib_user_verbs.h        |    0
 include/uapi/rdma/rdma_netlink.h               |   37 +++
 include/{ => uapi}/rdma/rdma_user_cm.h         |    0
 42 files changed, 689 insertions(+), 322 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-ib_srp
 create mode 100644 Documentation/ABI/stable/sysfs-transport-srp
 rename include/{ => uapi}/rdma/ib_user_cm.h (100%)
 rename include/{ => uapi}/rdma/ib_user_mad.h (100%)
 rename include/{ => uapi}/rdma/ib_user_sa.h (100%)
 rename include/{ => uapi}/rdma/ib_user_verbs.h (100%)
 create mode 100644 include/uapi/rdma/rdma_netlink.h
 rename include/{ => uapi}/rdma/rdma_user_cm.h (100%)
