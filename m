Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0H2RM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:12:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0H2RM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rqWC0WdP18LEIVIrac5WQkUwnkLJix2dRXASVA/F7WQMYuli3tfaNf8vDQLJ6CuHQE
         he8GJJzHOG0jxHASHc/Uv8S5DoNGxp7LTarfHYXMPj0AKLyymejEPJrbXX6jjnixhSw4
         RAG82PiJmMZImY7+H2AH7Rt1nGASwmTMmPi0k=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@iki.fi>, Alan Cox <alan@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] serial: amba-pl010: fix set_ldisc
Date: Sun, 29 Aug 2010 20:12:45 +0300
Message-Id: <1283101965-12161-1-git-send-email-mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d87d9b7d1 ("tty: serial - fix tty referencing in set_ldisc") changed
set_ldisc to take ldisc number as parameter. This patch fixes AMBA PL010 driver
according the new prototype.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
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
1.5.6.5

