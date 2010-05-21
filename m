Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525Ab0EURIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:08:42 -0400
Received: from kroah.org ([198.145.64.141]:50288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934063Ab0EUQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:51:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/25] serial: bfin_sport_uart: add missing mapbase initialization
Date: Fri, 21 May 2010 09:51:33 -0700
Message-Id: <1274460714-11277-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The driver doesn't care about this, but the common serial core wants it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 5dcf5dc..49e7e4f 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -712,6 +712,7 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			ret = -ENXIO;
 			goto out_error_free_peripherals;
 		}
+		sport->port.mapbase = res->start;
 
 		sport->port.irq = platform_get_irq(pdev, 0);
 		if (sport->port.irq < 0) {
@@ -809,7 +810,7 @@ static int __init sport_uart_init(void)
 {
 	int ret;
 
-	pr_info("Serial: Blackfin uart over sport driver\n");
+	pr_info("Blackfin uart over sport driver\n");
 
 	ret = uart_register_driver(&sport_uart_reg);
 	if (ret) {
-- 
1.7.0.3

