Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab1LFIdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:33:04 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:37645
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932984Ab1LFIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:33:03 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] serial: bfin-sport-uart: Add tty ASYNC_CTS_FLOW flag to do CTS flow control.
Date: Tue, 6 Dec 2011 16:22:34 +0800
Message-ID: <1323159754-15687-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_sport_uart.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index f650526..7fbc3a0 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -810,8 +810,10 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		if (res == NULL)
 			sport->cts_pin = -1;
-		else
+		else {
 			sport->cts_pin = res->start;
+			sport->port.flags |= ASYNC_CTS_FLOW;
+		}
 
 		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
 		if (res == NULL)
-- 
1.7.0.4


