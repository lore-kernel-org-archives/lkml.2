Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2JECU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 22:20:29 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:48733 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756252Ab2JECU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 22:20:27 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  4 Oct 2012 19:20:20 -0700
Message-Id: <1349403620-31433-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Second batch of changes for the 3.7 merge window:
 - Late-breaking fix for IPoIB on mlx4 SR-IOV VFs.
 - Fix for IPoIB build breakage with CONFIG_INFINIBAND_IPOIB_CM=n
   (new netlink config changes are to blame).
 - Make sure retry count values are in range in RDMA CM.
 - A few nes hardware driver fixes and cleanups.
 - Have iSER initiator use >1 interrupt vectors if available.

----------------------------------------------------------------
Alex Tabachnik (1):
      IB/iser: Add more RX CQs to scale out processing of SCSI responses

Jack Morgenstein (1):
      mlx4_core: Adjust flow steering attach wrapper so that IB works on SR-IOV VFs

Roland Dreier (2):
      IPoIB: Fix build with CONFIG_INFINIBAND_IPOIB_CM=n
      Merge branches 'cma', 'ipoib', 'iser', 'mlx4' and 'nes' into for-next

Sean Hefty (1):
      RDMA/cma: Check that retry count values are in range

Tatyana Nikolova (4):
      RDMA/nes: Add missing break to switch.
      RDMA/nes: Remove unnecessary if-else statement
      RDMA/nes: Remove unused module parameter "send_first"
      RDMA/nes: Bump the version number of nes driver

 drivers/infiniband/core/cma.c                      |    6 +-
 drivers/infiniband/hw/nes/nes.c                    |    5 -
 drivers/infiniband/hw/nes/nes.h                    |    3 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   16 +--
 drivers/infiniband/ulp/ipoib/ipoib.h               |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   31 -----
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   31 +++++
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   17 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  130 ++++++++++++++------
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    2 +
 10 files changed, 146 insertions(+), 99 deletions(-)
