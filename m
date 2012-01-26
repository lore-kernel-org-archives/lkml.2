Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2AZO56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:57:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2AZO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:34 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 5/7 v2] serial: sh-sci: prepare for conversion to simple DMA
Date: Thu, 26 Jan 2012 15:56:22 +0100
Message-Id: <1327589784-4287-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:uYnHs/EGebhMSNt1ATVlWju827O0CUJM7ipc4DcJ/43
 jSQCUzadx6v5Dy+AJvGkpESZNpJ5hu0PUeFL4nf6yE0Alzdu+U
 1qj3vQRYIFPFRxKborrmyzRcRsb7wu0FBFxRH+dQlj969+fcqS
 mrSXdUR2ipLnDnppOhIFO33nYDHjDIKlAQC5yjOHMymWPkPoJY
 XRal2ihhhZHYgA4bynwEyZbjBYfLn+cOD8LGGOZXaYaPmgn8tR
 hS0WG+0CqBVQw22jiW2HLbN8cI9oF75fEV/FiZMQWgJM60PCpG
 FKta90y8rlPDIR2IetVNOGXqWv9h6vqQ4jGMm9R/n/4LiK6wD5
 t3Kp5NL0sL9XEngaQbbe+DB/QUqy5nA0FHv6w3Yjz+tua0Xbtj
 KHFumFX7V4xGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/tty/serial/sh-sci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 7508579..8b99aac 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1574,9 +1574,9 @@ static bool filter(struct dma_chan *chan, void *slave)
 	struct sh_dmae_slave *param = slave;
 
 	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
-		param->slave_id);
+		param->simple_slave.slave_id);
 
-	chan->private = param;
+	chan->private = &param->simple_slave;
 	return true;
 }
 
@@ -1615,7 +1615,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_tx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
-	param->slave_id = s->cfg->dma_slave_tx;
+	param->simple_slave.slave_id = s->cfg->dma_slave_tx;
 
 	s->cookie_tx = -EINVAL;
 	chan = dma_request_channel(mask, filter, param);
@@ -1643,7 +1643,7 @@ static void sci_request_dma(struct uart_port *port)
 	param = &s->param_rx;
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
-	param->slave_id = s->cfg->dma_slave_rx;
+	param->simple_slave.slave_id = s->cfg->dma_slave_rx;
 
 	chan = dma_request_channel(mask, filter, param);
 	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);
-- 
1.7.2.5

