Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0EaNBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:01:23 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:58473 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0EaNBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:01:22 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] altera_uart: Proper section for altera_uart_remove
Date: Mon, 31 May 2010 15:01:08 +0200
Message-Id: <1275310868-21071-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.31.124815
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

altera_uart_remove should be in .devexit.text

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/serial/altera_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index bcee156..6dc22b0 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -516,7 +516,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int altera_uart_remove(struct platform_device *pdev)
+static int __devexit altera_uart_remove(struct platform_device *pdev)
 {
 	struct uart_port *port;
 	int i;
-- 
1.6.3.3

