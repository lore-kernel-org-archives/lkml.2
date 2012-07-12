Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2GLWhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:37:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab2GLWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Roland Stigge <stigge@antcom.de>,
        Kevin Wells <kevin.wells@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 026/187] lpc_eth: add missing ndo_change_mtu()
Date: Thu, 12 Jul 2012 15:33:02 -0700
Message-Id: <20120712191524.686720602@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e30478598a8476d02e3b00caa89ce1a3b1dad54b ]

lpc_eth does a copy of transmitted skbs to DMA area, without checking
skb lengths, so can trigger buffer overflows :

memcpy(pldat->tx_buff_v + txidx * ENET_MAXF_SIZE, skb->data, len);

One way to get bigger skbs is to allow MTU changes above the 1500 limit.

Calling eth_change_mtu() in ndo_change_mtu() makes sure this cannot
happen.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roland Stigge <stigge@antcom.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
Acked-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1310,6 +1310,7 @@ static const struct net_device_ops lpc_n
 	.ndo_set_rx_mode	= lpc_eth_set_multicast_list,
 	.ndo_do_ioctl		= lpc_eth_ioctl,
 	.ndo_set_mac_address	= lpc_set_mac_address,
+	.ndo_change_mtu		= eth_change_mtu,
 };
 
 static int lpc_eth_drv_probe(struct platform_device *pdev)


