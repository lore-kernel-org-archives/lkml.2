Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408Ab2CNSDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:03:00 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:33979 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761394Ab2CNSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:02:59 -0400
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Subject: [PATCH 1/3] atp870u: use pci_dev->revision
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Wed, 14 Mar 2012 22:02:11 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203142202.11514.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the current Linus' tree.

 drivers/scsi/atp870u.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/atp870u.c
===================================================================
--- linux-2.6.orig/drivers/scsi/atp870u.c
+++ linux-2.6/drivers/scsi/atp870u.c
@@ -2583,7 +2583,7 @@ static int atp870u_probe(struct pci_dev 
 	 * this than via the PCI device table
 	 */
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
+		atpdev->chip_ver = pdev->revision;
 		if (atpdev->chip_ver < 2)
 			goto err_eio;
 	}
@@ -2602,7 +2602,7 @@ static int atp870u_probe(struct pci_dev 
 	base_io &= 0xfffffff8;
 
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
+		atpdev->chip_ver = pdev->revision;
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
 		host_id = inb(base_io + 0x39);
