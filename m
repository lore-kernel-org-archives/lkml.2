Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1AKSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:38:53 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50623 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab1AKSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:38:50 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJMyLE2rRN+K/2dsb2JhbACkOXOjZphuhUwEhGiGJg
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 11 Jan 2011 10:38:47 -0800
Message-ID: <adawrmb5lqg.fsf@cisco.com>
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

This will get the main batch of InfiniBand/RDMA patches for the merge
window.  There are three main things here:

 - SRP initiator performance improvements from Bart Van Assche and
   Dave Dillow
 - Conversion of IPoIB from LRO to GRO from Or Gerlitz
 - Lots of fixes to hardware drivers, including mostly clearing the
   backlog of qib patches

Ali Ayoub (1):
      mlx4_core: Avoid vunmap() of invalid pointer if allocation fails

Bart Van Assche (6):
      IB/srp: consolidate state change code
      IB/srp: allow lockless work posting
      IB/srp: don't move active requests to their own list
      IB/srp: reduce local coverage for command submission and EH
      IB/srp: reduce lock coverage of command completion
      IB/srp: stop sharing the host lock with SCSI

Dan Carpenter (2):
      IB/mlx4: Handle -ENOMEM in forward_trap()
      IB/mthca: Handle -ENOMEM in forward_trap()

David Dillow (2):
      IB/srp: allow task management without a previous request
      IB/srp: consolidate hot-path variables into cache lines

Joe Perches (2):
      IB/ipath: Use printf extension %pR for struct resource
      RDMA/nes: Fix string continuation line

Mike Marciniszyn (23):
      IB/qib: Remove IB latency turnoff
      IB/qib: Add receive header queue size module parameters
      IB/qib: Add support for the new QME7362 card
      IB/qib: Generate completion callback on errors
      IB/qib: Set port physical state even if other fields are invalid
      IB/qib: UD send with immediate receive completion has wrong size
      IB/qib: Handle transitions from ACTIVE_DEFERRED to ACTIVE better
      IB/qib: Fix multi-Florida HCA host panic on reboot
      IB/qib: Fix context allocation with multiple HCAs
      IB/qib: Clear WAIT_SEND flags when setting QP to error state
      IB/qib: New SERDES init routine and improvements to SI quality
      IB/qib: Reset packet list after freeing
      IB/qib: Add a few new SERDES tunings
      IB/qib: Avoid duplicate writes to the rcv head register
      IB/qib: Fix interrupt mitigation
      IB/qib: Change receive queue/QPN selection
      IB/qib: Add fix missing from earlier patch
      IB/qib: Change QPN increment
      IB/qib: RDMA lkey/rkey validation is inefficient for large MRs
      IB/qib: Issue pre-emptive NAKs on eager buffer overflow
      IB/qib: Unnecessary delayed completions on RC connection
      IB/qib: Improve SERDES tunning on QMH boards
      IB/qib: Fix refcount leak in lkey/rkey validation

Or Gerlitz (2):
      IPoIB: Remove LRO support
      IPoIB: Add GRO support

Roland Dreier (2):
      mlx4_core: Remove warning message about firmware bug
      Merge branches 'cxgb4', 'ipath', 'ipoib', 'mlx4', 'mthca', 'nes', 'qib' and 'srp' into for-next

Stephen Hemminger (1):
      RDMA/cxgb3,cxgb4: Remove dead code

Steve Wise (1):
      RDMA/cxgb4: Don't re-init wait object in init/fini paths

Vladimir Sokolovsky (1):
      IB/mlx4: Don't call dma_free_coherent() with irqs disabled

 drivers/infiniband/hw/cxgb3/cxio_hal.c       |    2 +
 drivers/infiniband/hw/cxgb3/iwch_provider.h  |    2 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |   56 ----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 -
 drivers/infiniband/hw/cxgb4/qp.c             |   32 --
 drivers/infiniband/hw/ipath/ipath_driver.c   |    5 +-
 drivers/infiniband/hw/mlx4/cq.c              |    9 +-
 drivers/infiniband/hw/mlx4/mad.c             |    2 +
 drivers/infiniband/hw/mthca/mthca_mad.c      |    2 +
 drivers/infiniband/hw/nes/nes_nic.c          |    4 +-
 drivers/infiniband/hw/qib/qib.h              |    2 +-
 drivers/infiniband/hw/qib/qib_cq.c           |    3 +-
 drivers/infiniband/hw/qib/qib_driver.c       |  155 ++++++++++-
 drivers/infiniband/hw/qib/qib_file_ops.c     |   10 +-
 drivers/infiniband/hw/qib/qib_iba6120.c      |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c      |    4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c      |  373 ++++++++++++++++++++++---
 drivers/infiniband/hw/qib/qib_init.c         |    6 +-
 drivers/infiniband/hw/qib/qib_intr.c         |    3 +-
 drivers/infiniband/hw/qib/qib_keys.c         |   80 ++++--
 drivers/infiniband/hw/qib/qib_mad.c          |   45 ++--
 drivers/infiniband/hw/qib/qib_mr.c           |    8 +-
 drivers/infiniband/hw/qib/qib_qp.c           |   32 +--
 drivers/infiniband/hw/qib/qib_rc.c           |   24 ++
 drivers/infiniband/hw/qib/qib_ud.c           |   57 ++--
 drivers/infiniband/hw/qib/qib_user_sdma.c    |    1 +
 drivers/infiniband/hw/qib/qib_verbs.h        |   11 +-
 drivers/infiniband/ulp/ipoib/Kconfig         |    1 -
 drivers/infiniband/ulp/ipoib/ipoib.h         |   12 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   51 ----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   62 +----
 drivers/infiniband/ulp/srp/ib_srp.c          |  392 ++++++++++++--------------
 drivers/infiniband/ulp/srp/ib_srp.h          |   46 ++--
 drivers/net/mlx4/alloc.c                     |    3 +-
 drivers/net/mlx4/fw.c                        |    4 +-
 37 files changed, 889 insertions(+), 622 deletions(-)
