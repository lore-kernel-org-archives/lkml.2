Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2JJW72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:59:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41002 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863Ab2JJWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:55:28 -0400
X-Sasl-enc: 3Tx9I78d/n/IashQoAn0fJ7QQoqnE0MAPoG3ngN2Tlwq 1349909727
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ed Cashin <ecashin@coraid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 058/133] aoe: assert AoE packets marked as requiring no checksum
Date: Thu, 11 Oct 2012 07:51:24 +0900
Message-Id: <20121010224904.949594725@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ed Cashin <ecashin@coraid.com>

[ Upstream commit 8babe8cc6570ed896b7b596337eb8fe730c3ff45 ]

In order for the network layer to see that AoE requires
no checksumming in a generic way, the packets must be
marked as requiring no checksum, so we make this requirement
explicit with the assertion.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/aoe/aoecmd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -35,6 +35,7 @@ new_skb(ulong len)
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);
+		skb_checksum_none_assert(skb);
 	}
 	return skb;
 }


