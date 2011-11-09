Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab1KJDcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:32:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935393Ab1KJDcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:20 2011
Message-Id: <20111109212719.916129729@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [192/262] bridge: leave carrier on for empty bridge
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit b64b73d7d0c480f75684519c6134e79d50c1b341 ]

This resolves a regression seen by some users of bridging.
Some users use the bridge like a dummy device.
They expect to be able to put an IPv6 address on the device
with no ports attached. Although there are better ways of doing
this, there is no reason to not allow it.

Note: the bridge still will reflect the state of ports in the
bridge if there are any added.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_device.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -91,7 +91,6 @@ static int br_dev_open(struct net_device
 {
 	struct net_bridge *br = netdev_priv(dev);
 
-	netif_carrier_off(dev);
 	netdev_update_features(dev);
 	netif_start_queue(dev);
 	br_stp_enable_bridge(br);
@@ -108,8 +107,6 @@ static int br_dev_stop(struct net_device
 {
 	struct net_bridge *br = netdev_priv(dev);
 
-	netif_carrier_off(dev);
-
 	br_stp_disable_bridge(br);
 	br_multicast_stop(br);
 


