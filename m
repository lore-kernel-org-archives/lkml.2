Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2AGPUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 10:20:13 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:49932 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2AGPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 10:20:12 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jan 2012 10:20:11 EST
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] r6040: fix typo in use of MCR0 register bits
Date: Sat,  7 Jan 2012 13:13:17 -0200
Message-Id: <1325949197-10143-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4e16d6ebd65b4f2c4e3f780b4c5704beef64019c (r6040: define more MCR0
register bits) added #define values for MCR0 register bits and converted
uses of hardcoded magic values to uses of these defines.

However, one of the conversions looks suspicious:

 #define MCR0		0x00	/* Control register 0 */
+#define  MCR0_RCVEN	0x0002	/* Receive enable */
+#define  MCR0_XMTEN	0x1000	/* Transmission enable */

 	/* Init RDC private data */
-	lp->mcr0 = 0x1002;
+	lp->mcr0 = MCR0_XMTEN | MCR0;

I believe what was meant here was MCR0_XMTEN | MCR0_RCVEN, which makes
sense and matches the original values.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 drivers/net/ethernet/rdc/r6040.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 87aa439..cb0eca8 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1160,7 +1160,7 @@ static int __devinit r6040_init_one(struct pci_dev *pdev,
 	lp->dev = dev;
 
 	/* Init RDC private data */
-	lp->mcr0 = MCR0_XMTEN | MCR0;
+	lp->mcr0 = MCR0_XMTEN | MCR0_RCVEN;
 
 	/* The RDC-specific entries in the device structure. */
 	dev->netdev_ops = &r6040_netdev_ops;
-- 
1.7.7.5

