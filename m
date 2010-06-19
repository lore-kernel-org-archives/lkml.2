Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0FSWlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 18:41:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:48469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752479Ab0FSWlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 18:41:42 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/lh5UuiPvlc2ExeyxAKKUnL5c6Km3tSLF0Ma6kxD
	NhtZDjZo+t8sfE
Date: Sun, 20 Jun 2010 00:41:39 +0200
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH] lasi82596: fix netdev_mc_count conversion
Message-ID: <20100619224139.GA6158@p100.box>
References: <20100619223524.GA6018@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619223524.GA6018@p100.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix commit 4cd24eaf0 (net: use netdev_mc_count and netdev_mc_empty when
appropriate)

Signed-off-by: Helge Deller <deller@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jiri Pirko <jpirko@redhat.com>

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
 

