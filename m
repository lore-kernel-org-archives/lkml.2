Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161536Ab1FAIKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161508Ab1FAIK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:29 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:09 2011
Message-Id: <20110601080309.221593021@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:44 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [048/146] bridge: fix forwarding of IPv6
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit cb68552858c64db302771469b1202ea09e696329 ]

The commit 6b1e960fdbd75dcd9bcc3ba5ff8898ff1ad30b6e
    bridge: Reset IPCB when entering IP stack on NF_FORWARD
broke forwarding of IPV6 packets in bridge because it would
call bp_parse_ip_options with an IPV6 packet.

Reported-by: Noah Meyerhans <noahm@debian.org>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_netfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -739,7 +739,7 @@ static unsigned int br_nf_forward_ip(uns
 		nf_bridge->mask |= BRNF_PKT_TYPE;
 	}
 
-	if (br_parse_ip_options(skb))
+	if (pf == PF_INET && br_parse_ip_options(skb))
 		return NF_DROP;
 
 	/* The physdev module checks on this */


