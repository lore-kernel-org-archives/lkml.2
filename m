Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1GUPxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:53:11 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:52083 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751260Ab1GUPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:53:07 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: linux-kernel@vger.kernel.org, chirag.kantharia@hp.com,
        iss_storagedev@hp.com
Subject: [PATCH resend] cpqarray: use pci_dev->revision
Date: Thu, 21 Jul 2011 19:51:17 +0400
User-Agent: KMail/1.9.10
References: <201105131909.56428.sshtylyov@ru.mvista.com>
In-Reply-To: <201105131909.56428.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107211951.17610.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.
It wasn't merged in either 2.6.39 or 3.0 time, hopefully it can be merged to
3.1...

 drivers/block/cpqarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/block/cpqarray.c
===================================================================
--- linux-2.6.orig/drivers/block/cpqarray.c
+++ linux-2.6/drivers/block/cpqarray.c
@@ -620,6 +620,7 @@ static int cpqarray_pci_init(ctlr_info_t
 	}
 	vendor_id = pdev->vendor;
 	device_id = pdev->device;
+	revision  = pdev->revision;
 	irq = pdev->irq;
 
 	for(i=0; i<6; i++)
@@ -632,7 +633,6 @@ static int cpqarray_pci_init(ctlr_info_t
 	}
 
 	pci_read_config_word(pdev, PCI_COMMAND, &command);
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cache_line_size);
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency_timer);
 
