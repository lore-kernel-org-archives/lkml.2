Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161583Ab1FAJWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:22:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161541Ab1FAIKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:50 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:13 2011
Message-Id: <20110601080312.366883285@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:48 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Egerer <thomas.egerer@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [052/146] ipv6: Remove hoplimit initialization to -1
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Thomas Egerer <thomas.egerer@secunet.com>

[ Upstream commit e965c05dabdabb85af0187952ccd75e43995c4b3 ]

The changes introduced with git-commit a02e4b7d ("ipv6: Demark default
hoplimit as zero.") missed to remove the hoplimit initialization. As a
result, ipv6_get_mtu interprets the return value of dst_metric_raw
(-1) as 255 and answers ping6 with this hoplimit.  This patche removes
the line such that ping6 is answered with the hoplimit value
configured via sysctl.

Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/route.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1970,7 +1970,6 @@ struct rt6_info *addrconf_dst_alloc(stru
 	rt->dst.output = ip6_output;
 	rt->rt6i_dev = net->loopback_dev;
 	rt->rt6i_idev = idev;
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, -1);
 	rt->dst.obsolete = -1;
 
 	rt->rt6i_flags = RTF_UP | RTF_NONEXTHOP;


