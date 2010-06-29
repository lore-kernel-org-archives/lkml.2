Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0F2KQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0F2KQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t5zjSfb5dmXyTlcKuI17C/4CXsUB+rUm2LfEoPF2TCJgpmWAAWxd8thLQSJ4tjyb29
         IKwnUVEcN6HKzLIu2luzoualB6+MNazhSXFjNAcCdRIlwpXDyhY+pLBMD8g2CTJIfxdB
         kVpqXjOwHs28kTsUMt+VAMuy9tlEEBP1S+GbM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Henk de Groot <pe1dnn@amsat.org>, Huang Weiyi <weiyi.huang@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/25] wl_pci: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:29 +0400
Message-Id: <1277806590-31520-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/wlags49_h2/wl_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 6751b4b..af4f4f8 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -465,7 +465,7 @@ void __devexit wl_pci_remove(struct pci_dev *pdev)
     free_irq( dev->irq, dev );
 
 #ifdef ENABLE_DMA
-    wl_pci_dma_free( pdev, (struct wl_private *)dev->priv );
+    wl_pci_dma_free( pdev, dev->priv );
 #endif
 
     wl_device_dealloc( dev );
@@ -534,7 +534,7 @@ int wl_pci_setup( struct pci_dev *pdev )
 
 #ifdef ENABLE_DMA
     /* Allocate DMA Descriptors */
-    if( wl_pci_dma_alloc( pdev, (struct wl_private *)dev->priv ) < 0 ) {
+    if( wl_pci_dma_alloc( pdev, dev->priv ) < 0 ) {
         DBG_ERROR( DbgInfo, "Could not allocate DMA descriptor memory!!!\n" );
         DBG_LEAVE( DbgInfo );
         return -ENOMEM;
@@ -570,7 +570,7 @@ int wl_pci_setup( struct pci_dev *pdev )
 	}
 
     /* Make sure interrupts are enabled properly for CardBus */
-    lp = (struct wl_private *)dev->priv;
+    lp = dev->priv;
 
     if( lp->hcfCtx.IFB_BusType == CFG_NIC_BUS_TYPE_CARDBUS ||
 	    lp->hcfCtx.IFB_BusType == CFG_NIC_BUS_TYPE_PCI 		) {
-- 
1.7.0.4

