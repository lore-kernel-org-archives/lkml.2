Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1BEUmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:42:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29551 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1BEUmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:42:36 -0500
Date: Sat, 5 Feb 2011 21:41:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Daniele Venzano <venza@brownhat.org>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sis900: Fix mem leak in sis900_rx error path
Message-ID: <alpine.LNX.2.00.1102052139150.12305@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in error path of sis900_rx(). If we don't do this we'll 
leak the skb we dev_alloc_skb()'ed just a few lines above when the 
variable goes out of scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sis900.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index 5976d1d..640e368 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1777,6 +1777,7 @@ static int sis900_rx(struct net_device *net_dev)
 					      "cur_rx:%4.4d, dirty_rx:%4.4d\n",
 					      net_dev->name, sis_priv->cur_rx,
 					      sis_priv->dirty_rx);
+				dev_kfree_skb(skb);
 				break;
 			}
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

