Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946391Ab2CPXlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:41:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946347Ab2CPXkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:55 -0400
Message-Id: <20120316233812.915419479@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Wei <lw@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 26/41] IPv6: Fix not join all-router mcast group when forwarding set.
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit d6ddef9e641d1229d4ec841dc75ae703171c3e92 ]

When forwarding was set and a new net device is register,
we need add this device to the all-router mcast group.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -434,6 +434,10 @@ static struct inet6_dev * ipv6_add_dev(s
 	/* Join all-node multicast group */
 	ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
 
+	/* Join all-router multicast group if forwarding is set */
+	if (ndev->cnf.forwarding && dev && (dev->flags & IFF_MULTICAST))
+		ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+
 	return ndev;
 }
 


