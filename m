Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2BAGgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:36:48 -0500
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:51756 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751375Ab2BAGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:36:46 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 31 Jan 2012 22:36:36 -0800
Message-Id: <1328078196-18601-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git rdma-for-linus

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.3:

 - Fix a crash due to a regression (uninitialized refcnt) introduced in
   3.2 with XRC support.
 - Close race in how ucma reports events when connect fails.
 - Process vendor-specific MADs in mlx4 so that eg FDR-10 data rate works.
 - Fix regression in qib caused by over-aggressive PCIe tuning.
 - Other small fixes for hardware drivers (ipath, nes, qib).

----------------------------------------------------------------
Bernd Schubert (1):
      RDMA/core: Fix kernel panic by always initializing qp->usecnt

Dan Carpenter (1):
      IB/ipath: Calling PTR_ERR() on right variable in create_file()

Jack Morgenstein (1):
      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Julia Lawall (1):
      IB/qib: Use GFP_ATOMIC when locks are held

Mike Marciniszyn (1):
      IB/qib: Roll back PCIe tuning change

Roland Dreier (2):
      RDMA/nes: Add missing rcu_read_unlock() in nes_addr_resolve_neigh()
      Merge branches 'cma', 'ipath', 'misc', 'mlx4', 'nes' and 'qib' into for-next

Sean Hefty (1):
      RDMA/ucma: Discard all events for new connections until accepted

Tatyana Nikolova (4):
      RDMA/nes: Fix for sending MPA reject frame
      RDMA/nes: Fix fast memory registration length
      RDMA/nes: Fix fast memory registration opcode
      RDMA/nes: Copyright update

 drivers/infiniband/core/ucma.c          |    5 ++++-
 drivers/infiniband/core/uverbs_cmd.c    |    1 +
 drivers/infiniband/core/verbs.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_fs.c  |    2 +-
 drivers/infiniband/hw/mlx4/mad.c        |    7 ++-----
 drivers/infiniband/hw/nes/nes.c         |    2 +-
 drivers/infiniband/hw/nes/nes.h         |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c      |   10 +++++++---
 drivers/infiniband/hw/nes/nes_cm.h      |    2 +-
 drivers/infiniband/hw/nes/nes_context.h |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c      |    2 +-
 drivers/infiniband/hw/nes/nes_hw.h      |    2 +-
 drivers/infiniband/hw/nes/nes_mgt.c     |    2 +-
 drivers/infiniband/hw/nes/nes_mgt.h     |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c     |    2 +-
 drivers/infiniband/hw/nes/nes_user.h    |    2 +-
 drivers/infiniband/hw/nes/nes_utils.c   |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c   |    6 ++++--
 drivers/infiniband/hw/nes/nes_verbs.h   |    2 +-
 drivers/infiniband/hw/qib/qib_iba6120.c |    2 +-
 drivers/infiniband/hw/qib/qib_pcie.c    |    2 +-
 21 files changed, 34 insertions(+), 27 deletions(-)
