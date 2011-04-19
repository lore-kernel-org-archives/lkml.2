Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1DSU2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:28:07 -0400
Received: from kroah.org ([198.145.64.141]:47661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1DSURI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.714917006@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Weber <uweber@astaro.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [24/70] pppoe: drop PPPOX_ZOMBIEs in pppoe_flush_dev
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ulrich Weber <uweber@astaro.com>

[ Upstream commit ae07b0b221b6ab2edf9e3abd518aec6cd3f1ba66 ]

otherwise we loop forever if a PPPoE socket was set
to PPPOX_ZOMBIE state by a PADT message when the
ethernet device is going down afterwards.

Signed-off-by: Ulrich Weber <uweber@astaro.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/pppoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pppoe.c
+++ b/drivers/net/pppoe.c
@@ -317,7 +317,7 @@ static void pppoe_flush_dev(struct net_d
 			lock_sock(sk);
 
 			if (po->pppoe_dev == dev &&
-			    sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+			    sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
 				pppox_unbind_sock(sk);
 				sk->sk_state = PPPOX_ZOMBIE;
 				sk->sk_state_change(sk);


