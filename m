Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab2JJWzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:55:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55231 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757877Ab2JJWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:55:20 -0400
X-Sasl-enc: 6YELBySY/uyKnKLgmxKAM+BG2nztxJmbrNzurfOzBkVb 1349909719
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 055/133] l2tp: fix a typo in l2tp_eth_dev_recv()
Date: Thu, 11 Oct 2012 07:51:21 +0900
Message-Id: <20121010224904.408557885@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c0cc88a7627c333de50b07b7c60b1d49d9d2e6cc ]

While investigating l2tp bug, I hit a bug in eth_type_trans(),
because not enough bytes were pulled in skb head.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -148,7 +148,7 @@ static void l2tp_eth_dev_recv(struct l2t
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, skb->data, length);
 	}
 
-	if (!pskb_may_pull(skb, sizeof(ETH_HLEN)))
+	if (!pskb_may_pull(skb, ETH_HLEN))
 		goto error;
 
 	secpath_reset(skb);


