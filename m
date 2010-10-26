Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0JZXSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:18:13 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:46761 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab0JZXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:18:10 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP/+xkyrR7Hu/2dsb2JhbAChVXGkPZwwhUgEhFeFfA
X-IronPort-AV: E=Sophos;i="4.58,243,1286150400"; 
   d="scan'208";a="276276334"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull infiniband.git
References: <ada4oc8fzi9.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 26 Oct 2010 16:17:56 -0700
In-Reply-To: <ada4oc8fzi9.fsf@cisco.com> (Roland Dreier's message of "Tue, 26
	Oct 2010 13:52:14 -0700")
Message-ID: <adasjzsczmj.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A) I forgot to push out my for-linus branch, so if you tried earlier, it
wasn't there, but it is now:

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

B) It was pointed out to me that I missed one patch hunk, so the
diffstat now looks like the below.  One difference is that there now is
a qib_uc.c line and the summary goes from

 74 files changed, 2668 insertions(+), 725 deletions(-)

to

 75 files changed, 2672 insertions(+), 727 deletions(-)

Thanks!
  Roland

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
 drivers/infiniband/hw/qib/qib_uc.c          |    6 +-
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
 75 files changed, 2672 insertions(+), 727 deletions(-)
