Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2JGXn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:43:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38254 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249Ab2JGXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:12 -0400
Message-Id: <20121007225847.689933349@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xiaodong Xu <stid.smth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 094/108] pppoe: drop PPPOX_ZOMBIEs in pppoe_release
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaodong Xu <stid.smth@gmail.com>

[ Upstream commit 2b018d57ff18e5405823e5cb59651a5b4d946d7b ]

When PPPOE is running over a virtual ethernet interface (e.g., a
bonding interface) and the user tries to delete the interface in case
the PPPOE state is ZOMBIE, the kernel will loop forever while
unregistering net_device for the reference count is not decreased to
zero which should have been done with dev_put().

Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ppp/pppoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index bc9a4bb..1161584 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -576,7 +576,7 @@ static int pppoe_release(struct socket *sock)
 
 	po = pppox_sk(sk);
 
-	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
 		dev_put(po->pppoe_dev);
 		po->pppoe_dev = NULL;
 	}


