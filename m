Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2BXNrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:47:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43974 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757456Ab2BXNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:39 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] ixgbevf: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:56 +0100
Message-Id: <1330091162-8141-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091199;e20e0528;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index e10221d..581c659 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3462,13 +3462,7 @@ static int __devinit ixgbevf_probe(struct pci_dev *pdev,
 	ixgbevf_init_last_counter_stats(adapter);
 
 	/* print the MAC address */
-	hw_dbg(hw, "%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x\n",
-	       netdev->dev_addr[0],
-	       netdev->dev_addr[1],
-	       netdev->dev_addr[2],
-	       netdev->dev_addr[3],
-	       netdev->dev_addr[4],
-	       netdev->dev_addr[5]);
+	hw_dbg(hw, "%pM\n", netdev->dev_addr);
 
 	hw_dbg(hw, "MAC: %d\n", hw->mac.type);
 
-- 
1.7.8.3

