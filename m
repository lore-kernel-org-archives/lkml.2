Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab0FUUuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:50:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52331
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758491Ab0FUUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:50:38 -0400
Date: Mon, 21 Jun 2010 13:50:50 -0700 (PDT)
Message-Id: <20100621.135050.48492866.davem@davemloft.net>
To: deller@gmx.de
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-parisc@vger.kernel.org, kyle@mcmartin.ca, jpirko@redhat.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] lasi82596: fix netdev_mc_count conversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100619224139.GA6158@p100.box>
References: <20100619223524.GA6018@p100.box>
	<20100619224139.GA6158@p100.box>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Deller <deller@gmx.de>
Date: Sun, 20 Jun 2010 00:41:39 +0200

> Fix commit 4cd24eaf0 (net: use netdev_mc_count and netdev_mc_empty when
> appropriate)
> 
> Signed-off-by: Helge Deller <deller@gmx.de>

Applied, please CC: netdev@vger.kernel.org when posting networking
patches in the future, thanks.

> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Kyle McMartin <kyle@mcmartin.ca>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Jiri Pirko <jpirko@redhat.com>
> 
> --- a/drivers/net/lib82596.c
> +++ b/drivers/net/lib82596.c
> @@ -1343,7 +1343,7 @@ static void set_multicast_list(struct net_device *dev)
>  	DEB(DEB_MULTI,
>  	    printk(KERN_DEBUG
>  		   "%s: set multicast list, %d entries, promisc %s, allmulti %s\n",
> -		   dev->name, dev->mc_count,
> +		   dev->name, netdev_mc_count(dev),
>  		   dev->flags & IFF_PROMISC ? "ON" : "OFF",
>  		   dev->flags & IFF_ALLMULTI ? "ON" : "OFF"));
>  
> 
