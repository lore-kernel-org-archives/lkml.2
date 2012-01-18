Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2ARKWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:22:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ARKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:36 -0500
Date: Wed, 18 Jan 2012 11:22:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH 5/7] serial: sh-sci: prepare for conversion to simple DMA
In-Reply-To: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181118550.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:HqOciCmo6kBhZnzTwRy6by7R6RadNZ+UqK6JkNoUMru
 STJqSMTCCKvMraE2sMVXJbsLnBTlbqklIrKClML5rnXjjaevDS
 lOkav31/WDbJpVc1+jQKtRZ74TRFpnjK5TVVBDIVZElIP1ClA1
 Ye2jypv9SxzsJMhT/KPDKLaUDQ4KGSVnjiWuuXzdFqYgfP71wR
 S/It4eojHUt+AeUd3Hl/oRCixuZBxbHJmroEEURQgml2y210r+
 6Wl6gOkPUiQTTJpFAtvANAl47wVZmE1mYh+rWMXnZPo8UXg+qJ
 Yo0KfQXJ6QNvhVlHOj71Y9/R9KXXsUs3fdbnvpV67n+MaEa8GX
 nIt2aA0JYLw8AyoUpEujw9Fxvp2tK/rJXEZ2CYK6VymvlhXTzG
 iPbCcoK71OqdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/tty/serial/sh-sci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index aff9d61..2a8ffda 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1463,9 +1463,9 @@ static bool filter(struct dma_chan *chan, void *slave)
 	struct sh_dmae_slave *param = slave;
 
 	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
-		param->slave_id);
+		param->simple_slave.slave_id);
 
-	chan->private = param;
+	chan->private = &param->simple_slave;
 	return true;
 }
 
@@ -1504,7 +1504,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_tx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
-	param->slave_id = s->cfg->dma_slave_tx;
+	param->simple_slave.slave_id = s->cfg->dma_slave_tx;
 
 	s->cookie_tx = -EINVAL;
 	chan = dma_request_channel(mask, filter, param);
@@ -1532,7 +1532,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_rx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
-	param->slave_id = s->cfg->dma_slave_rx;
+	param->simple_slave.slave_id = s->cfg->dma_slave_rx;
 
 	chan = dma_request_channel(mask, filter, param);
 	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);
-- 
1.7.2.5

