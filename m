Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0JKIqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:46:43 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:36119 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0JKIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:46:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 1/1] ATM: mpc, fix use after free
Date: Mon, 11 Oct 2010 10:46:34 +0200
Message-Id: <1286786794-10410-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286785081.2737.2.camel@edumazet-laptop>
References: <1286785081.2737.2.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that mpc_push frees skb and then it dereferences it. It
is a typo, new_skb should be dereferenced there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/atm/mpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 622b471..74bcc66 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -778,7 +778,7 @@ static void mpc_push(struct atm_vcc *vcc, struct sk_buff *skb)
 	eg->packets_rcvd++;
 	mpc->eg_ops->put(eg);
 
-	memset(ATM_SKB(skb), 0, sizeof(struct atm_skb_data));
+	memset(ATM_SKB(new_skb), 0, sizeof(struct atm_skb_data));
 	netif_rx(new_skb);
 }
 
-- 
1.7.3.1


