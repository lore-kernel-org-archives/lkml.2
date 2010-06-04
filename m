Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0FDUsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:48:07 -0400
Received: from kroah.org ([198.145.64.141]:44015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0FDUsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/11] serial: bfin_5xx: fix typo in IER check
Date: Fri,  4 Jun 2010 13:47:50 -0700
Message-Id: <1275684477-20172-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

This most likely won't cause problems on systems as people don't typically
enable GPIO RTS/CTS if they don't actually use it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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

