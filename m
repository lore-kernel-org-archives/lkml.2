Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab0GOSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:51:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:44818 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934225Ab0GOSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:51:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/13fglPb31XfeMH3u3VkvLa3HjSYNnwNeuspYoov
	LQUtNpUCXQVEFO
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 11/25] block: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:51:17 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        " =?iso-8859-1?q?M=E1rton?= =?iso-8859-1?q?_N=E9meth?=" 
	<nm127@freemail.hu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152051.18189.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/block/sx8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index b70f0fc..15745e4 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -410,8 +410,8 @@ static void carm_remove_one (struct pci_dev *pdev);
 static int carm_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static const struct pci_device_id carm_pci_tbl[] = {
-	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
-	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
+	{ PCI_VDEVICE(PROMISE, 0x8000), },
+	{ PCI_VDEVICE(PROMISE, 0x8002), },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, carm_pci_tbl);
-- 
1.7.1

