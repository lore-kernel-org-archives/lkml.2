Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2AFRjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:39:10 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:53224 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758913Ab2AFRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:39:07 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  6 Jan 2012 09:38:57 -0800
Message-Id: <1325871537-22436-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

[Trying the signed tag thing for the first time here]

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git infiniband-for-linus

This will get my small batch of stuff for 3.3:
 - Fix for userspace-provokable multicast membership list corruption
 - Fix for CM protocol message layout
 - Fixes and cleanups for qib hardware driver
 - Fixes and cleanup for nes hardware driver
 - Fix for mlx4 handling of Ethernet priority bits
 - Fix for bugs and warnings found by sparse in core code

Eli Cohen (2):
      IB/uverbs: Protect QP multicast list
      IB/cm: Fix layout of APR message

Mike Marciniszyn (4):
      IB/qib: Fix style issues
      IB/qib: Eliminate 64-bit jiffies use
      IB/qib: Optimize locking for get_txreq()
      IB/qib: Default some module parameters optimally

Or Gerlitz (1):
      IB/mlx4: Fix SL to 802.1Q priority-bits mapping for IBoE

Ram Vepa (1):
      IB/qib: Fix a possible data corruption when receiving packets

Roland Dreier (1):
      Merge branches 'cma', 'misc', 'mlx4', 'nes', 'qib' and 'uverbs' into for-next

Sean Hefty (2):
      RDMA/cma: Fix endianness bugs
      rdma/core: Fix sparse warnings

Tatyana Nikolova (3):
      RDMA/nes: Change MDIO bus clock to 2.5MHz
      RDMA/nes: Make unnecessarily global nes_set_pau() static
      RDMA/nes: Fix terminate during AE

 drivers/infiniband/core/cm_msgs.h       |    1 +
 drivers/infiniband/core/cma.c           |    6 ++--
 drivers/infiniband/core/ucm.c           |    3 --
 drivers/infiniband/core/uverbs_cmd.c    |   27 ++++++++++++++-----
 drivers/infiniband/hw/mlx4/ah.c         |    2 +-
 drivers/infiniband/hw/mlx4/cq.c         |    6 +++-
 drivers/infiniband/hw/mlx4/qp.c         |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c      |    1 +
 drivers/infiniband/hw/nes/nes_hw.c      |    6 +---
 drivers/infiniband/hw/nes/nes_utils.c   |    2 +-
 drivers/infiniband/hw/qib/qib_7220.h    |    2 +-
 drivers/infiniband/hw/qib/qib_driver.c  |    3 +-
 drivers/infiniband/hw/qib/qib_iba6120.c |    4 ++-
 drivers/infiniband/hw/qib/qib_iba7220.c |   10 ++++---
 drivers/infiniband/hw/qib/qib_iba7322.c |   40 ++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_init.c    |    2 +-
 drivers/infiniband/hw/qib/qib_pcie.c    |    4 +-
 drivers/infiniband/hw/qib/qib_qsfp.h    |    2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c  |    2 +-
 drivers/infiniband/hw/qib/qib_sysfs.c   |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c   |   43 +++++++++++++++++++++++-------
 include/rdma/ib_addr.h                  |    2 +-
 include/rdma/ib_cm.h                    |    3 ++
 23 files changed, 109 insertions(+), 68 deletions(-)
