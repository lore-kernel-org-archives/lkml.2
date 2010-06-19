Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0FSWfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 18:35:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:34698 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752259Ab0FSWf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 18:35:29 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX180UD8zGks0vG/KTG5CstJw2btBk4uXm5UlQU5bPO
	L6V4m7ss1VHfaY
Date: Sun, 20 Jun 2010 00:35:24 +0200
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH] lasi82596: fix netdev_mc_count conversion
Message-ID: <20100619223524.GA6018@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix commit 4cd24eaf0 (net: use netdev_mc_count and netdev_mc_empty when
appropriate)

--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -1343,7 +1343,7 @@ static void set_multicast_list(struct net_device *dev)
 	DEB(DEB_MULTI,
 	    printk(KERN_DEBUG
 		   "%s: set multicast list, %d entries, promisc %s, allmulti %s\n",
-		   dev->name, dev->mc_count,
+		   dev->name, netdev_mc_count(dev),
 		   dev->flags & IFF_PROMISC ? "ON" : "OFF",
 		   dev->flags & IFF_ALLMULTI ? "ON" : "OFF"));
 
