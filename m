Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1COSCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:02:13 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:39589 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756529Ab1COSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:02:10 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 15 Mar 2011 11:01:58 -0700
Message-Id: <1300212118-12602-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of 2.6.39 changes:
 - Fixes and improvements for the iw_cxgb4 low-level driver
 - Fixes to the ib_qib low-level driver
 - Fixes for crashes in the RDMA CM (also tagged for stable)

Mitko Haralanov (3):
      IB/qib: Return correct MAD when setting link width to 255
      IB/qib: Set default LE2 value for active cables to 0
      IB/qib: Fix M_Key field in SubnGet and SubnGetResp MADs

Nicolas Kaiser (1):
      IB/ipath: Don't reset disabled devices

Roland Dreier (1):
      Merge branches 'cma', 'cxgb4', 'ipath' and 'qib' into for-next

Sean Hefty (4):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback
      IB/cm: Cancel pending LAP message when exiting IB_CM_ESTABLISH state
      RDMA/cma: Replace global lock in rdma_destroy_id() with id-specific one

Steve Wise (7):
      RDMA/cxgb4: Turn on delayed ACK
      RDMA/cxgb4: Remove db_drop_task
      RDMA/cxgb4: Do CIDX_INC updates every 1/16 CQ depth CQE reaps
      RDMA/cxgb4: Enable on-chip SQ support by default
      RDMA/cxgb4: Use ULP_MODE_TCPDDP
      RDMA/cxgb4: Dispatch FATAL event on EEH errors
      RDMA/cxgb4: Debugfs dump_qp() updates

 drivers/infiniband/core/cm.c              |   20 +++++++++-
 drivers/infiniband/core/cma.c             |   58 +++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/cm.c          |    6 ++-
 drivers/infiniband/hw/cxgb4/device.c      |   24 +++++++++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |    1 -
 drivers/infiniband/hw/cxgb4/qp.c          |    4 +-
 drivers/infiniband/hw/cxgb4/t4.h          |    8 +++-
 drivers/infiniband/hw/ipath/ipath_sysfs.c |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c   |   13 +++++-
 drivers/infiniband/hw/qib/qib_mad.c       |   12 +++--
 drivers/infiniband/hw/qib/qib_qsfp.h      |    2 +
 drivers/net/cxgb4/t4_msg.h                |    1 +
 12 files changed, 102 insertions(+), 48 deletions(-)
