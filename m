Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab2EIPJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:09:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab2EIPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:35 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/9 v3] serial: sh-sci: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:17 +0200
Message-Id: <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:/aO7wv5aG26NkuXiO6w2k4xZ5DQgpFNX5uDwR0GytUh
 kUpR4NcMkKEZegw5TqBSoIbmiVezjlUsEk5fLTb5wkMqT3BLkb
 wYck2aEF/Oe8vxY6BYmrec86aKWW9x8mma+FOrfsD6h1e6UlI8
 drSG61Kr4S1WcuwbPJgA4RIPZ6XN45UROV/c7aNfiVs8FO4nm5
 m6gHF4Gz2QR3b4bMc5Jvmc/ei5wCIfAQ/a9alZ6PDaOI92IcTU
 zqq7FJwM0UG9JYf7dtoXq7o2Pyv30/wv43IIGnr0cF73zks/5g
 SvqHnIiK9WmDyM1V6G7qRHL+lbaQeuPinSDaQ2+JLpCSe6zAZw
 CX4W2mUZF/hw3JwTebd/64v9YyNNTUE/Qc6RMICmFmywro8Mub
 bl8BcQvR8FOUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/sh-sci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index bf461cf..49e3b2a 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1579,9 +1579,9 @@ static bool filter(struct dma_chan *chan, void *slave)
 	struct sh_dmae_slave *param = slave;
 
 	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
-		param->slave_id);
+		param->shdma_slave.slave_id);
 
-	chan->private = param;
+	chan->private = &param->shdma_slave;
 	return true;
 }
 
@@ -1620,7 +1620,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_tx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
-	param->slave_id = s->cfg->dma_slave_tx;
+	param->shdma_slave.slave_id = s->cfg->dma_slave_tx;
 
 	s->cookie_tx = -EINVAL;
 	chan = dma_request_channel(mask, filter, param);
@@ -1648,7 +1648,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_rx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
-	param->slave_id = s->cfg->dma_slave_rx;
+	param->shdma_slave.slave_id = s->cfg->dma_slave_rx;
 
 	chan = dma_request_channel(mask, filter, param);
 	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);
-- 
1.7.2.5

