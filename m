Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1GVTJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:09:01 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:58704 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754619Ab1GVTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:09:00 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 22 Jul 2011 12:08:52 -0700
Message-Id: <1311361732-7176-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Congrats on the recent version number bump.  Please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get my 3.1 merge window changes:
 - Various fixes to the qib hardware driver.
 - Improvements to IBoE support, mostly in the mlx4 hardware driver.
 - A nice cleanup to the mthca driver from Goldwyn Rodrigues that
   actually lets this pull request delete more lines than it adds.
 - Various other small fixes.

Bart Van Assche (2):
      IB/srp: Avoid duplicate devices from LUN scan
      RDMA: Allow for NULL .modify_device() and .modify_port() methods

Dotan Barak (1):
      mlx4_core: Bump the driver version to 1.0

Edwin van Vliet (1):
      IB/qib: Remove double define

Goldwyn Rodrigues (1):
      IB/mthca: Stop returning separate error and status from FW commands

Jack Morgenstein (1):
      RDMA/cma: Avoid assigning an IS_ERR value to cm_id pointer in CMA id object

Jon Mason (2):
      IB/qib: Remove unnecessary read of PCI_CAP_ID_EXP
      IB/mthca: Remove unnecessary read of PCI_CAP_ID_EXP

Manuel Zerpies (1):
      RDMA/cxgb4: Use printk_ratelimited() instead of printk_ratelimit()

Mike Marciniszyn (2):
      MAINTAINERS: Update ipath/qib (QLogic IB adapter) entries
      IB/qib: Defer HCA error events to tasklet

Mitko Haralanov (1):
      IB/qib: Update active link width

Moni Shoua (1):
      RDMA/cma: Don't allow IPoIB port space for IBoE

Motohiro KOSAKI (2):
      IB/qib: Convert old cpumask api into new one
      IB/ipath: Convert old cpumask api into new one

Or Gerlitz (9):
      IB/core: Add GID change event
      IB/mlx4: Generate GID change events in IBoE code
      mlx4_core: Extend capability flags to 64 bits
      mlx4_core: Read extended capabilities into the flags field
      mlx4_core: Fix location of counter index in QP context struct
      mlx4_core: Add network flow counters
      IB/pma: Add include file for IBA performance counters definitions
      IB/mlx4: Use flow counters on IBoE ports
      IB/mlx4: Support PMA counters for IBoE

Ram Vepa (2):
      IB/qib: Add sysfs interface to read free contexts
      IB/qib: Fix potential deadlock with link down interrupt

Roland Dreier (1):
      Merge branches 'cma', 'cxgb4', 'ipath', 'misc', 'mlx4', 'mthca', 'qib' and 'srp' into for-next

 MAINTAINERS                                  |   11 +-
 drivers/infiniband/core/cache.c              |    3 +-
 drivers/infiniband/core/cma.c                |   84 ++++----
 drivers/infiniband/core/device.c             |    6 +
 drivers/infiniband/hw/amso1100/c2_provider.c |    9 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    8 -
 drivers/infiniband/hw/cxgb4/provider.c       |    8 -
 drivers/infiniband/hw/cxgb4/resource.c       |    9 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   11 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |  198 +++---------------
 drivers/infiniband/hw/mlx4/mad.c             |   68 +++++++-
 drivers/infiniband/hw/mlx4/main.c            |   21 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    1 +
 drivers/infiniband/hw/mlx4/qp.c              |   10 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c      |  276 ++++++++++++++------------
 drivers/infiniband/hw/mthca/mthca_cmd.h      |   93 ++++-----
 drivers/infiniband/hw/mthca/mthca_cq.c       |   15 +--
 drivers/infiniband/hw/mthca/mthca_eq.c       |   43 +---
 drivers/infiniband/hw/mthca/mthca_mad.c      |   15 +-
 drivers/infiniband/hw/mthca/mthca_main.c     |  175 +++++------------
 drivers/infiniband/hw/mthca/mthca_mcg.c      |  101 +++-------
 drivers/infiniband/hw/mthca/mthca_memfree.c  |   43 ++---
 drivers/infiniband/hw/mthca/mthca_mr.c       |   35 +---
 drivers/infiniband/hw/mthca/mthca_provider.c |   77 +------
 drivers/infiniband/hw/mthca/mthca_qp.c       |   49 ++----
 drivers/infiniband/hw/mthca/mthca_reset.c    |    2 +-
 drivers/infiniband/hw/mthca/mthca_srq.c      |   33 +---
 drivers/infiniband/hw/nes/nes_verbs.c        |   11 -
 drivers/infiniband/hw/qib/qib.h              |    3 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |   16 +-
 drivers/infiniband/hw/qib/qib_iba7220.c      |   26 +++-
 drivers/infiniband/hw/qib/qib_iba7322.c      |   72 +++++--
 drivers/infiniband/hw/qib/qib_mad.c          |   78 ++++----
 drivers/infiniband/hw/qib/qib_mad.h          |  143 +-------------
 drivers/infiniband/hw/qib/qib_pcie.c         |    8 +-
 drivers/infiniband/hw/qib/qib_sysfs.c        |   14 ++
 drivers/infiniband/ulp/srp/ib_srp.c          |    2 +
 drivers/net/mlx4/en_ethtool.c                |    9 +-
 drivers/net/mlx4/en_main.c                   |    3 +-
 drivers/net/mlx4/en_netdev.c                 |    5 +-
 drivers/net/mlx4/en_port.c                   |    6 +-
 drivers/net/mlx4/en_selftest.c               |    3 +-
 drivers/net/mlx4/fw.c                        |   39 +++--
 drivers/net/mlx4/fw.h                        |    8 +-
 drivers/net/mlx4/main.c                      |   58 +++++-
 drivers/net/mlx4/mcg.c                       |   17 +-
 drivers/net/mlx4/mlx4.h                      |    5 +-
 drivers/net/mlx4/port.c                      |    8 +-
 include/linux/mlx4/cmd.h                     |    3 +
 include/linux/mlx4/device.h                  |   60 ++++--
 include/linux/mlx4/qp.h                      |    8 +-
 include/rdma/ib_pma.h                        |  156 +++++++++++++++
 include/rdma/ib_verbs.h                      |    3 +-
 53 files changed, 1006 insertions(+), 1162 deletions(-)
 create mode 100644 include/rdma/ib_pma.h
