Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2LUVml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:42:41 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:59233 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751468Ab2LUVmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:42:39 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 21 Dec 2012 13:42:32 -0800
Message-Id: <1356126152-397-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Second batch of InfiniBand/RDMA changes for 3.8:
 - cxgb4 changes to fix lookup engine hash collisions
 - mlx4 changes to make flow steering usable
 - fix to IPoIB to avoid pinning dst reference for too long

----------------------------------------------------------------
Hadar Hen Zion (2):
      mlx4_core: Add QPN enforcement for flow steering rules set by VFs
      mlx4_core: Fix error flow in the flow steering wrapper

Jack Morgenstein (2):
      mlx4_core: Adjustments to Flow Steering activation logic for SR-IOV
      mlx4_core: Allow choosing flow steering mode

Roland Dreier (2):
      IPoIB: Call skb_dst_drop() once skb is enqueued for sending
      Merge branches 'cxgb4', 'ipoib' and 'mlx4' into for-next

Vipul Pandya (5):
      cxgb4: Add T4 filter support
      cxgb4: Add LE hash collision bug fix path in LLD driver
      RDMA/cxgb4: Fix LE hash collision bug for active open connection
      RDMA/cxgb4: Fix LE hash collision bug for passive open connection
      RDMA/cxgb4: Fix bug for active and passive LE hash collision path

 drivers/infiniband/hw/cxgb4/cm.c                   | 791 ++++++++++++++++++---
 drivers/infiniband/hw/cxgb4/device.c               | 210 +++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  33 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   3 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         | 136 ++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 459 +++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |  23 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |  32 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.h           |   3 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  22 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  66 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |  37 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      | 418 +++++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  15 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          | 115 ++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   7 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   6 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  28 +-
 drivers/scsi/csiostor/t4fw_api_stor.h              |  39 -
 include/linux/mlx4/device.h                        |   1 +
 22 files changed, 2234 insertions(+), 214 deletions(-)
