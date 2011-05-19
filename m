Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab1ESSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:17:55 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:54818 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934017Ab1ESSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:17:51 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 19 May 2011 11:17:43 -0700
Message-Id: <1305829063-12945-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of 2.6.40 changes: mostly fixes to the
cxgb4 and qib low-level drivers, plus a couple of RDMA CM fixes.

Hefty, Sean (2):
      RDMA/cma: Fix handling of IPv6 addressing in cma_use_port
      RDMA/cma: Add an ID_REUSEADDR option

Mitko Haralanov (1):
      IB/qib: Prevent driver hang with unprogrammed boards

Roel Kluin (1):
      RDMA/cxgb4: Fix missing parentheses

Roland Dreier (2):
      RDMA/iwcm: Get rid of enum iw_cm_event_status
      Merge branches 'cma', 'cxgb4' and 'qib' into for-next

Sergei Shtylyov (2):
      IB/ipath: Use pci_dev->revision, again
      IB/qib: Use pci_dev->revision

Steve Wise (4):
      RDMA/cxgb4: Don't change QP state outside EP lock
      RDMA/cxgb4: Initialization errors can cause crash
      RDMA/cxgb4: Reset wait condition atomically
      RDMA/cxgb4: EEH errors can hang the driver

 drivers/infiniband/core/cma.c              |  207 +++++++++++++++++++---------
 drivers/infiniband/core/iwcm.c             |    2 +-
 drivers/infiniband/core/ucma.c             |    7 +
 drivers/infiniband/hw/cxgb4/cm.c           |   46 ++-----
 drivers/infiniband/hw/cxgb4/device.c       |  115 +++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |   36 ++++--
 drivers/infiniband/hw/cxgb4/provider.c     |    2 -
 drivers/infiniband/hw/cxgb4/qp.c           |    3 +-
 drivers/infiniband/hw/ipath/ipath_driver.c |    9 +-
 drivers/infiniband/hw/nes/nes_cm.c         |   16 +-
 drivers/infiniband/hw/nes/nes_verbs.c      |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c    |    3 +-
 drivers/infiniband/hw/qib/qib_pcie.c       |    5 +-
 include/rdma/iw_cm.h                       |   11 +--
 include/rdma/rdma_cm.h                     |   10 ++
 include/rdma/rdma_user_cm.h                |    5 +-
 16 files changed, 278 insertions(+), 201 deletions(-)
