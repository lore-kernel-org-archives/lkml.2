Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2G3Gn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:43:59 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:14195
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab2G3Gn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:43:57 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h107ahff4o)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <davem@davemloft.net>
CC: <axel.lin@gmail.com>, <rmk+kernel@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <kuninori.morimoto.gx@renesas.com>,
        <ralf@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        <sonic.zhang@analog.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] drivers: net: irda: bfin_sir: fix compile error
Date: Mon, 30 Jul 2012 14:44:12 +0800
Message-ID: <1343630652-7220-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Bit IREN is replaced by UMOD_IRDA and UMOD_MASK since blackfin 60x added, but
this driver didn't update which will cause bfin_sir build error:

drivers/net/irda/bfin_sir.c:161:9: error: 'IREN' undeclared (first use in this
function)
drivers/net/irda/bfin_sir.c:435:18: error: 'IREN' undeclared (first use in
this function)
drivers/net/irda/bfin_sir.c:521:11: error: 'IREN' undeclared (first use in
this function)

This patch fix it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/net/irda/bfin_sir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
index a561ae4..c6a0299 100644
--- a/drivers/net/irda/bfin_sir.c
+++ b/drivers/net/irda/bfin_sir.c
@@ -158,7 +158,7 @@ static int bfin_sir_set_speed(struct bfin_sir_port *port, int speed)
 	/* If not add the 'RPOLC', we can't catch the receive interrupt.
 	 * It's related with the HW layout and the IR transiver.
 	 */
-	val |= IREN | RPOLC;
+	val |= UMOD_IRDA | RPOLC;
 	UART_PUT_GCTL(port, val);
 	return ret;
 }
@@ -432,7 +432,7 @@ static void bfin_sir_shutdown(struct bfin_sir_port *port, struct net_device *dev
 	bfin_sir_stop_rx(port);
 
 	val = UART_GET_GCTL(port);
-	val &= ~(UCEN | IREN | RPOLC);
+	val &= ~(UCEN | UMOD_MASK | RPOLC);
 	UART_PUT_GCTL(port, val);
 
 #ifdef CONFIG_SIR_BFIN_DMA
@@ -518,10 +518,10 @@ static void bfin_sir_send_work(struct work_struct *work)
 	 * reset all the UART.
 	 */
 	val = UART_GET_GCTL(port);
-	val &= ~(IREN | RPOLC);
+	val &= ~(UMOD_MASK | RPOLC);
 	UART_PUT_GCTL(port, val);
 	SSYNC();
-	val |= IREN | RPOLC;
+	val |= UMOD_IRDA | RPOLC;
 	UART_PUT_GCTL(port, val);
 	SSYNC();
 	/* bfin_sir_set_speed(port, self->speed); */
-- 
1.7.9.5


