Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2KPX0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:26:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:29873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab2KPX0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:26:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="243518427"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] ioat: remove chanerr mask setting for IOAT v3.x
To: djbw@fb.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 16:26:39 -0700
Message-ID: <20121116232638.1766.86886.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CHANERRMSK_INT register should be 0. The existing code set a value
for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
has been fixed when the hardware was released. There is no need for this
code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/dma/ioat/dma_v3.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f7f1dc6..60c15c4 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1126,12 +1126,8 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 	writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
 
-	/* -= IOAT ver.3 workarounds =- */
-	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
-	 * that can cause stability issues for IOAT ver.3, and clear any
-	 * pending errors
-	 */
-	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
+	/* clearn CHANERRMASK_INT and clear any pending errors */
+	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0);
 	err = pci_read_config_dword(pdev, IOAT_PCI_CHANERR_INT_OFFSET, &chanerr);
 	if (err) {
 		dev_err(&pdev->dev, "channel error register unreachable\n");

