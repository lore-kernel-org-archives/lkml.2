Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0ITXn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:43:27 -0400
Received: from kroah.org ([198.145.64.141]:48455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0ITXnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:43:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@iki.fi>, Alan Cox <alan@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] serial: amba-pl010: fix set_ldisc
Date: Mon, 20 Sep 2010 16:43:18 -0700
Message-Id: <1285026199-2380-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100920234209.GB7672@kroah.com>
References: <20100920234209.GB7672@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@iki.fi>

Commit d87d9b7d1 ("tty: serial - fix tty referencing in set_ldisc") changed
set_ldisc to take ldisc number as parameter. This patch fixes AMBA PL010 driver
according the new prototype.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/amba-pl010.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index 50441ff..2904aa0 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -472,14 +472,9 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
-static void pl010_set_ldisc(struct uart_port *port)
+static void pl010_set_ldisc(struct uart_port *port, int new)
 {
-	int line = port->line;
-
-	if (line >= port->state->port.tty->driver->num)
-		return;
-
-	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+	if (new == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		pl010_enable_ms(port);
 	} else
-- 
1.7.2

