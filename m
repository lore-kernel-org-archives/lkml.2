Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab2BXQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:01:41 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53219 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757690Ab2BXQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:38 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, Joe Perches <joe@perches.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Weiping Pan" <panweiping3@gmail.com>, Jiri Pirko <jpirko@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] tokenring: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:16 +0100
Message-Id: <1330099282-4588-7-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330099298;9b1f5155;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if given address is valid in .ndo_set_mac_address, if
invalid return -EADDRNOTAVAIL as eth_mac_addr() already does
if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/tokenring/3c359.c       |    4 ++++
 drivers/net/tokenring/lanstreamer.c |    4 ++++
 drivers/net/tokenring/olympic.c     |    4 ++++
 drivers/net/tokenring/tms380tr.c    |    3 +++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index d7c292a..3b7034f 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -56,6 +56,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/trdevice.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
@@ -1498,6 +1499,9 @@ static int xl_set_mac_address (struct net_device *dev, void *addr)
 	struct sockaddr *saddr = addr ; 
 	struct xl_private *xl_priv = netdev_priv(dev);
 
+	if (!is_valid_ether_addr(saddr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	if (netif_running(dev)) { 
 		printk(KERN_WARNING "%s: Cannot set mac/laa address while card is open\n", dev->name) ; 
 		return -EIO ; 
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 8d71e0d..bec9290 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -113,6 +113,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/trdevice.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
@@ -1488,6 +1489,9 @@ static int streamer_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *saddr = addr;
 	struct streamer_private *streamer_priv = netdev_priv(dev);
 
+	if (!is_valid_ether_addr(saddr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	if (netif_running(dev)) 
 	{
 		printk(KERN_WARNING "%s: Cannot set mac/laa address while card is open\n", dev->name);
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index fd8dce9..f41eb41 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -94,6 +94,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/trdevice.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
@@ -1351,6 +1352,9 @@ static int olympic_set_mac_address (struct net_device *dev, void *addr)
 	struct sockaddr *saddr = addr ; 
 	struct olympic_private *olympic_priv = netdev_priv(dev);
 
+	if (!is_valid_ether_addr(saddr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	if (netif_running(dev)) { 
 		printk(KERN_WARNING "%s: Cannot set mac/laa address while card is open\n", dev->name) ; 
 		return -EIO ; 
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index 102f896..3880315 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -2203,6 +2203,9 @@ static int tms380tr_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct net_local *tp = netdev_priv(dev);
 	struct sockaddr *saddr = addr;
+
+	if (!is_valid_ether_addr(saddr->sa_data))
+		return -EADDRNOTAVAIL;
 	
 	if (tp->AdapterOpenFlag || tp->AdapterVirtOpenFlag) {
 		printk(KERN_WARNING "%s: Cannot set MAC/LAA address while card is open\n", dev->name);
-- 
1.7.8.3

