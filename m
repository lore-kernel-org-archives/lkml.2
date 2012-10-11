Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab2JKCWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:22:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40143 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934364Ab2JKCOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:39 -0400
X-Sasl-enc: 31kTn880JtkAFMNL/imMehOAJRRFXT7iGgRIa7igPD+Q 1349921678
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ed Cashin <ecashin@coraid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/84] aoe: assert AoE packets marked as requiring no checksum
Date: Thu, 11 Oct 2012 11:03:23 +0900
Message-Id: <20121011015424.103308990@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


