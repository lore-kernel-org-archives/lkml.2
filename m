Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab2EIPJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:09:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798Ab2EIPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:34 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 7/9 v3] usb: renesas_usbhs: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:19 +0200
Message-Id: <1336576161-27082-8-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:RkBDURr3l066X6NVqF1uNdMJdHg2LN2EpPaOb/gIdsO
 k0aF4L05/UwffaP60I++ujqRtjbE+5tCmY2s24JPqLkMDy9QKI
 rqtS6HOzFbrUV+uBS5BLQzoTMdoE+lC7ARQUvf2O654GMCkZCd
 96xEDEcx/ER9h17MkR/Mk4ZjMVIVjbSV0PdxAH3mvdE67+9UiD
 gKwPuumzYjRaWYMQ4EmDj1TsWbHpa0AcAFs1Lr4FJsLk/jw+3X
 uK1T1qIm9Lnbb6ADW8IIWMbW+AEI3CdXQiDcVZOZ5zDzIw4voI
 +rQ8qIIqVvn061fFX/aSdz9NmYPk0Mj6f6JBbr6XjpwNpOtLws
 LUSoItYaq/yfXlJBK2JhaUUlCKTHtV80MpYM7/YmHvCKdOxg7H
 J8rcXzlRbbe8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/fifo.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 6ec7f83..fc597a4 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -994,7 +994,7 @@ static bool usbhsf_dma_filter(struct dma_chan *chan, void *param)
 	 *
 	 * usbhs doesn't recognize id = 0 as valid DMA
 	 */
-	if (0 == slave->slave_id)
+	if (0 == slave->shdma_slave.slave_id)
 		return false;
 
 	chan->private = slave;
@@ -1173,8 +1173,8 @@ int usbhs_fifo_probe(struct usbhs_priv *priv)
 	fifo->port	= D0FIFO;
 	fifo->sel	= D0FIFOSEL;
 	fifo->ctr	= D0FIFOCTR;
-	fifo->tx_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
-	fifo->rx_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
+	fifo->tx_slave.shdma_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
+	fifo->rx_slave.shdma_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
 
 	/* D1FIFO */
 	fifo = usbhsf_get_d1fifo(priv);
@@ -1182,8 +1182,8 @@ int usbhs_fifo_probe(struct usbhs_priv *priv)
 	fifo->port	= D1FIFO;
 	fifo->sel	= D1FIFOSEL;
 	fifo->ctr	= D1FIFOCTR;
-	fifo->tx_slave.slave_id	= usbhs_get_dparam(priv, d1_tx_id);
-	fifo->rx_slave.slave_id	= usbhs_get_dparam(priv, d1_rx_id);
+	fifo->tx_slave.shdma_slave.slave_id	= usbhs_get_dparam(priv, d1_tx_id);
+	fifo->rx_slave.shdma_slave.slave_id	= usbhs_get_dparam(priv, d1_rx_id);
 
 	return 0;
 }
-- 
1.7.2.5

