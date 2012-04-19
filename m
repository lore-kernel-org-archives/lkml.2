Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2DSLEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:04:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54495 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab2DSLEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:04:08 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Henk de Groot <pe1dnn@amsat.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/wlags49_h2/wl_pci.c: add missing wl_device_dealloc and wl_remove
Date: Thu, 19 Apr 2012 13:03:58 +0200
Message-Id: <1334833438-23016-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The need for wl_device_dealloc is motivated by the error-handling code for
the failure of wl_adapter_insert.  The need for wl_remove in the third case
is motivated by the code in the definition of wl_pci_remove.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/staging/wlags49_h2/wl_pci.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 3df990c..0b31b01 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -524,6 +524,7 @@ int wl_pci_setup( struct pci_dev *pdev )
     /* Make sure that space was allocated for our private adapter struct */
     if( dev->priv == NULL ) {
         DBG_ERROR( DbgInfo, "Private adapter struct was not allocated!!!\n" );
+	wl_device_dealloc(dev);
         DBG_LEAVE( DbgInfo );
         return -ENOMEM;
     }
@@ -532,6 +533,7 @@ int wl_pci_setup( struct pci_dev *pdev )
     /* Allocate DMA Descriptors */
     if( wl_pci_dma_alloc( pdev, dev->priv ) < 0 ) {
         DBG_ERROR( DbgInfo, "Could not allocate DMA descriptor memory!!!\n" );
+	wl_device_dealloc(dev);
         DBG_LEAVE( DbgInfo );
         return -ENOMEM;
     }
@@ -561,6 +563,8 @@ int wl_pci_setup( struct pci_dev *pdev )
     result = request_irq(dev->irq, wl_isr, SA_SHIRQ, dev->name, dev);
     if( result ) {
         DBG_WARNING( DbgInfo, "Could not register ISR!!!\n" );
+	wl_remove(dev);
+	wl_device_dealloc(dev);
         DBG_LEAVE( DbgInfo );
         return result;
 	}

