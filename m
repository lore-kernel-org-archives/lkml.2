Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2L1Tob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:44:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55206 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab2L1TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:11 -0500
Message-Id: <20121228190354.805270790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 117/173] bcma: mips: fix clearing device IRQ
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit cbbc0138efe1dcd5426b8fc5d87741f5057aee72 upstream.

We were using wrong IRQ number so clearing wasn't working at all.
Depending on a platform this could result in a one device having two
interrupts assigned. On BCM4706 this resulted in all IRQs being broken.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bcma/driver_mips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c45ded8..792daad 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
 	else
-		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
 
 	/* assign the new one */
 	if (irq == 0) {


