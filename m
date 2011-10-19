Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1JSJgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:36:45 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:15981 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1JSJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:36:44 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, linux-serial@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] tty/serial: atmel_serial: bootconsole removed from auto-enumerates
Date: Wed, 19 Oct 2011 11:36:20 +0200
Message-Id: <1319016980-10355-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318981651741@kroah.org>
References: <1318981651741@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Auto-enumerate mechanism conflicts with bootconsoles: remove
the usage counter for this type of consoles.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 30d8c77..9988c0c 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1676,7 +1676,6 @@ static int __init atmel_console_init(void)
 		int id = pdata->num;
 		struct atmel_uart_port *port = &atmel_ports[id];
 
-		set_bit(id, &atmel_ports_in_use);
 		port->backup_imr = 0;
 		port->uart.line = id;
 
-- 
1.7.5.4

