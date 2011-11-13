Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1KMVIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:08:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13434 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1KMVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:08:48 -0500
Date: Sun, 13 Nov 2011 22:14:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Andrey Yurovsky <andrey@cozybit.com>, Colin McCabe <colin@cozybit.com>,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] Net, libertas: Resolve memory leak in
 if_spi_host_to_card()
Message-ID: <alpine.LNX.2.00.1111132211580.3368@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we hit the default case in the switch in if_spi_host_to_card() we'll leak
the memory we allocated for 'packet'. This patch resolves the leak by freeing
the allocated memory in that case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/libertas/if_spi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

 Compile tested only due to lack of hardware.

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 11b69b3..728baa4 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -995,6 +995,7 @@ static int if_spi_host_to_card(struct lbs_private *priv,
 		spin_unlock_irqrestore(&card->buffer_lock, flags);
 		break;
 	default:
+		kfree(packet);
 		netdev_err(priv->dev, "can't transfer buffer of type %d\n",
 			   type);
 		err = -EINVAL;
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

