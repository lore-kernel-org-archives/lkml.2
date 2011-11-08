Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1KHGo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:44:56 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41885 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1KHGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:44:54 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID pA86iljM031475, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH] r8169: increase the delay parameter of pm_schedule_suspend
Date: Tue, 8 Nov 2011 14:44:37 +0800
X-BOX-Message-Id: pA86iljM031475
Message-ID: <1320734677-1372-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.6.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The link down would occur when reseting PHY. And it would take about 2 ~ 5 seconds
from link down to link up. If the delay of pm_schedule_suspend is not long enough,
the device would enter runtime_suspend before link up. After link up, the device
would wake up and reset PHY again. Then, you would find the driver keep in a loop
of runtime_suspend and rumtime_resume.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 92b45f0..6f06aa1 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1292,7 +1292,7 @@ static void __rtl8169_check_link_status(struct net_device *dev,
 		netif_carrier_off(dev);
 		netif_info(tp, ifdown, dev, "link down\n");
 		if (pm)
-			pm_schedule_suspend(&tp->pci_dev->dev, 100);
+			pm_schedule_suspend(&tp->pci_dev->dev, 5000);
 	}
 	spin_unlock_irqrestore(&tp->lock, flags);
 }
-- 
1.7.6.2

