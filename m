Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab1ESSTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:19:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43422 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933978Ab1ESSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:27 -0400
X-Sasl-enc: 2cYtvA/P1IDZHg7zG7JAblDWTTMPB14CthQ/m6a0OvOh 1305828506
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.083451803@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [29/71] can: fix SJA1000 dlc for RTR packets
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kurt Van Dijck <kurt.van.dijck@eia.be>

commit 87e9af6cc67d842cd92b52b81f3f14e665e7ab05 upstream.

RTR frames do have a valid data length code on CAN.
The driver for SJA1000 did not handle that situation properly.

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/sja1000/sja1000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -346,10 +346,10 @@ static void sja1000_rx(struct net_device
 		    | (priv->read_reg(priv, REG_ID2) >> 5);
 	}
 
+	cf->can_dlc = get_can_dlc(fi & 0x0F);
 	if (fi & FI_RTR) {
 		id |= CAN_RTR_FLAG;
 	} else {
-		cf->can_dlc = get_can_dlc(fi & 0x0F);
 		for (i = 0; i < cf->can_dlc; i++)
 			cf->data[i] = priv->read_reg(priv, dreg++);
 	}


