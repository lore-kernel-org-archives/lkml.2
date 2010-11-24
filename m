Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0KXT6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:58:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47185 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932087Ab0KXT6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:58:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/12] sep: Use kzalloc when needed
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:38:21 +0000
Message-ID: <20101124193814.16425.9000.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index f576285..ff9df36 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -3343,16 +3343,13 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	}
 
 	/* allocate the sep_device structure for this device */
-	sep_dev = kmalloc(sizeof(struct sep_device), GFP_ATOMIC);
+	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
 	if (sep_dev == NULL) {
 		dev_warn(&pdev->dev,
 			"can't kmalloc the sep_device structure\n");
 		return -ENOMEM;
 	}
 
-	/* zero out sep structure */
-	memset((void *)sep_dev, 0, sizeof(struct sep_device));
-
 	/*
 	 * we're going to use another variable for actually
 	 * working with the device; this way, if we have
@@ -3365,8 +3362,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	if (pdev->device == MRST_PCI_DEVICE_ID)
 		sep->mrst = 1;
-	else
-		sep->mrst = 0;
 
 	dev_dbg(&sep->pdev->dev, "PCI obtained, device being prepared\n");
 	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
@@ -3423,7 +3418,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 			goto end_function_deallocate_sep_shared_area;
 		}
 	} else {
-
 		sep->rar_size = FAKE_RAR_SIZE;
 		sep->rar_addr = dma_alloc_coherent(NULL,
 			sep->rar_size, &sep->rar_bus, GFP_KERNEL);

