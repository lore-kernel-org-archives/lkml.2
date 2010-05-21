Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0EUNVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:21:05 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:49032 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753774Ab0EUNVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:21:02 -0400
Date: Fri, 21 May 2010 15:16:38 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless
 cards.
Message-ID: <20100521131638.GA22685@comet.dominikbrodowski.net>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF5974A.4050100@gmail.com>
 <4BF57515.6030404@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

would you be willing to test another patch? This one replaces the previous
version, and makes the readb() conditional at the right place (hopefully,
that is).

Thanks & best,

	Dominik


diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 424e576..6bf8b2c 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -975,7 +975,7 @@ static irqreturn_t yenta_probe_handler(int irq, void *dev_id)
 /* probes the PCI interrupt, use only on override functions */
 static int yenta_probe_cb_irq(struct yenta_socket *socket)
 {
-	u8 reg;
+	u8 reg = 0;
 
 	if (!socket->cb_irq)
 		return -1;
@@ -989,7 +989,8 @@ static int yenta_probe_cb_irq(struct yenta_socket *socket)
 	}
 
 	/* generate interrupt, wait */
-	reg = exca_readb(socket, I365_CSCINT);
+	if (!socket->dev->irq)
+		reg = exca_readb(socket, I365_CSCINT);
 	exca_writeb(socket, I365_CSCINT, reg | I365_CSC_STSCHG);
 	cb_writel(socket, CB_SOCKET_EVENT, -1);
 	cb_writel(socket, CB_SOCKET_MASK, CB_CSTSMASK);
