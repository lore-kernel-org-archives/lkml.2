Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab1KIUd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:58 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37386 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab1KIUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:54 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 02/10] TTY: serial, cleanup atmel_set_ldisc
Date: Wed,  9 Nov 2011 21:33:44 +0100
Message-Id: <1320870831-23778-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ldisc number is passed as a paramneter -- no need to dig it
out of the tty or ldisc. So switch PPS check to that.

No tty callback can be called with port->line higher than TTY driver
num. So remove the check.

This removes some port.tty users.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 drivers/tty/serial/atmel_serial.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 4a0f86f..6b844d4 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1256,12 +1256,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 static void atmel_set_ldisc(struct uart_port *port, int new)
 {
-	int line = port->line;
-
-	if (line >= port->state->port.tty->driver->num)
-		return;
-
-	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+	if (new == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		atmel_enable_ms(port);
 	} else {
-- 
1.7.7


