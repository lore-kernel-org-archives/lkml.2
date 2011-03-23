Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1CWIvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:51:21 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56908 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab1CWIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: [PATCH 2/7] TTY: serial_core, remove unused variable
Date: Wed, 23 Mar 2011 09:49:55 +0100
Message-Id: <1300870200-24405-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/serial_core.c:1980:2: warning: Value stored to 'tty' is never read
        tty = port->tty;
        ^     ~~~~~~~~~

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/serial_core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 733fe8e..d6e7240 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1972,13 +1972,9 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 	struct tty_port *port = &state->port;
 	struct device *tty_dev;
 	struct uart_match match = {uport, drv};
-	struct tty_struct *tty;
 
 	mutex_lock(&port->mutex);
 
-	/* Must be inside the mutex lock until we convert to tty_port */
-	tty = port->tty;
-
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (device_may_wakeup(tty_dev)) {
 		if (!enable_irq_wake(uport->irq))
-- 
1.7.4.1


