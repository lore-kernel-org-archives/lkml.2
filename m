Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AQVza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:55:30 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27184 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1AQVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:55:28 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPpJNE2rR7H+/2dsb2JhbACkVXOoG5k2hVAEhG+GLw
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 17 Jan 2011 13:55:24 -0800
Message-ID: <adaei8byz3n.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the last batch of InfiniBand/RDMA patches for the merge
window.  The biggest thing here is Tejun's conversion of the RDMA
stack away from flush_scheduled_work(); the remaining stuff is mostly
driver fixes, with an SRP compile warning fix and a vzalloc()
conversion patch thrown in.

Aleksey Senin (1):
      IB/mlx4: Handle protocol field in multicast table

Bart Van Assche (1):
      IB/srp: Test only once whether iu allocation succeeded

Joe Perches (1):
      RDMA: Use vzalloc() to replace vmalloc()+memset(0)

John L. Burr (1):
      IB/mthca: Fix driver when sizeof (phys_addr_t) > sizeof (long)

Maciej Sosnowski (4):
      RDMA/nes: Fix bonding on iw_nes
      RDMA/nes: Generate IB_EVENT_PORT_ERR/PORT_ACTIVE events
      RDMA/nes: Fix SFP+ link down detection issue with switch port disable
      RDMA/nes: Fix incorrect SFP+ link status detection on driver init

Roland Dreier (2):
      mlx4_{core, ib, en}: Fix driver when sizeof (phys_addr_t) > sizeof (long)
      Merge branches 'misc', 'mlx4', 'mthca', 'nes' and 'srp' into for-next

Tejun Heo (1):
      RDMA: Update workqueue usage

 drivers/infiniband/core/cache.c                |    4 +-
 drivers/infiniband/core/device.c               |   11 ++-
 drivers/infiniband/core/sa_query.c             |    2 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c       |    5 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c         |    5 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |    5 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |   11 +--
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |    5 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    2 +-
 drivers/infiniband/hw/mlx4/main.c              |   12 ++-
 drivers/infiniband/hw/mthca/mthca_catas.c      |    5 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_mr.c         |    2 +-
 drivers/infiniband/hw/nes/nes.c                |   35 ++++++++-
 drivers/infiniband/hw/nes/nes.h                |    4 +
 drivers/infiniband/hw/nes/nes_cm.c             |    8 ++-
 drivers/infiniband/hw/nes/nes_hw.c             |   95 ++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_hw.h             |   10 +++
 drivers/infiniband/hw/nes/nes_nic.c            |   78 ++++++++++++++++---
 drivers/infiniband/hw/nes/nes_verbs.c          |   37 +++++++++-
 drivers/infiniband/hw/qib/qib_iba7220.c        |    7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c        |   14 ++--
 drivers/infiniband/hw/qib/qib_init.c           |   33 ++-------
 drivers/infiniband/hw/qib/qib_qsfp.c           |    9 +-
 drivers/infiniband/hw/qib/qib_verbs.h          |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   10 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    3 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   19 ++---
 drivers/net/mlx4/catas.c                       |    6 +-
 drivers/net/mlx4/en_main.c                     |    3 +-
 drivers/net/mlx4/main.c                        |    2 +-
 drivers/net/mlx4/mcg.c                         |   23 +++---
 include/linux/mlx4/device.h                    |   10 ++-
 include/linux/mlx4/driver.h                    |    6 +-
 include/rdma/ib_verbs.h                        |    3 +
 38 files changed, 351 insertions(+), 144 deletions(-)
