Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab1KRJbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:31:08 -0500
Received: from www17.your-server.de ([213.133.104.17]:48435 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab1KRJ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:25 -0500
Subject: [PATCH] net: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: samuel@sortiz.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.307.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/net/irda/irttp.c b/net/irda/irttp.c
--- a/net/irda/irttp.c 2011-11-07 19:39:06.071138486 +0100
+++ b/net/irda/irttp.c 2011-11-08 10:59:07.152748948 +0100
@@ -1461,14 +1461,13 @@ struct tsap_cb *irttp_dup(struct tsap_cb
 	}
 
 	/* Allocate a new instance */
-	new = kmalloc(sizeof(struct tsap_cb), GFP_ATOMIC);
+	new = kmemdup(orig, sizeof(struct tsap_cb), GFP_ATOMIC);
 	if (!new) {
 		IRDA_DEBUG(0, "%s(), unable to kmalloc\n", __func__);
 		spin_unlock_irqrestore(&irttp->tsaps->hb_spinlock, flags);
 		return NULL;
 	}
 	/* Dup */
-	memcpy(new, orig, sizeof(struct tsap_cb));
 	spin_lock_init(&new->lock);
 
 	/* We don't need the old instance any more */
