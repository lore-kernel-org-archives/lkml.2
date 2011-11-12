Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1KLVbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 16:31:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47220 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1KLVbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 16:31:10 -0500
From: Alexander Beregalov <a.beregalov@gmail.com>
To: jgarzik@redhat.com
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] libata: fix build without BMDMA
Date: Sun, 13 Nov 2011 01:30:56 +0400
Message-Id: <1321133456-15875-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix these errors:
drivers/ata/libata-sff.c:2538:3: error: implicit declaration of function
'ata_pci_bmdma_prepare_host'
drivers/ata/libata-sff.c:2549:40: error: 'ata_bmdma_interrupt'
undeclared (first use in this function)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

I'm not sure if it is better than declaration fake functions.

drivers/ata/libata-sff.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 63d5327..4cadfa2 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2533,10 +2533,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 
+#ifdef CONFIG_ATA_BMDMA
 	if (bmdma)
 		/* prepare and activate BMDMA host */
 		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	else
+#endif
 		/* prepare and activate SFF host */
 		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
@@ -2544,10 +2546,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	host->private_data = host_priv;
 	host->flags |= hflags;
 
+#ifdef CONFIG_ATA_BMDMA
 	if (bmdma) {
 		pci_set_master(pdev);
 		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 	} else
+#endif
 		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
-- 
1.7.8.rc1

