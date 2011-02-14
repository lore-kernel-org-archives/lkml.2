Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1BNLit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:38:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:38933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1BNLiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:38:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,468,1291622400"; 
   d="scan'208";a="657455696"
Subject: [PATCH] dmaengine: add slave-dma maintainer
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Date: Mon, 14 Feb 2011 03:58:43 -0800
Message-ID: <20110214115523.25875.45143.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slave-dma has become the predominant usage model for dmaengine and needs
special attention.  Memory-to-memory dma usage cases will continue to be
maintained by Dan.

Cc: Alan Cox <alan@linux.intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Several factors have contributed to the need to add a co-maintainer
to dmaengine.  First my time is being consumed in other areas [1].
Also, after Russell's review of amba-pl08x it became clear that the
semantics of the slave interface need to specified [2].  My work on the
iop-adma and ioatdma drivers has been limited to the memory-to-memory
use cases (NET_DMA and ASYNC_TX_DMA).  Without direct slave-dma api
experience (client driver or dma driver) it is difficult to parse its
needs outside of its base similarities with the memory-to-memory case.

I have asked my colleague, Vinod Koul, to:
1/ put more definition around the slave api and usages to try to ensure 
consistent behavior across drivers (as much as possible)
2/ help review and merge new drivers according to this definition

Vinod wrote the intel_mid_dma driver and expects to be involved with
slave-dma for the foreseeable future.

I will continue to maintain the memory-to-memory and related async_tx 
usages of dmaengine (that need fixing [3]), but it is clear that this
usage has become a secondary role for the dmaengine infrastructure.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=129703780424729&w=2
[2]: http://marc.info/?l=linux-arm-kernel&m=129383280413633&w=2
[3]: http://marc.info/?l=linux-arm-kernel&m=129407269402930&w=2


 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55592f8..e2f0992 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2124,6 +2124,7 @@ S:	Supported
 F:	fs/dlm/
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
+M:	Vinod Koul <vinod.koul@intel.com>
 M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/

