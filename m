Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1EZQqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:46:48 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:58612 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932347Ab1EZQqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:46:46 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 26 May 2011 09:46:41 -0700
Message-Id: <1306428401-18830-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the second, main batch of 2.6.40 changes:
 - Add netlink-based way to dump active RDMA connections
 - Update char devices to use /dev/infiniband/... paths
 - Chelsio driver fixes
 - Fix for crash on access to QP0 with IBoE devices
 - Couple of warning fixes

Ira Weiny (1):
      IB/mad: Return EPROTONOSUPPORT when an RDMA device lacks the QP required

Liu Yuan (1):
      RDMA/nes: Add a check for strict_strtoul()

Nir Muchtar (4):
      RDMA: Add error handling to ib_core_init()
      RDMA/cma: Export enum cma_state in <rdma/rdma_cm.h>
      RDMA/cma: Add support for netlink statistics export
      RDMA/cma: Save PID of ID's owner

Roland Dreier (7):
      RDMA: Add netlink infrastructure
      RDMA/ucma: Add .nodename/.mode to tell userspace where to create device node
      IB/uverbs: Add devnode method to set path/mode
      IB: Add devnode methods to cm_class and umad_class
      IB/srp: Fix integer -> pointer cast warnings
      RDMA: Update exported headers list
      Merge branches 'cma', 'cxgb3', 'cxgb4', 'misc', 'nes', 'netlink', 'srp' and 'uverbs' into for-next

Sean Hefty (1):
      RDMA/cma: Pass QP type into rdma_create_id()

Steve Wise (2):
      RDMA/cxgb4: Use completion objects for event blocking
      RDMA/cxgb3: Don't post zero-byte read if endpoint is going away

 drivers/infiniband/Kconfig                  |    1 +
 drivers/infiniband/core/Makefile            |    2 +-
 drivers/infiniband/core/cm.c                |    8 +
 drivers/infiniband/core/cma.c               |  308 +++++++++++++++++----------
 drivers/infiniband/core/device.c            |   25 ++-
 drivers/infiniband/core/mad.c               |    7 +
 drivers/infiniband/core/netlink.c           |  190 +++++++++++++++++
 drivers/infiniband/core/ucma.c              |   35 +++-
 drivers/infiniband/core/user_mad.c          |    7 +
 drivers/infiniband/core/uverbs_main.c       |    8 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |   26 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.h |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |    6 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   18 +--
 drivers/infiniband/hw/nes/nes.c             |    4 +-
 drivers/infiniband/hw/qib/Kconfig           |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |    4 +-
 include/linux/netlink.h                     |    1 +
 include/rdma/Kbuild                         |    5 +
 include/rdma/ib_user_cm.h                   |    1 +
 include/rdma/rdma_cm.h                      |   19 ++-
 include/rdma/rdma_netlink.h                 |   92 ++++++++
 net/9p/trans_rdma.c                         |    3 +-
 net/rds/ib.c                                |    2 +-
 net/rds/ib_cm.c                             |    2 +-
 net/rds/iw.c                                |    2 +-
 net/rds/iw_cm.c                             |    2 +-
 net/rds/rdma_transport.c                    |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c    |    3 +-
 net/sunrpc/xprtrdma/verbs.c                 |    2 +-
 31 files changed, 633 insertions(+), 159 deletions(-)
 create mode 100644 drivers/infiniband/core/netlink.c
 create mode 100644 include/rdma/rdma_netlink.h
