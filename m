Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634Ab1KJFGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:06:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934317Ab1KJD1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:15 2011
Message-Id: <20111109212715.211947810@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zheng Yan <zheng.z.yan@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [145/262] ipv6: nullify ipv6_ac_list and ipv6_fl_list when creating new socket
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit 676a1184e8afd4fed7948232df1ff91517400859 ]

ipv6_ac_list and ipv6_fl_list from listening socket are inadvertently
shared with new socket created for connection.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/tcp_ipv6.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1409,6 +1409,8 @@ static struct sock * tcp_v6_syn_recv_soc
 		newtp->af_specific = &tcp_sock_ipv6_mapped_specific;
 #endif
 
+		newnp->ipv6_ac_list = NULL;
+		newnp->ipv6_fl_list = NULL;
 		newnp->pktoptions  = NULL;
 		newnp->opt	   = NULL;
 		newnp->mcast_oif   = inet6_iif(skb);
@@ -1473,6 +1475,7 @@ static struct sock * tcp_v6_syn_recv_soc
 	   First: no IPv4 options.
 	 */
 	newinet->inet_opt = NULL;
+	newnp->ipv6_ac_list = NULL;
 	newnp->ipv6_fl_list = NULL;
 
 	/* Clone RX bits */


