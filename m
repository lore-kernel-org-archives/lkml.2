Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1AYO5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:57:40 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:53325 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1AYO5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:57:38 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tty: serial: altera_uart: add devicetree support
Date: Tue, 25 Jan 2011 15:57:37 +0100
Message-Id: <1295967457-11876-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295966417-11306-1-git-send-email-tklauser@distanz.ch>
References: <1295966417-11306-1-git-send-email-tklauser@distanz.ch>
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.1.25.144515
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to retreive resources from a device tree (currently used in the
out-of-tree nios2 architecture port only).

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/tty/serial/altera_uart.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 7212162..bde59d1 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -567,13 +567,23 @@ static int __devexit altera_uart_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id altera_uart_match[] = {
+	{ .compatible = "altr,uart-1.0", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, altera_uart_match);
+#endif /* CONFIG_OF */
+
 static struct platform_driver altera_uart_platform_driver = {
 	.probe	= altera_uart_probe,
 	.remove	= __devexit_p(altera_uart_remove),
 	.driver	= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= NULL,
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+#ifdef CONFIG_OF
+		.of_match_table	= altera_uart_match,
+#endif
 	},
 };
 
-- 
1.7.0.4

