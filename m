Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2EGWJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:09:52 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51707 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2EGWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:09:50 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] net/bluetooth/bnep/core.c: use constant for ethertype
Date: Tue,  8 May 2012 00:09:35 +0200
Message-Id: <1336428575-28996-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dot1q ethertype number (0x8100) is embedded in the code, although
it is already defined in included headers.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/bluetooth/bnep/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a779ec7..4fab436 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -340,7 +340,7 @@ static inline int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 	}
 
 	/* Strip 802.1p header */
-	if (ntohs(s->eh.h_proto) == 0x8100) {
+	if (ntohs(s->eh.h_proto) == ETH_P_8021Q) {
 		if (!skb_pull(skb, 4))
 			goto badframe;
 		s->eh.h_proto = get_unaligned((__be16 *) (skb->data - 2));
-- 
1.7.10

