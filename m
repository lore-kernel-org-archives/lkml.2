Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2L1TzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:55:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54995 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420Ab2L1TRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:12 -0500
Message-Id: <20121228190400.573975731@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 155/173] ne2000: add the right platform device
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit da9da01d9199b5bb15289d0859053c9aa3a34ac0 ]

Without this udev doesn't have a way to key the ne device to the platform
device.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/8390/ne.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 1063093..e8ee2bc 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -814,6 +814,7 @@ static int __init ne_drv_probe(struct platform_device *pdev)
 		dev->irq = irq[this_dev];
 		dev->mem_end = bad[this_dev];
 	}
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	err = do_ne_probe(dev);
 	if (err) {
 		free_netdev(dev);


