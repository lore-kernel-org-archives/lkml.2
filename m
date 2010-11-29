Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0K2Vbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:31:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34441 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752682Ab0K2Vbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:31:36 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/TS1cSjWfT283xNsqEQ12p+Bs20uBFw3YgXZv2Hy
	m3cM6aVML6/lpn
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Allyn <mark.a.allyn@intel.com>, Alan Cox <alan@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/3] staging/sep: Fix sparse printk format warning
Date: Mon, 29 Nov 2010 22:31:20 +0100
Message-Id: <1291066280-19126-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291066280-19126-1-git-send-email-peterhuewe@gmx.de>
References: <1291066280-19126-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse's complaints about the wrong format string.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
LinuxVersion: linux-next-20101129

 drivers/staging/sep/sep_driver.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index cf5c897..86e676d 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -112,7 +112,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->resident_addr);
 	dev_dbg(&sep->pdev->dev, "residnet bus is %lx\n",
 		(unsigned long)sep->resident_bus);
-	dev_dbg(&sep->pdev->dev, "resident size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "resident size is %08Zx\n",
 		sep->resident_size);
 
 	/* set addresses for dcache (no loading needed) */
@@ -146,7 +146,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->cache_addr);
 	dev_dbg(&sep->pdev->dev, "cache bus is %08lx\n",
 		(unsigned long)sep->cache_bus);
-	dev_dbg(&sep->pdev->dev, "cache size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "cache size is %08Zx\n",
 		sep->cache_size);
 
 	/* set addresses and load extapp */
@@ -167,7 +167,7 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->extapp_addr);
 	dev_dbg(&sep->pdev->dev, "extapp bus is %08llx\n",
 		(unsigned long long)sep->extapp_bus);
-	dev_dbg(&sep->pdev->dev, "extapp size is %08x\n",
+	dev_dbg(&sep->pdev->dev, "extapp size is %08Zx\n",
 		sep->extapp_size);
 
 	return error;
@@ -210,7 +210,7 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 		return -ENOMEM;
 	}
 	dev_dbg(&sep->pdev->dev,
-		"sep: shared_addr %x bytes @%p (bus %llx)\n",
+		"sep: shared_addr %Zx bytes @%p (bus %llx)\n",
 		sep->shared_size, sep->shared_addr,
 			(unsigned long long)sep->shared_bus);
 	return 0;
@@ -3395,25 +3395,25 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCSENDSEPCOMMAND is %x\n", SEP_IOCSENDSEPCOMMAND);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCALLOCDATAPOLL is %x\n", SEP_IOCALLOCDATAPOLL);
+		"SEP_IOCALLOCDATAPOLL is %lx\n", SEP_IOCALLOCDATAPOLL);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCCREATESYMDMATABLE is %x\n", SEP_IOCCREATESYMDMATABLE);
+		"SEP_IOCCREATESYMDMATABLE is %lx\n", SEP_IOCCREATESYMDMATABLE);
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCFREEDMATABLEDATA is %x\n", SEP_IOCFREEDMATABLEDATA);
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCSEPSTART is %x\n", SEP_IOCSEPSTART);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCSEPINIT is %x\n", SEP_IOCSEPINIT);
+		"SEP_IOCSEPINIT is %lx\n", SEP_IOCSEPINIT);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCGETSTATICPOOLADDR is %x\n", SEP_IOCGETSTATICPOOLADDR);
+		"SEP_IOCGETSTATICPOOLADDR is %lx\n", SEP_IOCGETSTATICPOOLADDR);
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCENDTRANSACTION is %x\n", SEP_IOCENDTRANSACTION);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCREALLOCEXTCACHE is %x\n", SEP_IOCREALLOCEXTCACHE);
+		"SEP_IOCREALLOCEXTCACHE is %lx\n", SEP_IOCREALLOCEXTCACHE);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCRARPREPAREMESSAGE is %x\n", SEP_IOCRARPREPAREMESSAGE);
+		"SEP_IOCRARPREPAREMESSAGE is %lx\n", SEP_IOCRARPREPAREMESSAGE);
 	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCPREPAREDCB is %x\n", SEP_IOCPREPAREDCB);
+		"SEP_IOCPREPAREDCB is %lx\n", SEP_IOCPREPAREDCB);
 	dev_dbg(&sep->pdev->dev,
 		"SEP_IOCFREEDCB is %x\n", SEP_IOCFREEDCB);
 
@@ -3736,7 +3736,7 @@ static int sep_callback(unsigned long sep_context_pointer)
 	}
 
 	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-		" size is %x\n",
+		" size is %Zx\n",
 		sep->rar_addr, (unsigned long long)sep->rar_bus,
 		sep->rar_size);
 
@@ -3864,7 +3864,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		}
 
 		dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-			" size is %x\n", sep->rar_addr,
+			" size is %Zx\n", sep->rar_addr,
 			(unsigned long long)sep->rar_bus,
 			sep->rar_size);
 	}
-- 
1.7.2.2

