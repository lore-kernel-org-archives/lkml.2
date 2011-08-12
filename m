Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1HNQVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:21:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1HNQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.004835094@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Klement Fish <klement2@azet.sk>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [56/90] sis190: Rx filter init is needed for MAC address change.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Klement Fish <klement2@azet.sk>

[ Upstream commit fe66101f14813b77d84f6450d51772a2af2b81a1 ]

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=34552

Signed-off-by: Klement Fish <klement2@azet.sk>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sis190.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -1824,6 +1824,16 @@ static int sis190_ioctl(struct net_devic
 		generic_mii_ioctl(&tp->mii_if, if_mii(ifr), cmd, NULL);
 }
 
+static int sis190_mac_addr(struct net_device  *dev, void *p)
+{
+	int rc;
+
+	rc = eth_mac_addr(dev, p);
+	if (!rc)
+		sis190_init_rxfilter(dev);
+	return rc;
+}
+
 static const struct net_device_ops sis190_netdev_ops = {
 	.ndo_open		= sis190_open,
 	.ndo_stop		= sis190_close,
@@ -1832,7 +1842,7 @@ static const struct net_device_ops sis19
 	.ndo_tx_timeout		= sis190_tx_timeout,
 	.ndo_set_multicast_list = sis190_set_rx_mode,
 	.ndo_change_mtu		= eth_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address	= sis190_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	 = sis190_netpoll,


