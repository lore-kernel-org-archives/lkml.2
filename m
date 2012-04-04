Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2DDXJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:09:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:14100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab2DDXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149753767"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 0/3] Series short description
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net
Date: Wed, 04 Apr 2012 16:10:30 -0700
Message-ID: <20120404230749.20605.7000.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series address issues with the ioatdma driver. The first
patch fixes a potential ring size overflow. The next two patches put
in alignment requirement for silicon errata on the ioatdma hardware related to
M2M ops and impacts NETDMA. The last patch will probably need to be
ack'd by David Miller as it touches the network subsystem.
---

Dave Jiang (3):
      netdma: adding alignment check for NETDMA ops
      ioatdma: DMA copy alignment needed to address IOAT DMA silicon errata
      ioat: ring size variables need to be 32bit to avoid overflow


 drivers/dma/dmaengine.c   |   14 ++++++++++++++
 drivers/dma/ioat/dma_v2.c |    4 ++--
 drivers/dma/ioat/dma_v2.h |    4 ++--
 drivers/dma/ioat/dma_v3.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    1 +
 net/ipv4/tcp.c            |    4 ++--
 net/ipv4/tcp_input.c      |    2 +-
 net/ipv4/tcp_ipv4.c       |    2 +-
 net/ipv6/tcp_ipv6.c       |    2 +-
 9 files changed, 65 insertions(+), 9 deletions(-)

-- 
