Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab0KLVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:26 -0500
Received: from kroah.org ([198.145.64.141]:41622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab0KLVlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/19] serial: bfin_5xx: remove redundant SSYNC to improve TX speed
Date: Fri, 12 Nov 2010 13:41:02 -0800
Message-Id: <1289598066-10112-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

We don't need to force a SSYNC here as the LSR register will already
be updated by the time we get back to reading it.  This speeds up TX
throughput and lowers general system overhead (since SSYNC is system
wide, not peripheral-specific).

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index c8ca3b4..a454e42 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -359,7 +359,6 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 		UART_PUT_CHAR(uart, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		uart->port.icount.tx++;
-		SSYNC();
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-- 
1.7.1

