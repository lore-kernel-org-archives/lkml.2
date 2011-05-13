Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab1EMPL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:11:26 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:42535 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755838Ab1EMPLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:11:25 -0400
To: linux-kernel@vger.kernel.org, chirag.kantharia@hp.com,
        iss_storagedev@hp.com
Subject: [PATCH resend] cpqarray: use pci_dev->revision
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Fri, 13 May 2011 19:09:56 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105131909.56428.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.
It wasn't merged in 2.6.39 time, I hope it can be merged to 2.6.40...

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
 
