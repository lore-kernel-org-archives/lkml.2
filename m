Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2CUVQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:16:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2CUVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:16:44 -0400
Message-Id: <20120321211448.777109178@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:14:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "RongQing.Li" <roy.qing.li@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 6/8] ipv6: Dont dev_hold(dev) in ip6_mc_find_dev_rcu.
In-Reply-To: <20120321211522.GA28233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: RongQing.Li <roy.qing.li@gmail.com>

[ Upstream commit c577923756b7fe9071f28a76b66b83b306d1d001 ]

ip6_mc_find_dev_rcu() is called with rcu_read_lock(), so don't
need to dev_hold().
With dev_hold(), not corresponding dev_put(), will lead to leak.

[ bug introduced in 96b52e61be1 (ipv6: mcast: RCU conversions) ]

Signed-off-by: RongQing.Li <roy.qing.li@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -257,7 +257,6 @@ static struct inet6_dev *ip6_mc_find_dev
 
 		if (rt) {
 			dev = rt->rt6i_dev;
-			dev_hold(dev);
 			dst_release(&rt->dst);
 		}
 	} else


