Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1BIO3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:29:12 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:55597 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755014Ab1BIO3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:29:11 -0500
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH v2] atmel_serial: enable PPS support
Date: Wed,  9 Feb 2011 15:26:13 +0100
Message-Id: <1297261573-17244-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297257973-11173-1-git-send-email-plagnioj@jcrosoft.com>
References: <1297257973-11173-1-git-send-email-plagnioj@jcrosoft.com>
X-Ovh-Tracer-Id: 11867547968129641469
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>

Enables PPS support in atmel serial driver to make PPS API working.

Signed-off-by: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
v2:

	forget to update the prototype when rebase to upstream

Best Regards,
J.
 drivers/tty/serial/atmel_serial.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 2a1d52f..f119d17 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1240,6 +1240,21 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
+static void atmel_set_ldisc(struct uart_port *port, int new)
+{
+	int line = port->line;
+
+	if (line >= port->state->port.tty->driver->num)
+		return;
+
+	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+		port->flags |= UPF_HARDPPS_CD;
+		atmel_enable_ms(port);
+	} else {
+		port->flags &= ~UPF_HARDPPS_CD;
+	}
+}
+
 /*
  * Return string describing the specified port
  */
@@ -1380,6 +1395,7 @@ static struct uart_ops atmel_pops = {
 	.shutdown	= atmel_shutdown,
 	.flush_buffer	= atmel_flush_buffer,
 	.set_termios	= atmel_set_termios,
+	.set_ldisc	= atmel_set_ldisc,
 	.type		= atmel_type,
 	.release_port	= atmel_release_port,
 	.request_port	= atmel_request_port,
-- 
1.7.2.3

