Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032264Ab2CSRL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:11:29 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:34978 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758278Ab2CSRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:11:27 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 19 Mar 2012 10:11:19 -0700
Message-Id: <1332177079-14339-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git rdma-for-linus

----------------------------------------------------------------

InfiniBand/RDMA changes for the 3.4 merge window.  Nothing big really
stands out; by patch count lots of fixes to the mlx4 driver plus some
cleanups and fixes to the core and other drivers.

----------------------------------------------------------------
Bart Van Assche (2):
      IB/srp: Use pr_fmt() and pr_err()/pr_warn()
      IB/srp: Consolidate repetitive sysfs code

Doug Ledford (1):
      IB/iser: Free IB connection resources in the proper place

Eli Cohen (3):
      IB/mlx4: Set bad_wr for invalid send opcode
      mlx4: Enforce device max FMR maps in FMR alloc
      IB/mlx4: Fix possible missed completion event

Eric Dumazet (1):
      IB/ehca: Use kthread_create_on_node()

Hefty, Sean (1):
      RDMA/ucma: Fix AB-BA deadlock

Jack Morgenstein (1):
      mlx4_core: Report thermal error events

Kumar Sanghvi (1):
      RDMA/cxgb4: Add missing peer2peer check in MPAv2 code

Kyle McMartin (1):
      IB/ehca: Fix ilog2() compile failure

Masanari Iida (1):
      IB/srpt: Fix typo "alocate" -> "allocate"

Mike Marciniszyn (2):
      IB/qib: Add logic for affinity hint
      IB/qib: Avoid filtering LID on SMA portinfo

Or Gerlitz (6):
      IB/iser: Post initial receive buffers before sending the final login request
      IB: Use central enum for speed instead of hard-coded values
      mlx4_core: Get rid of redundant ext_port_cap flags
      IB: Change CQE "csum_ok" field to a bit flag
      IB/mlx4: Fix info returned when querying IBoE ports
      mlx4_core: Allow dynamic MTU configuration for IB ports

Roland Dreier (5):
      IB/core: Fix SDR rates in sysfs
      mlx4_core: Fix one more static exported function
      mlx4_core: Scale size of MTT table with system RAM
      Merge branches 'misc' and 'mlx4' into for-next
      Merge branches 'cma', 'cxgb3', 'cxgb4', 'ehca', 'iser', 'mad', 'nes', 'qib', 'srp' and 'srpt' into for-next

Steve Wise (2):
      RDMA/cxgb3: Don't pass irq flags to flush_qp()
      RDMA/iwcm: Reject connect requests if cmid is not in LISTEN state

Swapna Thete (2):
      IB/mad: Add MAD error codes from IBA spec
      IB/mad: Return error response for unsupported MADs

Tatyana Nikolova (1):
      RDMA/nes: Fixes for sparse endianness warnings

 drivers/infiniband/core/iwcm.c               |   24 +++--
 drivers/infiniband/core/mad.c                |   21 ++++
 drivers/infiniband/core/sysfs.c              |   27 +++---
 drivers/infiniband/core/ucma.c               |   37 ++++----
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |   40 ++++----
 drivers/infiniband/hw/cxgb4/cm.c             |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +-
 drivers/infiniband/hw/ehca/ehca_irq.c        |    3 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 +-
 drivers/infiniband/hw/mlx4/cq.c              |    6 +-
 drivers/infiniband/hw/mlx4/main.c            |  130 +++++++++++++------------
 drivers/infiniband/hw/mlx4/qp.c              |    1 +
 drivers/infiniband/hw/mthca/mthca_cq.c       |    3 +-
 drivers/infiniband/hw/nes/nes_cm.c           |   39 +++++----
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 drivers/infiniband/hw/qib/qib.h              |   10 ++-
 drivers/infiniband/hw/qib/qib_iba7322.c      |  107 +++++++++++++++------
 drivers/infiniband/hw/qib/qib_mad.c          |    4 +-
 drivers/infiniband/hw/qib/qib_pcie.c         |   21 ++++-
 drivers/infiniband/hw/qib/qib_rc.c           |    1 -
 drivers/infiniband/hw/qib/qib_uc.c           |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    3 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   18 +---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |   42 ++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   12 +++
 drivers/infiniband/ulp/srp/ib_srp.c          |  103 +++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.c        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c      |   32 ++++++-
 drivers/net/ethernet/mellanox/mlx4/main.c    |  126 +++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    9 ++-
 drivers/net/ethernet/mellanox/mlx4/mr.c      |    3 +
 drivers/net/ethernet/mellanox/mlx4/port.c    |   68 +++++---------
 drivers/net/ethernet/mellanox/mlx4/profile.c |   19 ++++
 include/linux/mlx4/device.h                  |   12 ++-
 include/rdma/ib_mad.h                        |    9 ++
 include/rdma/ib_verbs.h                      |   11 ++-
 40 files changed, 607 insertions(+), 352 deletions(-)
