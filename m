Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab0JZUxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:53:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15448 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760472Ab0JZUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:53:03 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAE/cxkyrR7Ht/2dsb2JhbACbf4VUcaVwnC6FSASEV4V8
X-IronPort-AV: E=Sophos;i="4.58,242,1286150400"; 
   d="scan'208";a="610090513"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 26 Oct 2010 13:52:14 -0700
Message-ID: <ada4oc8fzi9.fsf@cisco.com>
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

The big new feature here is support for InfiniBand-over-Ethernet / IBoE
(aka "RDMA over Converged Ethernet / RoCE").  We also have a new SRP
initiator submaintainer (thanks Dave!), and various fixes all over.

Animesh K Trivedi (1):
      RDMA/iwcm: Fix hang in uninterruptible wait on cm_id destroy

Bart Van Assche (3):
      IB/srp: Preparation for transmit ring response allocation
      IB/srp: Reduce number of BUSY conditions
      IB/srp: Use list_first_entry()

Chien Tung (1):
      RDMA/nes: Report correct port state if interface is down

Christoph Lameter (1):
      IPoIB: Set pkt_type correctly for multicast packets (fix IGMP breakage)

Dan Carpenter (1):
      RDMA/nes: Remove unneeded variable

David Dillow (3):
      IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
      IB/srp: Eliminate two forward declarations
      IB/srp: Sync buffer before posting send

Eli Cohen (16):
      IB/core: Add link layer property to ports
      mlx4_core: Allow log_mtts_per_seg up to 7
      IB/mlx4: Limit size of fast registration WRs
      IPoIB: Skip IBoE ports
      IB/mad: IBoE supports only QP1 (no QP0)
      RDMA/cm: Add RDMA CM support for IBoE devices
      IB/pack: IBoE UD packet packing support
      IPoIB: Set dev_id field of net_device
      IB/uverbs: Return link layer type to userspace for query port operation
      mlx4_core: Allow protocol drivers to find corresponding interfaces
      mlx4_core: Update data structures and constants for IBoE
      mlx4_en: Change multicast promiscuous mode to support IBoE
      IB/mlx4: Add support for IBoE
      IB/core: Add VLAN support for IBoE
      IB/mlx4: Add VLAN support for IBoE
      IB/core: Add link layer type information to sysfs

Jack Morgenstein (1):
      IB/mlx4: Signal node desc changes to SM by using FW to generate trap 144

Jason Gunthorpe (3):
      IB/qib: Process RDMA WRITE ONLY with IMMEDIATE properly
      IB/qib: Fix extra log level in qib_early_err()
      IB/qib: clean up properly if pci_set_consistent_dma_mask() fails

Joe Perches (4):
      RDMA/amso1100: Remove KERN_<level> from pr_<level> use
      IB/qib: Remove unnecessary casts of private_data
      RDMA/cxgb3: Remove unnecessary KERN_<level> use
      RDMA/cxgb4: Remove unnecessary KERN_<level> use

Maciej Sosnowski (1):
      RDMA/nes: Turn carrier off on ifdown

Ralph Campbell (2):
      IB/qib: Fix uninitialized pointer if CONFIG_PCI_MSI not set
      IB/qib: Allow driver to load if PCIe AER fails

Roland Dreier (5):
      RDMA/cxgb4: Fix warnings about casts to/from pointers of different sizes
      MAINTAINERS: Fix broken link to http://www.openib.org/
      RDMA/nes: Fix cast-to-pointer warnings on 32-bit
      MAINTAINERS: Hand off SCSI RDMA Protocol (SRP) initiator to Dave Dillow
      Merge branches 'amso1100', 'cma', 'cxgb3', 'cxgb4', 'ehca', 'iboe', 'ipoib', 'misc', 'mlx4', 'nes', 'qib' and 'srp' into for-next

Sonny Rao (1):
      IB/ehca: Fix driver on relocatable kernel

Steve Wise (19):
      RDMA/cxgb4: Don't use null ep ptr
      RDMA/cxgb4: Zero out ISGL padding
      RDMA/cxgb4: Ignore positive return values from cxgb4_*_send() functions
      RDMA/cxgb4: Ignore TERMINATE CQEs
      RDMA/cxgb4: Handle CPL_RDMA_TERMINATE messages
      RDMA/cxgb4: Log HW lack-of-resource errors
      RDMA/cxgb4: debugfs files for dumping active stags
      RDMA/cxgb4: Centralize the wait logic
      RDMA/cxgb4: Support on-chip SQs
      RDMA/cxgb4: Use a mutex for QP and EP state transitions
      RDMA/cxgb4: Set the default TCP send window to 128KB
      RDMA/cxgb4: Don't set completion flag for read requests
      RDMA/cxgb4: Fastreg NSMR fixes
      RDMA/cxgb4: Add default_llseek to debugfs files
      RDMA/cxgb4: Use simple_read_from_buffer() for debugfs handlers
      RDMA/cxgb4: Export T4 TCP MIB
      RDMA/cxgb4: Use cxgb4 service for packet gl to skb
      RDMA/cxgb3: When a user QP is marked in error, also mark the CQs in error
      RDMA/ucma: Allow tuning the max listen backlog

Thomas Gleixner (1):
      IB/umad: Make user_mad semaphore a real one

matt mooney (1):
      IB: Replace EXTRA_CFLAGS with ccflags-y

 MAINTAINERS                                 |   12 +-
 drivers/infiniband/core/agent.c             |   29 +-
 drivers/infiniband/core/cma.c               |  313 ++++++++++++++-
 drivers/infiniband/core/iwcm.c              |    4 +
 drivers/infiniband/core/mad.c               |   27 ++-
 drivers/infiniband/core/multicast.c         |   23 +-
 drivers/infiniband/core/sa_query.c          |   30 +-
 drivers/infiniband/core/sysfs.c             |   15 +
 drivers/infiniband/core/ucma.c              |   92 ++++-
 drivers/infiniband/core/ud_header.c         |  138 ++++++--
 drivers/infiniband/core/user_mad.c          |    2 +-
 drivers/infiniband/core/uverbs_cmd.c        |    2 +
 drivers/infiniband/core/verbs.c             |   16 +
 drivers/infiniband/hw/amso1100/Kbuild       |    4 +-
 drivers/infiniband/hw/amso1100/c2_intr.c    |    4 +-
 drivers/infiniband/hw/cxgb3/Makefile        |    6 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c      |    1 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h       |   16 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_ev.c       |   17 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   24 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |   25 +-
 drivers/infiniband/hw/cxgb3/iwch_user.h     |    8 +
 drivers/infiniband/hw/cxgb4/Makefile        |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c            |  178 ++++-----
 drivers/infiniband/hw/cxgb4/cq.c            |   28 +-
 drivers/infiniband/hw/cxgb4/device.c        |  191 ++++++----
 drivers/infiniband/hw/cxgb4/ev.c            |    2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   68 +++-
 drivers/infiniband/hw/cxgb4/mem.c           |   11 +-
 drivers/infiniband/hw/cxgb4/provider.c      |   44 ++-
 drivers/infiniband/hw/cxgb4/qp.c            |  283 ++++++++------
 drivers/infiniband/hw/cxgb4/resource.c      |   62 +++
 drivers/infiniband/hw/cxgb4/t4.h            |   44 ++-
 drivers/infiniband/hw/cxgb4/user.h          |    7 +
 drivers/infiniband/hw/ehca/ehca_mrmw.c      |    6 +-
 drivers/infiniband/hw/ipath/Makefile        |    2 +-
 drivers/infiniband/hw/mlx4/ah.c             |  163 +++++++--
 drivers/infiniband/hw/mlx4/mad.c            |   32 +-
 drivers/infiniband/hw/mlx4/main.c           |  553 +++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |   32 ++-
 drivers/infiniband/hw/mlx4/mr.c             |    2 +-
 drivers/infiniband/hw/mlx4/qp.c             |  195 ++++++++--
 drivers/infiniband/hw/mthca/mthca_qp.c      |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c          |    3 +-
 drivers/infiniband/hw/nes/nes_nic.c         |    1 +
 drivers/infiniband/hw/nes/nes_verbs.c       |   16 +-
 drivers/infiniband/hw/qib/qib.h             |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c    |    4 +-
 drivers/infiniband/hw/qib/qib_init.c        |    1 +
 drivers/infiniband/hw/qib/qib_pcie.c        |    8 +-
 drivers/infiniband/hw/qib/qib_rc.c          |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c     |   14 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |    3 +
 drivers/infiniband/ulp/srp/ib_srp.c         |  236 ++++++++----
 drivers/infiniband/ulp/srp/ib_srp.h         |   21 +-
 drivers/net/mlx4/en_main.c                  |   15 +-
 drivers/net/mlx4/en_netdev.c                |   10 +
 drivers/net/mlx4/en_port.c                  |    4 +-
 drivers/net/mlx4/en_port.h                  |    3 +-
 drivers/net/mlx4/fw.c                       |    3 +-
 drivers/net/mlx4/intf.c                     |   21 +
 drivers/net/mlx4/main.c                     |    4 +-
 drivers/net/mlx4/mlx4_en.h                  |    1 +
 drivers/net/mlx4/port.c                     |   19 +
 include/linux/mlx4/cmd.h                    |    2 +
 include/linux/mlx4/device.h                 |   35 ++-
 include/linux/mlx4/driver.h                 |    9 +
 include/linux/mlx4/qp.h                     |    9 +-
 include/rdma/ib_addr.h                      |  134 +++++++-
 include/rdma/ib_pack.h                      |   39 ++-
 include/rdma/ib_user_verbs.h                |    3 +-
 include/rdma/ib_verbs.h                     |   11 +
 include/scsi/srp.h                          |   38 ++
 74 files changed, 2668 insertions(+), 725 deletions(-)
