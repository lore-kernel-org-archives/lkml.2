Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2BHVVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:01 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34148 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757710Ab2BHVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:20:59 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 18/50] mipsnet: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:25 +0100
Message-Id: <1328735457-29986-19-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736059;c0bc06fa;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/mipsnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mipsnet.c b/drivers/net/ethernet/mipsnet.c
index d05b0c9..ebdd56c 100644
--- a/drivers/net/ethernet/mipsnet.c
+++ b/drivers/net/ethernet/mipsnet.c
@@ -281,7 +281,7 @@ static int __devinit mipsnet_probe(struct platform_device *dev)
 	 * Lacking any better mechanism to allocate a MAC address we use a
 	 * random one ...
 	 */
-	random_ether_addr(netdev->dev_addr);
+	dev_hw_addr_random(netdev, netdev->dev_addr);
 
 	err = register_netdev(netdev);
 	if (err) {
-- 
1.7.7.3

