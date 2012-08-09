Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2HIIuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:50:22 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30581 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab2HIIuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:50:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <dan.j.williams@intel.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <vinod.koul@intel.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v7 8/8] carma: remove unnecessary DMA_INTERRUPT capability
Date: Thu, 9 Aug 2012 16:23:31 +0800
Message-ID: <1344500611-11178-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

These drivers set the DMA_INTERRUPT capability bit when requesting a DMA
controller channel. This was historical, and is no longer needed.

Recent changes to the drivers/dma/fsldma.c driver have removed support
for this flag. This makes the carma drivers unable to find a DMA channel
with the required capabilities.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
Based on git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
against branch char-misc-next.

 drivers/misc/carma/carma-fpga-program.c |    1 -
 drivers/misc/carma/carma-fpga.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index a2d25e4..eaddfe9 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -978,7 +978,6 @@ static int fpga_of_probe(struct platform_device *op)
 	dev_set_drvdata(priv->dev, priv);
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
-	dma_cap_set(DMA_INTERRUPT, mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	dma_cap_set(DMA_SG, mask);

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 8c279da..0c43297 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -666,7 +666,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	src = SYS_FPGA_BLOCK;
 	tx = chan->device->device_prep_dma_memcpy(chan, dst, src,
 						  REG_BLOCK_SIZE,
-						  DMA_PREP_INTERRUPT);
+						  0);
 	if (!tx) {
 		dev_err(priv->dev, "unable to prep SYS-FPGA DMA\n");
 		return -ENOMEM;
--
1.7.5.1


