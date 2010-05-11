Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0EKSzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:55:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:7130 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab0EKSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,209,1272870000"; 
   d="scan'208";a="797495148"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/2] ioatdma: ring buffer management updates
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       netdev@vger.kernel.org
Date: Tue, 11 May 2010 11:51:30 -0700
Message-ID: <20100511184949.6139.96826.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches targeted at the next merge window affecting the ioatdma
driver (used when NET_DMA and/or ASYNC_TX_DMA+MD_RAID456 are enabled).
According to perf the split locking update improves cpu utilization by a
few percentage points.

---

Dan Williams (2):
      ioat2,3: convert to producer/consumer locking
      ioat: convert to circ_buf


 drivers/dma/ioat/dma.h    |    1 
 drivers/dma/ioat/dma_v2.c |  184 +++++++++++++++++++++++----------------------
 drivers/dma/ioat/dma_v2.h |   33 +++-----
 drivers/dma/ioat/dma_v3.c |  117 +++++++++--------------------
 4 files changed, 142 insertions(+), 193 deletions(-)

