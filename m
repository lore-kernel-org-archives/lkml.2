Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0DLDwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 23:52:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:10295 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab0DLDwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 23:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,187,1270450800"; 
   d="scan'208";a="612166021"
Subject: [PATCH] ioatdma:  Remove duplicated devm_kzalloc() calls for
 ioatdma_device
From: minskey <chaohong_guo@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 11:40:15 +0800
Message-ID: <1271043615.4957.11.camel@minskey-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory for ioatdma_device structure is being allocated in
alloc_ioatdma()

Signed-off-by: Minskey Guo <chaohong_guo@linux.intel.com>

---
 drivers/dma/ioat/pci.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 99ec267..a6e93ee 100644  
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -138,10 +138,6 @@ static int __devinit ioat_pci_probe(struct pci_dev
*pdev, const struct pci_devic
        if (err)
                return err;

-       device = devm_kzalloc(dev, sizeof(*device), GFP_KERNEL);
-       if (!device)
-               return -ENOMEM; 
-   
        pci_set_master(pdev);
    
        device = alloc_ioatdma(pdev, iomap[IOAT_MMIO_BAR]);
--  
1.6.3.3 


