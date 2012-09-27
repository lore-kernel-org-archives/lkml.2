Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2I0KiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:38:11 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:61076 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2I0Kg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdAEhAgMVcGE4gJt2+RNQOVaYk8iVg
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447824"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 12/17] staging: ipack: Rename IPACK_MEM_SPACE to IPACK_MEM8_SPACE.
Date: Thu, 27 Sep 2012 12:37:36 +0200
Message-Id: <1348742261-28145-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

There also is a MEM16 space.  This will make it clear which one is
which, once support for MEM16 space is added.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   24 ++++++++++++------------
 drivers/staging/ipack/devices/ipoctal.c |   10 +++++-----
 drivers/staging/ipack/ipack.h           |    2 +-
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 901f657..7127a3b 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -29,17 +29,17 @@ static const u16 tpci200_status_error[] = {
 };
 
 static const size_t tpci200_space_size[IPACK_SPACE_COUNT] = {
-	[IPACK_IO_SPACE]  = TPCI200_IO_SPACE_SIZE,
-	[IPACK_ID_SPACE]  = TPCI200_ID_SPACE_SIZE,
-	[IPACK_INT_SPACE] = TPCI200_INT_SPACE_SIZE,
-	[IPACK_MEM_SPACE] = TPCI200_MEM8_SPACE_SIZE,
+	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_SIZE,
+	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_SIZE,
+	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_SIZE,
+	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_SIZE,
 };
 
 static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
-	[IPACK_IO_SPACE]  = TPCI200_IO_SPACE_INTERVAL,
-	[IPACK_ID_SPACE]  = TPCI200_ID_SPACE_INTERVAL,
-	[IPACK_INT_SPACE] = TPCI200_INT_SPACE_INTERVAL,
-	[IPACK_MEM_SPACE] = TPCI200_MEM8_SPACE_INTERVAL,
+	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_INTERVAL,
+	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_INTERVAL,
+	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_INTERVAL,
+	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_INTERVAL,
 };
 
 static struct tpci200_board *check_slot(struct ipack_device *dev)
@@ -271,12 +271,12 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		goto out_release_ip_space;
 	}
 
-	/* Request MEM space (Bar 4) */
+	/* Request MEM8 space (Bar 5) */
 	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR,
-				 "Carrier MEM space");
+				 "Carrier MEM8 space");
 	if (res) {
 		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
 		goto out_release_ioid_int_space;
@@ -297,7 +297,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	tpci200->mod_mem[IPACK_ID_SPACE] = ioidint_base + TPCI200_ID_SPACE_OFF;
 	tpci200->mod_mem[IPACK_INT_SPACE] =
 		ioidint_base + TPCI200_INT_SPACE_OFF;
-	tpci200->mod_mem[IPACK_MEM_SPACE] =
+	tpci200->mod_mem[IPACK_MEM8_SPACE] =
 		pci_resource_start(tpci200->info->pdev,
 				   TPCI200_MEM8_SPACE_BAR);
 
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 3c8eb64..fb7155c 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -53,7 +53,7 @@ struct ipoctal {
 	struct ipoctal_channel		channel[NR_CHANNELS];
 	unsigned char			write;
 	struct tty_driver		*tty_drv;
-	u8 __iomem			*mem_space;
+	u8 __iomem			*mem8_space;
 	u8 __iomem			*int_space;
 };
 
@@ -306,13 +306,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		return -EADDRNOTAVAIL;
 	}
 
-	region = &ipoctal->dev->region[IPACK_MEM_SPACE];
-	ipoctal->mem_space =
+	region = &ipoctal->dev->region[IPACK_MEM8_SPACE];
+	ipoctal->mem8_space =
 		devm_ioremap_nocache(&ipoctal->dev->dev,
 				     region->start, 0x8000);
 	if (!addr) {
 		dev_err(&ipoctal->dev->dev,
-			"Unable to map slot [%d:%d] MEM space!\n",
+			"Unable to map slot [%d:%d] MEM8 space!\n",
 			bus_nr, slot);
 		return -EADDRNOTAVAIL;
 	}
@@ -359,7 +359,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
 				       ipoctal_irq_handler, ipoctal);
 	/* Dummy write */
-	iowrite8(1, ipoctal->mem_space + 1);
+	iowrite8(1, ipoctal->mem8_space + 1);
 
 	/* Register the TTY device */
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index af95028..e35fe54 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -34,8 +34,8 @@ struct ipack_driver;
 enum ipack_space {
 	IPACK_IO_SPACE    = 0,
 	IPACK_ID_SPACE,
-	IPACK_MEM_SPACE,
 	IPACK_INT_SPACE,
+	IPACK_MEM8_SPACE,
 	/* Dummy for counting the number of entries.  Must remain the last
 	 * entry */
 	IPACK_SPACE_COUNT,
-- 
1.7.10.4

