Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0KSWVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:21:19 -0500
Received: from kroah.org ([198.145.64.141]:45269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab0KSV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:55 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.593157144@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [59/82] gianfar: fix double lock typo
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 9756403b16cfeda85efe77e62832a2f6b5752fdf ]

This should be a _restore() instead of a _save().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/gianfar_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -538,7 +538,7 @@ static int gfar_set_rx_csum(struct net_d
 
 		unlock_tx_qs(priv);
 		unlock_rx_qs(priv);
-		local_irq_save(flags);
+		local_irq_restore(flags);
 
 		for (i = 0; i < priv->num_rx_queues; i++)
 			gfar_clean_rx_ring(priv->rx_queue[i],


