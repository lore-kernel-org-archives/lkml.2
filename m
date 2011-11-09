Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab1KIUgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:36:35 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37395 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab1KIUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 06/10] TTY: serial, do not touch tty->alt_speed
Date: Wed,  9 Nov 2011 21:33:48 +0100
Message-Id: <1320870831-23778-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used at all, so no need to play any games with that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 036e0cc..4b1dcd3 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -141,8 +141,7 @@ static int uart_startup(struct tty_struct *tty, struct uart_state *state, int in
 
 	/*
 	 * Set the TTY IO error marker - we will only clear this
-	 * once we have successfully opened the port.  Also set
-	 * up the tty->alt_speed kludge
+	 * once we have successfully opened the port.
 	 */
 	set_bit(TTY_IO_ERROR, &tty->flags);
 
@@ -1499,7 +1498,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = state;
 	state->uart_port->state = state;
 	tty->low_latency = (state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
-	tty->alt_speed = 0;
 	tty_port_tty_set(port, tty);
 
 	/*
-- 
1.7.7


