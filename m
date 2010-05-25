Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0EYQ6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:58:36 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:41150 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab0EYQ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:58:32 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHee+0urR7Ht/2dsb2JhbACeBnGmeZl+hRMEg0I
X-IronPort-AV: E=Sophos;i="4.53,299,1272844800"; 
   d="scan'208";a="223940587"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 25 May 2010 09:58:28 -0700
Message-ID: <ada632bzznv.fsf@roland-alpha.cisco.com>
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

The biggest thing here is the rather huge new qib driver for QLogic
PCIe adapters.  This is pretty much self-contained (just one small
change to the core to allow low-level drivers to create per-port files
in sysfs).  There are also some fixes to the new iw_cxgb4 driver, as
well as a few other miscellaneous fixes.

Chien Tung (1):
      RDMA/nes: Fix incorrect unlock in nes_process_mac_intr()

Faisal Latif (2):
      RDMA/nes: Have ethtool read hardware registers for rx/tx stats
      RDMA/nes: Async event for closed QP causes crash

Ralph Campbell (3):
      IB/core: Allow device-specific per-port sysfs files
      IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters
      IB/ipath: Remove support for QLogic PCIe QLE devices

Roland Dreier (3):
      mlx4_core: Clean up mlx4_alloc_icm() a bit
      IB/mad: Make needlessly global mad_sendq_size/mad_recvq_size static
      Merge branches 'cxgb4', 'misc', 'mlx4', 'nes' and 'qib' into for-next

Sebastien Dugue (1):
      mlx4_core: Fix possible chunk sg list overflow in mlx4_alloc_icm()

Steve Wise (11):
      RDMA/cxgb4: Detach from the LLD after unregistering RDMA device
      RDMA/cxgb4: Register RDMA provider based on LLD state_change events
      RDMA/cxgb4: CQ size must be IQ size - 2
      RDMA/cxgb4: Optimize CQ overflow detection
      RDMA/cxgb4: Fix overflow bug in CQ arm
      RDMA/cxgb4: Return proper errors in fastreg mr/pbl allocation
      RDMA/cxgb4: Don't limit fastreg page list depth
      RDMA/cxgb4: Update some HW limits
      RDMA/cxgb4: Set fence flag for inv-local-stag work requests
      RDMA/cxgb4: Support IB_WR_READ_WITH_INV opcode
      RDMA/cxgb4: Only insert sq qid in lookup table

 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/Makefile                        |    1 +
 drivers/infiniband/core/core_priv.h                |    4 +-
 drivers/infiniband/core/device.c                   |    6 +-
 drivers/infiniband/core/mad.c                      |    4 +-
 drivers/infiniband/core/sysfs.c                    |   21 +-
 drivers/infiniband/hw/amso1100/c2_provider.c       |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    2 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |    6 +-
 drivers/infiniband/hw/cxgb4/device.c               |   50 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    1 +
 drivers/infiniband/hw/cxgb4/mem.c                  |   11 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |   33 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |   76 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    2 +-
 drivers/infiniband/hw/ipath/Kconfig                |    8 +-
 drivers/infiniband/hw/ipath/Makefile               |    6 +-
 drivers/infiniband/hw/ipath/ipath_driver.c         |   28 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c        | 1862 -----
 drivers/infiniband/hw/ipath/ipath_iba7220.c        | 2631 -------
 drivers/infiniband/hw/ipath/ipath_kernel.h         |    2 -
 drivers/infiniband/hw/ipath/ipath_verbs.c          |    2 +-
 drivers/infiniband/hw/mlx4/main.c                  |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |   12 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   72 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |    2 +-
 drivers/infiniband/hw/qib/Kconfig                  |    7 +
 drivers/infiniband/hw/qib/Makefile                 |   15 +
 drivers/infiniband/hw/qib/qib.h                    | 1439 ++++
 drivers/infiniband/hw/qib/qib_6120_regs.h          |  977 +++
 drivers/infiniband/hw/qib/qib_7220.h               |  156 +
 drivers/infiniband/hw/qib/qib_7220_regs.h          | 1496 ++++
 drivers/infiniband/hw/qib/qib_7322_regs.h          | 3163 ++++++++
 drivers/infiniband/hw/qib/qib_common.h             |  758 ++
 drivers/infiniband/hw/qib/qib_cq.c                 |  484 ++
 drivers/infiniband/hw/qib/qib_diag.c               |  894 +++
 drivers/infiniband/hw/qib/qib_dma.c                |  182 +
 drivers/infiniband/hw/qib/qib_driver.c             |  665 ++
 drivers/infiniband/hw/qib/qib_eeprom.c             |  451 ++
 drivers/infiniband/hw/qib/qib_file_ops.c           | 2317 ++++++
 drivers/infiniband/hw/qib/qib_fs.c                 |  613 ++
 drivers/infiniband/hw/qib/qib_iba6120.c            | 3588 +++++++++
 drivers/infiniband/hw/qib/qib_iba7220.c            | 4618 +++++++++++
 drivers/infiniband/hw/qib/qib_iba7322.c            | 8058 ++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_init.c               | 1580 ++++
 drivers/infiniband/hw/qib/qib_intr.c               |  236 +
 drivers/infiniband/hw/qib/qib_keys.c               |  328 +
 drivers/infiniband/hw/qib/qib_mad.c                | 2173 ++++++
 drivers/infiniband/hw/qib/qib_mad.h                |  373 +
 drivers/infiniband/hw/qib/qib_mmap.c               |  174 +
 drivers/infiniband/hw/qib/qib_mr.c                 |  503 ++
 drivers/infiniband/hw/qib/qib_pcie.c               |  738 ++
 .../hw/{ipath/ipath_7220.h => qib/qib_pio_copy.c}  |   53 +-
 drivers/infiniband/hw/qib/qib_qp.c                 | 1255 +++
 drivers/infiniband/hw/qib/qib_qsfp.c               |  564 ++
 drivers/infiniband/hw/qib/qib_qsfp.h               |  184 +
 drivers/infiniband/hw/qib/qib_rc.c                 | 2288 ++++++
 drivers/infiniband/hw/qib/qib_ruc.c                |  817 ++
 .../hw/{ipath/ipath_sd7220.c => qib/qib_sd7220.c}  |  859 +--
 .../ipath_sd7220_img.c => qib/qib_sd7220_img.c}    |   19 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |  973 +++
 drivers/infiniband/hw/qib/qib_srq.c                |  375 +
 drivers/infiniband/hw/qib/qib_sysfs.c              |  691 ++
 drivers/infiniband/hw/qib/qib_twsi.c               |  498 ++
 drivers/infiniband/hw/qib/qib_tx.c                 |  557 ++
 drivers/infiniband/hw/qib/qib_uc.c                 |  555 ++
 drivers/infiniband/hw/qib/qib_ud.c                 |  607 ++
 drivers/infiniband/hw/qib/qib_user_pages.c         |  157 +
 drivers/infiniband/hw/qib/qib_user_sdma.c          |  897 +++
 .../hw/{ipath/ipath_7220.h => qib/qib_user_sdma.h} |   43 +-
 drivers/infiniband/hw/qib/qib_verbs.c              | 2248 ++++++
 drivers/infiniband/hw/qib/qib_verbs.h              | 1100 +++
 drivers/infiniband/hw/qib/qib_verbs_mcast.c        |  368 +
 .../hw/{ipath/ipath_7220.h => qib/qib_wc_ppc64.c}  |   49 +-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c          |  171 +
 drivers/net/mlx4/icm.c                             |   36 +-
 include/rdma/ib_verbs.h                            |    4 +-
 79 files changed, 51016 insertions(+), 5191 deletions(-)
 delete mode 100644 drivers/infiniband/hw/ipath/ipath_iba6120.c
 delete mode 100644 drivers/infiniband/hw/ipath/ipath_iba7220.c
 create mode 100644 drivers/infiniband/hw/qib/Kconfig
 create mode 100644 drivers/infiniband/hw/qib/Makefile
 create mode 100644 drivers/infiniband/hw/qib/qib.h
 create mode 100644 drivers/infiniband/hw/qib/qib_6120_regs.h
 create mode 100644 drivers/infiniband/hw/qib/qib_7220.h
 create mode 100644 drivers/infiniband/hw/qib/qib_7220_regs.h
 create mode 100644 drivers/infiniband/hw/qib/qib_7322_regs.h
 create mode 100644 drivers/infiniband/hw/qib/qib_common.h
 create mode 100644 drivers/infiniband/hw/qib/qib_cq.c
 create mode 100644 drivers/infiniband/hw/qib/qib_diag.c
 create mode 100644 drivers/infiniband/hw/qib/qib_dma.c
 create mode 100644 drivers/infiniband/hw/qib/qib_driver.c
 create mode 100644 drivers/infiniband/hw/qib/qib_eeprom.c
 create mode 100644 drivers/infiniband/hw/qib/qib_file_ops.c
 create mode 100644 drivers/infiniband/hw/qib/qib_fs.c
 create mode 100644 drivers/infiniband/hw/qib/qib_iba6120.c
 create mode 100644 drivers/infiniband/hw/qib/qib_iba7220.c
 create mode 100644 drivers/infiniband/hw/qib/qib_iba7322.c
 create mode 100644 drivers/infiniband/hw/qib/qib_init.c
 create mode 100644 drivers/infiniband/hw/qib/qib_intr.c
 create mode 100644 drivers/infiniband/hw/qib/qib_keys.c
 create mode 100644 drivers/infiniband/hw/qib/qib_mad.c
 create mode 100644 drivers/infiniband/hw/qib/qib_mad.h
 create mode 100644 drivers/infiniband/hw/qib/qib_mmap.c
 create mode 100644 drivers/infiniband/hw/qib/qib_mr.c
 create mode 100644 drivers/infiniband/hw/qib/qib_pcie.c
 copy drivers/infiniband/hw/{ipath/ipath_7220.h => qib/qib_pio_copy.c} (57%)
 create mode 100644 drivers/infiniband/hw/qib/qib_qp.c
 create mode 100644 drivers/infiniband/hw/qib/qib_qsfp.c
 create mode 100644 drivers/infiniband/hw/qib/qib_qsfp.h
 create mode 100644 drivers/infiniband/hw/qib/qib_rc.c
 create mode 100644 drivers/infiniband/hw/qib/qib_ruc.c
 rename drivers/infiniband/hw/{ipath/ipath_sd7220.c => qib/qib_sd7220.c} (57%)
 rename drivers/infiniband/hw/{ipath/ipath_sd7220_img.c => qib/qib_sd7220_img.c} (99%)
 create mode 100644 drivers/infiniband/hw/qib/qib_sdma.c
 create mode 100644 drivers/infiniband/hw/qib/qib_srq.c
 create mode 100644 drivers/infiniband/hw/qib/qib_sysfs.c
 create mode 100644 drivers/infiniband/hw/qib/qib_twsi.c
 create mode 100644 drivers/infiniband/hw/qib/qib_tx.c
 create mode 100644 drivers/infiniband/hw/qib/qib_uc.c
 create mode 100644 drivers/infiniband/hw/qib/qib_ud.c
 create mode 100644 drivers/infiniband/hw/qib/qib_user_pages.c
 create mode 100644 drivers/infiniband/hw/qib/qib_user_sdma.c
 copy drivers/infiniband/hw/{ipath/ipath_7220.h => qib/qib_user_sdma.h} (57%)
 create mode 100644 drivers/infiniband/hw/qib/qib_verbs.c
 create mode 100644 drivers/infiniband/hw/qib/qib_verbs.h
 create mode 100644 drivers/infiniband/hw/qib/qib_verbs_mcast.c
 rename drivers/infiniband/hw/{ipath/ipath_7220.h => qib/qib_wc_ppc64.c} (57%)
 create mode 100644 drivers/infiniband/hw/qib/qib_wc_x86_64.c

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
