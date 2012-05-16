Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2EPGd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:33:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7723 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584Ab2EPGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:33:24 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/4] serial: bfin_uart: narrow the reboot condition in DMA tx interrupt
Date: Wed, 16 May 2012 14:22:24 +0800
Message-ID: <1337149346-5277-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
References: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Check if xmit buffer pointers are set to zero.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 9acab11..56b95b0 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -532,7 +532,7 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 		 */
 		UART_CLEAR_IER(uart, ETBEI);
 		uart->port.icount.tx += uart->tx_count;
-		if (!uart_circ_empty(xmit)) {
+		if (!(xmit->tail == 0 && xmit->head == 0)) {
 			xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
 
 			if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-- 
1.7.0.4


