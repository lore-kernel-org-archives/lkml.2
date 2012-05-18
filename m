Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031124Ab2ERDHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:07:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40436 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762569Ab2ERCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:31 -0400
Message-Id: <20120518023256.509279794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gerard Lledo <gerard.lledo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/53] sungem: Fix WakeOnLan
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerard Lledo <gerard.lledo@gmail.com>

[ Upstream commit 5a8887d39e1ba5ee2d4ccb94b14d6f2dce5ddfca ]

WakeOnLan was broken in this driver because gp->asleep_wol is a 1-bit
bitfield and it was being assigned WAKE_MAGIC, which is (1 << 5).
gp->asleep_wol remains 0 and the machine never wakes up.  Fixed by casting
gp->wake_on_lan to bool.  Tested on an iBook G4.

Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sun/sungem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index ceab215..c508d6a 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2340,7 +2340,7 @@ static int gem_suspend(struct pci_dev *pdev, pm_message_t state)
 	netif_device_detach(dev);
 
 	/* Switch off chip, remember WOL setting */
-	gp->asleep_wol = gp->wake_on_lan;
+	gp->asleep_wol = !!gp->wake_on_lan;
 	gem_do_stop(dev, gp->asleep_wol);
 
 	/* Unlock the network stack */
-- 
1.7.10.1




