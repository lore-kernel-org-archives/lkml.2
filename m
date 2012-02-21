Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2BUMIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:08:51 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:57452 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab2BUMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:08:13 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] br_device: unify return value of .ndo_set_mac_address if address is invalid
Date: Tue, 21 Feb 2012 13:07:52 +0100
Message-Id: <1329826072-14689-5-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
References: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329826093;e34312e9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify return value of .ndo_set_mac_address if the given address
isn't valid. Return -EADDRNOTAVAIL as eth_mac_addr() already does
if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/bridge/br_device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a157bf8..ba829de 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -167,7 +167,7 @@ static int br_set_mac_address(struct net_device *dev, void *p)
 	struct sockaddr *addr = p;
 
 	if (!is_valid_ether_addr(addr->sa_data))
-		return -EINVAL;
+		return -EADDRNOTAVAIL;
 
 	spin_lock_bh(&br->lock);
 	if (compare_ether_addr(dev->dev_addr, addr->sa_data)) {
-- 
1.7.8.3

