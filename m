Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1J1LxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:53:05 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:38937 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1J1LxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:53:03 -0400
X-Greylist: delayed 1147 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 07:53:03 EDT
From: Sven Schnelle <svens@stackframe.org>
To: nicolas.ferre@atmel.com
Cc: svens@stackframe.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty/serial: atmel_serial: fix compilation
Date: Fri, 28 Oct 2011 13:33:51 +0200
Message-Id: <1319801631-14654-1-git-send-email-svens@stackframe.org>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF is disabled, compilation fails with:

drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
drivers/tty/serial/atmel_serial.c:1788: error: implicit declaration of function 'of_alias_get_id'

Fix this by adding the proper CONFIG_OF checks.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 drivers/tty/serial/atmel_serial.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 4a0f86f..de338dd 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1777,16 +1777,20 @@ static int atmel_serial_resume(struct platform_device *pdev)
 static int __devinit atmel_serial_probe(struct platform_device *pdev)
 {
 	struct atmel_uart_port *port;
+#ifdef CONFIG_OF
 	struct device_node *np = pdev->dev.of_node;
+#endif
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
 	void *data;
 	int ret = -ENODEV;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
+#ifdef CONFIG_OF
 	if (np)
 		ret = of_alias_get_id(np, "serial");
 	else
+#endif
 		if (pdata)
 			ret = pdata->num;
 
-- 
1.7.6.3

