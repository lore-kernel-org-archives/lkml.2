Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1HFAKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1HFAJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:54 2011
Message-Id: <20110806000254.395145921@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: [55/55] atm: [br2684] allow routed mode operation again
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>

commit 2e302ebfeac04beb5a5d6af1ac583c6a1fb76d1a upstream.

in routed mode, we don't have a hardware address so netdev_ops doesnt
need to validate our hardware address via .ndo_validate_addr

Reported-by: Manuel Fuentes <mfuentes@agenciaefe.com>
Signed-off-by: Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Pascal Hambourg <pascal@plouf.fr.eu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/br2684.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -554,6 +554,12 @@ static const struct net_device_ops br268
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static const struct net_device_ops br2684_netdev_ops_routed = {
+	.ndo_start_xmit 	= br2684_start_xmit,
+	.ndo_set_mac_address	= br2684_mac_addr,
+	.ndo_change_mtu		= eth_change_mtu
+};
+
 static void br2684_setup(struct net_device *netdev)
 {
 	struct br2684_dev *brdev = BRPRIV(netdev);
@@ -569,11 +575,10 @@ static void br2684_setup(struct net_devi
 static void br2684_setup_routed(struct net_device *netdev)
 {
 	struct br2684_dev *brdev = BRPRIV(netdev);
-	brdev->net_dev = netdev;
 
+	brdev->net_dev = netdev;
 	netdev->hard_header_len = 0;
-
-	netdev->netdev_ops = &br2684_netdev_ops;
+	netdev->netdev_ops = &br2684_netdev_ops_routed;
 	netdev->addr_len = 0;
 	netdev->mtu = 1500;
 	netdev->type = ARPHRD_PPP;


