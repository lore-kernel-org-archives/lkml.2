Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2JJXOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:14:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52689 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054Ab2JJXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:54 -0400
X-Sasl-enc: jwF6Y1vfmHs/l6nUzikM4yARvmevpnh8cF4ncLwy5g5A 1349910113
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antonio Quartulli <ordex@autistici.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 033/122] 8021q: fix mac_len recomputation in vlan_untag()
Date: Thu, 11 Oct 2012 07:53:19 +0900
Message-Id: <20121010225344.098063405@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Antonio Quartulli <ordex@autistici.org>

[ Upstream commit 5316cf9a5197eb80b2800e1acadde287924ca975 ]

skb_reset_mac_len() relies on the value of the skb->network_header pointer,
therefore we must wait for such pointer to be recalculated before computing
the new mac_len value.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -105,7 +105,6 @@ static struct sk_buff *vlan_reorder_head
 		return NULL;
 	memmove(skb->data - ETH_HLEN, skb->data - VLAN_ETH_HLEN, 2 * ETH_ALEN);
 	skb->mac_header += VLAN_HLEN;
-	skb_reset_mac_len(skb);
 	return skb;
 }
 
@@ -139,6 +138,8 @@ struct sk_buff *vlan_untag(struct sk_buf
 
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
+	skb_reset_mac_len(skb);
+
 	return skb;
 
 err_free:


