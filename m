Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab2BXQBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:01:38 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53192 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757115Ab2BXQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:36 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] cris/eth_v10: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:12 +0100
Message-Id: <1330099282-4588-3-git-send-email-danny.kukawka@bisect.de>
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
 drivers/net/cris/eth_v10.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7cb2785..e450d8a 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -424,6 +424,9 @@ e100_set_mac_address(struct net_device *dev, void *p)
 	struct net_local *np = netdev_priv(dev);
 	struct sockaddr *addr = p;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	spin_lock(&np->lock); /* preemption protection */
 
 	/* remember it */
-- 
1.7.8.3

