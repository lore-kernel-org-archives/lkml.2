Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0LAXoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:44:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756369Ab0LAXn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:43:58 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX181yHhIYYQ1oA4KQErFiGaei/Vyl5vEm0XnahrHNM
	AOnhxe2+QmcUZN
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Allyn <mark.a.allyn@intel.com>, Alan Cox <alan@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/3] staging/sep: Fix printk format warning
Date: Thu,  2 Dec 2010 00:43:34 +0100
Message-Id: <1291247014-21525-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20101201225214.GA15796@kroah.com>
References: <20101201225214.GA15796@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes gcc's complaints about the wrong format string for
size_t arguments:
"format '%x' expects type 'unsigned int', but argument has type
'size_t'"

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20101202

 drivers/staging/sep/sep_driver.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 2216bed..f2c216d 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -110,7 +110,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->resident_addr);
 	dev_dbg(&sep->pdev->dev, "resident bus is %lx\n",
 		(unsigned long)sep->resident_bus);
-	dev_dbg(&sep->pdev->dev, "resident size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "resident size is %08zx\n",
 		sep->resident_size);
 
 	/* Set addresses for dcache (no loading needed) */
@@ -144,7 +144,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->cache_addr);
 	dev_dbg(&sep->pdev->dev, "cache bus is %08lx\n",
 		(unsigned long)sep->cache_bus);
-	dev_dbg(&sep->pdev->dev, "cache size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "cache size is %08zx\n",
 		sep->cache_size);
 
 	/* Set addresses and load extapp */
@@ -165,7 +165,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->extapp_addr);
 	dev_dbg(&sep->pdev->dev, "extapp bus is %08llx\n",
 		(unsigned long long)sep->extapp_bus);
-	dev_dbg(&sep->pdev->dev, "extapp size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "extapp size is %08zx\n",
 		sep->extapp_size);
 
 	return error;
@@ -205,7 +205,7 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 		return -ENOMEM;
 	}
 	dev_dbg(&sep->pdev->dev,
-		"shared_addr %x bytes @%p (bus %llx)\n",
+		"shared_addr %zx bytes @%p (bus %llx)\n",
 				sep->shared_size, sep->shared_addr,
 				(unsigned long long)sep->shared_bus);
 	return 0;
@@ -3290,7 +3290,7 @@ static int sep_callback(unsigned long sep_context_pointer)
 		error = -ENOMEM;
 		goto end_function;
 	}
-	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx, size is %x\n",
+	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx, size is %zx\n",
 			sep->rar_addr, (unsigned long long)sep->rar_bus,
 			sep->rar_size);
 
@@ -3537,7 +3537,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		}
 
 		dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-			" size is %x\n", sep->rar_addr,
+			" size is %zx\n", sep->rar_addr,
 			(unsigned long long)sep->rar_bus,
 			sep->rar_size);
 	}
-- 
1.7.2.2

