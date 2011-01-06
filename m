Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1AFAaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:11 -0500
Received: from kroah.org ([198.145.64.141]:35801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1AFAaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:10 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.871571892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mariusz Kozlowski <mk@lab.zgora.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [076/152] net: Fix header size check for GSO case in recvmsg (af_packet)
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Mariusz Kozlowski <mk@lab.zgora.pl>

[ Upstream commit 54dd76848bf67b9fa40ac0340e5ee9c2876d5393 ]

Parameter 'len' is size_t type so it will never get negative.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/packet/af_packet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1610,9 +1610,11 @@ static int packet_recvmsg(struct kiocb *
 
 		err = -EINVAL;
 		vnet_hdr_len = sizeof(vnet_hdr);
-		if ((len -= vnet_hdr_len) < 0)
+		if (len < vnet_hdr_len)
 			goto out_free;
 
+		len -= vnet_hdr_len;
+
 		if (skb_is_gso(skb)) {
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
 


