Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1IVJGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:06:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1IVJFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:05:54 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Joe Perches <joe@perches.com>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 41/55] pcmcia: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:08 +0800
Message-Id: <1316681962-8217-42-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/pcmcia/db1xxx_ss.c  |    4 ++--
 drivers/pcmcia/soc_common.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/db1xxx_ss.c b/drivers/pcmcia/db1xxx_ss.c
index 3e49df6..6d76a92 100644
--- a/drivers/pcmcia/db1xxx_ss.c
+++ b/drivers/pcmcia/db1xxx_ss.c
@@ -162,12 +162,12 @@ static int db1x_pcmcia_setup_irqs(struct db1x_pcmcia_sock *sock)
 	 */
 	if (sock->board_type == BOARD_TYPE_DB1200) {
 		ret = request_irq(sock->insert_irq, db1200_pcmcia_cdirq,
-				  IRQF_DISABLED, "pcmcia_insert", sock);
+				  0, "pcmcia_insert", sock);
 		if (ret)
 			goto out1;
 
 		ret = request_irq(sock->eject_irq, db1200_pcmcia_cdirq,
-				  IRQF_DISABLED, "pcmcia_eject", sock);
+				  0, "pcmcia_eject", sock);
 		if (ret) {
 			free_irq(sock->insert_irq, sock);
 			goto out1;
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a0a9c2a..0493a31 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -535,7 +535,7 @@ int soc_pcmcia_request_irqs(struct soc_pcmcia_socket *skt,
 		if (irqs[i].sock != skt->nr)
 			continue;
 		res = request_irq(irqs[i].irq, soc_common_pcmcia_interrupt,
-				  IRQF_DISABLED, irqs[i].str, skt);
+				  0, irqs[i].str, skt);
 		if (res)
 			break;
 		irq_set_irq_type(irqs[i].irq, IRQ_TYPE_NONE);
-- 
1.7.4.1

