Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab1LGQlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:41:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662Ab1LGQWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.192561888@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:56 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [054/104] bridge: correct IPv6 checksum after pull
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

commit fa2da8cdae1dd64f78fc915ca1d1a4a93c71e7cb upstream.

Bridge multicast snooping of ICMPv6 would incorrectly report a checksum problem
when used with Ethernet devices like sky2 that use CHECKSUM_COMPLETE.
When bytes are removed from skb, the computed checksum needs to be adjusted.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Tested-by: Martin Volf <martin.volf.42@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_multicast.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1501,6 +1501,8 @@ static int br_multicast_ipv6_rcv(struct
 
 	__skb_pull(skb2, offset);
 	skb_reset_transport_header(skb2);
+	skb_postpull_rcsum(skb2, skb_network_header(skb2),
+			   skb_network_header_len(skb2));
 
 	icmp6_type = icmp6_hdr(skb2)->icmp6_type;
 


