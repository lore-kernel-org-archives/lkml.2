Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2K0WQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:16:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:26846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2K0WQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:16:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,174,1355126400"; 
   d="scan'208";a="248103640"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v2] ioat: remove chanerr mask setting for IOAT v3.x
To: djbw@fb.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, jon.mason@intel.com
Date: Tue, 27 Nov 2012 15:16:08 -0700
Message-ID: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing code set a value in the PCI_CHANERRMSK_INT register
for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
has been fixed when the hardware was released. There is no need for this
code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/dma/ioat/dma_v3.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f7f1dc6..fda3b8a1 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1126,12 +1126,7 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 	writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
 
-	/* -= IOAT ver.3 workarounds =- */
-	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
-	 * that can cause stability issues for IOAT ver.3, and clear any
-	 * pending errors
-	 */
-	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
+	/* clear any pending errors */
 	err = pci_read_config_dword(pdev, IOAT_PCI_CHANERR_INT_OFFSET, &chanerr);
 	if (err) {
 		dev_err(&pdev->dev, "channel error register unreachable\n");

