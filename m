Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993139Ab2KOIuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:50:14 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58342 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992986Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 4/9] MMC: sdio_uart, remove unused member from sdio_uart_port
Date: Thu, 15 Nov 2012 09:49:51 +0100
Message-Id: <1352969396-23760-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty from struct sdio_uart_port is unused. Proper refcounted tty in
tty_port->tty is used instead. So remove the member from that
structure.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/card/sdio_uart.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index d2339ea..369f7ba 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -67,7 +67,6 @@ struct uart_icount {
 struct sdio_uart_port {
 	struct tty_port		port;
 	struct kref		kref;
-	struct tty_struct	*tty;
 	unsigned int		index;
 	struct sdio_func	*func;
 	struct mutex		func_lock;
-- 
1.8.0


