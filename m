Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0HEWgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:36:04 -0400
Received: from kroah.org ([198.145.64.141]:37708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760862Ab0HEWY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/67] 8250: fix set_ldisc operation
Date: Thu,  5 Aug 2010 15:23:12 -0700
Message-Id: <1281047014-23429-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ldisc number now gets passed into ->set_ldisc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index bc8ed4b..355148d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2404,14 +2404,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
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
1.7.2

