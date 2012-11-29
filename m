Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2K2CaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:30:04 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45833 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2K2CaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:30:02 -0500
MIME-Version: 1.0
Date: Wed, 28 Nov 2012 21:30:01 -0500
Message-ID: <CAPgLHd8rsNm8pbQozGrpcB-DWD94Av8dj-98eFh2Efn4nZOzaw@mail.gmail.com>
Subject: [PATCH -next] staging: sb105x: fix potential NULL pointer dereference
 in mp_chars_in_buffer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'state' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/sb105x/sb_pci_mp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index fbebf88..edb2a85 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -689,13 +689,14 @@ static int mp_chars_in_buffer(struct tty_struct *tty)
 static void mp_flush_buffer(struct tty_struct *tty)
 {
 	struct sb_uart_state *state = tty->driver_data;
-	struct sb_uart_port *port = state->port;
+	struct sb_uart_port *port;
 	unsigned long flags;
 
 	if (!state || !state->info) {
 		return;
 	}
 
+	port = state->port;
 	spin_lock_irqsave(&port->lock, flags);
 	uart_circ_clear(&state->info->xmit);
 	spin_unlock_irqrestore(&port->lock, flags);


