Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1LEKUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:20:34 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47517 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab1LEKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:20:32 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/2] serial: bfin-uart: Add tty ASYNC_CTS_FLOW flag to do CTS flow control.
Date: Mon, 5 Dec 2011 18:13:10 +0800
Message-ID: <1323079991-4855-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_uart.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 61af5ae..2afd307 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -1377,8 +1377,10 @@ static int bfin_serial_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		if (res == NULL)
 			uart->cts_pin = -1;
-		else
+		else {
 			uart->cts_pin = res->start;
+			uart->port.flags |= ASYNC_CTS_FLOW;
+		}
 
 		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
 		if (res == NULL)
-- 
1.7.0.4


