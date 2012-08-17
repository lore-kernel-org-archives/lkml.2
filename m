Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2HQSiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:38:54 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:50551 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752095Ab2HQSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:38:45 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 17 Aug 2012 11:38:29 -0700
Message-Id: <1345228709-14247-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Grab bag of InfiniBand/RDMA fixes:
 - IPoIB fixes for regressions introduced by path database conversion
 - mlx4 fixes for bugs with large memory systems and regressions from SR-IOV patches
 - RDMA CM fix for passing bad event up to userspace
 - Other minor fixes

----------------------------------------------------------------
Bart Van Assche (1):
      IB/srp: Fix a race condition

Jack Morgenstein (1):
      IB/mlx4: Fix possible deadlock on sm_lock spinlock

Julia Lawall (1):
      IB/qib: Fix error return code in qib_init_7322_variables()

Kleber Sacilotto de Souza (1):
      IB/mlx4: Check iboe netdev pointer before dereferencing it

Masanari Iida (1):
      IB: Fix typos in infiniband drivers

Roland Dreier (3):
      RDMA/ocrdma: Don't call vlan_dev_real_dev() for non-VLAN netdevs
      mlx4_core: Clean up buddy bitmap allocation
      Merge branches 'cma', 'ipoib', 'misc', 'mlx4', 'ocrdma', 'qib' and 'srp' into for-next

Shlomo Pongratz (2):
      IB/ipoib: Add missing locking when CM object is deleted
      IB/ipoib: Fix RCU pointer dereference of wrong object

Tatyana Nikolova (1):
      RDMA/ucma.c: Fix for events with wrong context on iWARP

Yishai Hadas (2):
      mlx4_core: Allow large mlx4_buddy bitmaps
      mlx4_core: Fix integer overflow issues around MTT table

 drivers/infiniband/core/ucma.c               |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    2 +-
 drivers/infiniband/hw/mlx4/mad.c             |   16 +++--
 drivers/infiniband/hw/mlx4/main.c            |    5 +-
 drivers/infiniband/hw/mlx4/qp.c              |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   16 ++---
 drivers/infiniband/hw/qib/qib_iba7322.c      |    4 +-
 drivers/infiniband/hw/qib/qib_sd7220.c       |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    3 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   87 +++++++++++++++++++-------
 drivers/infiniband/ulp/srpt/ib_srpt.c        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c     |    9 ++-
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c      |   27 +++++---
 drivers/net/ethernet/mellanox/mlx4/profile.c |    4 +-
 18 files changed, 130 insertions(+), 65 deletions(-)
