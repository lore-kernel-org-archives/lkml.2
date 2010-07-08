Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0GHQM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:12:28 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27200 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0GHQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:12:27 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACaWNUyrR7Hu/2dsb2JhbACgMXGmX5p5hSUEg3k
X-IronPort-AV: E=Sophos;i="4.53,559,1272844800"; 
   d="scan'208";a="155746665"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 Jul 2010 09:12:18 -0700
Message-ID: <adapqyyymu5.fsf@roland-alpha.cisco.com>
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

This will get one security fix for IPoIB, and a bunch of relatively
small fixes to drivers new in 2.6.35 (so perhaps not regression fixes,
but not able to regress anything either ... and you don't care about
RDMA anyway ;)

Dave Olson (1):
      IB/qib: Don't mark VL15 bufs as WC to avoid a rare 7322 chip problem

FUJITA Tomonori (1):
      RDMA/cxgb4: Use the DMA state API instead of the pci equivalents

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Ralph Campbell (6):
      IB/qib: Mask hardware error during link reset
      IB/qib: Clear eager buffer memory for each new process
      IB/qib: Clear 6120 hardware error register
      IB/qib: Update 7322 serdes tables
      IB/qib: Completion queue callback needs to be single threaded
      IB/qib: Clean up properly if qib_init() fails

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Don't call abort_connection() for active connect failures
      RDMA/cxgb4: Avoid false GTS CIDX_INC overflows
      RDMA/cxgb4: Derive smac_idx from port viid

 drivers/infiniband/hw/cxgb4/cm.c          |   12 ++++---
 drivers/infiniband/hw/cxgb4/cq.c          |   31 ++++++++++++++-----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c         |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c          |   12 +++---
 drivers/infiniband/hw/cxgb4/t4.h          |    6 ++--
 drivers/infiniband/hw/qib/qib.h           |    1 +
 drivers/infiniband/hw/qib/qib_7322_regs.h |   48 ++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_diag.c      |   19 +++++++++--
 drivers/infiniband/hw/qib/qib_iba6120.c   |    3 +-
 drivers/infiniband/hw/qib/qib_iba7322.c   |   43 +++++++++++++++++++++----
 drivers/infiniband/hw/qib/qib_init.c      |   21 ++++++++++++-
 drivers/infiniband/hw/qib/qib_pcie.c      |    2 +
 drivers/infiniband/hw/qib/qib_tx.c        |    6 +++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 +-
 15 files changed, 148 insertions(+), 66 deletions(-)

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
