Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1CNP11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:27:27 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:52312 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752459Ab1CNP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:25 -0400
To: linux-kernel@vger.kernel.org, chirag.kantharia@hp.com,
        iss_storagedev@hp.com
Subject: [PATCH] cpqarray: use pci_dev->revision
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Mon, 14 Mar 2011 18:25:44 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141825.44770.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

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
 
