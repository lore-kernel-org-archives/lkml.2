Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2BXQBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:01:37 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53178 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757035Ab2BXQBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:35 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] team: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:15 +0100
Message-Id: <1330099282-4588-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330099295;d0020b6f;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if given address is valid in .ndo_set_mac_address, if
invalid return -EADDRNOTAVAIL as eth_mac_addr() already does
if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/team/team.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8f81805..788650c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -868,6 +868,9 @@ static int team_set_mac_address(struct net_device *dev, void *p)
 	struct team_port *port;
 	struct sockaddr *addr = p;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	dev->addr_assign_type &= ~NET_ADDR_RANDOM;
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
 	rcu_read_lock();
-- 
1.7.8.3

