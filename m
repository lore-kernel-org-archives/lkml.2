Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0HCDKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:10:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61905 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0HCDKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vAQs/WsiQF4Kk1uR6bFds1tYduRzSzx1APw11EY88C6CSzSgYbwHr0/MfUsdRLoQeM
         qr8xdvKaeJgHMgGJh4o5n2abowgAhkf5N3P9Pk5l0Y5PzFUA1Mju7oouxudyhrX59L78
         wpydrXojhVUyVcMRoQocjlM7e5FcgP3306rGQ=
Subject: [PATCH] Fixes a typo from "dev" to "ndev"
From: Henrique Camargo <henrique.camargo@ensitec.com.br>
To: David Miller <davem@davemloft.net>
Cc: chaithrika@ti.com, srk@ti.com, khilman@deeprootsystems.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, segooon@gmail.com
In-Reply-To: <20100730.222034.183058824.davem@davemloft.net>
References: <AANLkTiko540hMAUhaJr5mNKzFK2-vBOTZmEOxZWZv7ci@mail.gmail.com>
	 <20100730.222034.183058824.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 00:10:42 -0300
Message-ID: <1280805042.2089.6.camel@lemming>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typo was causing compilation errors since "dev" was not defined.

Signed-off-by: Henrique Camargo <henrique.camargo@ensitec.com.br>
---
 drivers/net/davinci_emac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index 25e14d2..b89b7bf 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -1182,8 +1182,8 @@ static int emac_net_tx_complete(struct emac_priv *priv,
 	struct net_device *ndev = priv->ndev;
 	u32 cnt;
 
-	if (unlikely(num_tokens && netif_queue_stopped(dev)))
-		netif_start_queue(dev);
+	if (unlikely(num_tokens && netif_queue_stopped(ndev)))
+		netif_start_queue(ndev);
 	for (cnt = 0; cnt < num_tokens; cnt++) {
 		struct sk_buff *skb = (struct sk_buff *)net_data_tokens[cnt];
 		if (skb == NULL)
-- 
1.7.0.4



