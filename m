Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0FAU46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:56:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab0FAUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 31/31] 8250: fix set_ldisc operation
Date: Tue,  1 Jun 2010 22:53:11 +0200
Message-Id: <1275425591-8803-32-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/E5ziaXljua5jH/MaKCnymbnaIOmbXUpfB8+X
 ctdCzlpzkg1yIHsNEF6r/cQjVumWR2byJ+LK2xFYv+R4PIA1kO
 QjYKvX9l5zNuViu+nQ/Qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ldisc number now gets passed into ->set_ldisc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/serial/8250.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 891e1dd..93c8358 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2409,14 +2409,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 }
 
 static void
-serial8250_set_ldisc(struct uart_port *port)
+serial8250_set_ldisc(struct uart_port *port, int new)
 {
-	int line = port->line;
-
-	if (line >= port->state->port.tty->driver->num)
-		return;
-
-	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+	if (new == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		serial8250_enable_ms(port);
 	} else
-- 
1.7.0.4

