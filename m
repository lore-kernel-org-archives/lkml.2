Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1JYKFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:05:41 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52852 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1JYKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:05:40 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: sfr@canb.auug.org.au, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        N.Voss@weinmann.de, nicolas.ferre@atmel.com
Subject: [PATCH] tty/serial: atmel_serial: fixup merge conflict
Date: Tue, 25 Oct 2011 12:05:29 +0200
Message-Id: <1319537129-7164-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4EA68955.8010102@atmel.com>
References: <4EA68955.8010102@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proper atmel_console_init() merge using platform data.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 358bbb2..9988c0c 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1671,7 +1671,9 @@ static struct console atmel_console = {
 static int __init atmel_console_init(void)
 {
 	if (atmel_default_console_device) {
-		int id = atmel_default_console_device->id;
+		struct atmel_uart_data *pdata =
+			atmel_default_console_device->dev.platform_data;
+		int id = pdata->num;
 		struct atmel_uart_port *port = &atmel_ports[id];
 
 		port->backup_imr = 0;
-- 
1.7.5.4

