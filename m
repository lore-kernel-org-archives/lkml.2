Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab0EWIgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:36:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34304 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0EWIgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:36:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2] serial: bfin_5xx: fix typo in IER check
Date: Sun, 23 May 2010 04:40:14 -0400
Message-Id: <1274604014-26239-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274604014-26239-1-git-send-email-vapier@gentoo.org>
References: <1274604014-26239-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

This most likely won't cause problems on systems as people don't typically
enable GPIO RTS/CTS if they don't actually use it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a78652b..511cbf6 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -797,7 +797,7 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		gpio_free(uart->rts_pin);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (UART_GET_IER(uart) && EDSSI)
+	if (UART_GET_IER(uart) & EDSSI)
 		free_irq(uart->status_irq, uart);
 #endif
 }
-- 
1.7.1

