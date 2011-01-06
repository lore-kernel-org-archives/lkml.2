Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1AFAaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:16 -0500
Received: from kroah.org ([198.145.64.141]:35816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab1AFAaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:14 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.175800062@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>, Andrej Ota <andrej@ota.si>,
        "David S. Miller" <davem@davemloft.net>
Subject: [079/152] pppoe.c: Fix kernel panic caused by __pppoe_xmit
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Andrej Ota <andrej@ota.si>

[ Upstream commit 2a27a03d3a891e87ca33d27a858b4db734a4cbab ]

__pppoe_xmit function return value was invalid resulting in
additional call to kfree_skb on already freed skb. This resulted in
memory corruption and consequent kernel panic after PPPoE peer
terminated the link.

This fixes commit 55c95e738da85373965cb03b4f975d0fd559865b.

Reported-by: Gorik Van Steenberge <gvs@zemos.net>
Reported-by: Daniel Kenzelmann <kernel.bugzilla@kenzelmann.dyndns.info>
Reported-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Reported-by: Pawel Staszewski <pstaszewski@artcom.pl>
Diagnosed-by: Andrej Ota <andrej@ota.si>
Diagnosed-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Tested-by: Pawel Staszewski <pstaszewski@artcom.pl>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Andrej Ota <andrej@ota.si>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/pppoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pppoe.c
+++ b/drivers/net/pppoe.c
@@ -948,7 +948,7 @@ static int __pppoe_xmit(struct sock *sk,
 
 abort:
 	kfree_skb(skb);
-	return 0;
+	return 1;
 }
 
 /************************************************************************


