Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab0KPEPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:15:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36455
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab0KPEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:15:22 -0500
Date: Mon, 15 Nov 2010 20:15:47 -0800 (PST)
Message-Id: <20101115.201547.193717949.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jesse@nicira.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116113437.4f536d16.sfr@canb.auug.org.au>
References: <20101116113437.4f536d16.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 16 Nov 2010 11:34:37 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "netif_get_vlan_features" [drivers/net/xen-netfront.ko] undefined!
> 
> Caused by commit 58e998c6d23988490162cef0784b19ea274d90bb ("offloading:
> Force software GSO for multiple vlan tags").
> 
> Presumably netif_get_vlan_features needs exporting.

Thanks Stephen, I've just pushed the following fix.

--------------------
net: Export netif_get_vlan_features().

ERROR: "netif_get_vlan_features" [drivers/net/xen-netfront.ko] undefined!

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8725d16..381b8e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1983,6 +1983,7 @@ int netif_get_vlan_features(struct sk_buff *skb, struct net_device *dev)
 	else
 		return 0;
 }
+EXPORT_SYMBOL(netif_get_vlan_features);
 
 /*
  * Returns true if either:
-- 
1.7.3.2

